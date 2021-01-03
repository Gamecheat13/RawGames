#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_dev_class;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_killcam;

#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_helicopter_gunner;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_uav;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\mp\_teamops;

#precache( "eventstring", "testPlayerScoreForTan" );

#namespace dev;
/#
function autoexec __init__sytem__() {     system::register("dev",&__init__,undefined,"spawnlogic");    }
#/
	
function __init__()
{
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connected );

	level.devOnGetOrMakeBot = &getOrMakeBot;
}	

function init()
{
	/#		
	if (GetDvarString( "scr_showspawns") == "")
	{
		SetDvar("scr_showspawns", "0");
	}
	if (GetDvarString( "scr_showstartspawns") == "")
	{
		SetDvar("scr_showstartspawns", "0");
	}
	if (GetDvarString( "scr_botsHasPlayerWeapon") == "")
	{
		SetDvar("scr_botsHasPlayerWeapon", "0");
	}
	if (GetDvarString( "scr_botsGrenadesOnly") == "")
	{
		SetDvar("scr_botsGrenadesOnly", "0");
	}
	if (GetDvarString( "scr_botsSpecialGrenadesOnly") == "")
	{
		SetDvar("scr_botsSpecialGrenadesOnly", "0");
	}
	if (GetDvarString( "scr_show_hq_spawns") == "")
	{
		SetDvar("scr_show_hq_spawns", "");
	}
	if(GetDvarString( "scr_testScriptRuntimeError") == "" )
	{
		SetDvar( "scr_testScriptRuntimeError", "0" );
	}

	thread testScriptRuntimeError();
	thread testDvars();
	thread addTestClients();
	thread addEnemyHeli();
	thread addTestCarePackage();
	thread removeTestClients();
	thread watch_botsdvars();
	thread devHeliPathDebugDraw();
	thread devStrafeRunPathDebugDraw();
	thread dev_class::dev_cac_init();
	thread globallogic_score::setPlayerMomentumDebug();

	
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

			if ( isdefined( points ) && points.size > 0 )
			{
				level.dem_spawns = ArrayCombine( level.dem_spawns, points, true, false );
			}
		}
	}
	
	for(;;)
	{
		updateDevSettings();
		wait .5;
	}
	#/
}

function on_player_connected()
{
/#
	if ( ( isdefined( level.devgui_unlimited_ammo ) && level.devgui_unlimited_ammo ) )
	{
		wait( 1 );
		self thread devgui_unlimited_ammo();
	}
#/
}

/#
function updateHardpoints()
{
	keys = getarraykeys( level.killstreaks );
	for ( i = 0; i < keys.size; i++ )
	{
		dvar = level.killstreaks[keys[i]].devDvar;
		enemyDvar = level.killstreaks[keys[i]].devEnemyDvar;
		
		host = util::getHostPlayer();
		
		if( isdefined( dvar ) && getdvarint( dvar ) == 1 )
		{
			if( keys[i] == "helicopter_gunner" )
			{
				if( isdefined( level.vtol ) )
					iprintln( "There is a VTOL still in the air" );
				else
					host killstreaks::give( "inventory_" + keys[i] );
			}
			else
			{
				foreach ( player in level.players )
				{
					if ( ( isdefined( level.usingMomentum ) && level.usingMomentum ) && ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks ) )
					{
						player killstreaks::give( "inventory_" + keys[i] );
					}
					else
					{
						if ( player util::is_bot() )
						{
							player.bot[ "killstreaks" ] = [];
							player.bot[ "killstreaks" ][0] = killstreaks::get_menu_name( keys[i] );

							killstreakWeapon = killstreaks::get_killstreak_weapon( keys[i] );
							player killstreaks::give_weapon( killstreakWeapon, true );

							globallogic_score::_setPlayerMomentum( player, 2000 );
						}
						else
						{
							player killstreaks::give( "inventory_" + keys[i] );
						}
					}
				}
			}
		
			SetDvar( dvar, "0" );
		}
		
		if( isdefined( enemyDvar ) && getdvarint( enemyDvar ) == 1 )
		{
			team = "autoassign";
			player = util::getHostPlayer();
			if( isdefined( player.team ) )
			{
				team = util::getOtherTeam( player.team );
			}
	
			ent = getOrMakeBot( team );
	
			if( !isdefined( ent ) ) 
			{
				println("Could not add test client");
				continue;
			}
		
			wait( 1 );
			ent killstreaks::give( "inventory_" + keys[i] );
			SetDvar( enemyDvar, "0" );
		}
	}
}

function updateTeamOps()
{
	teamops = GetDvarString( level.teamops_dvar );
	if ( GetDvarString( level.teamops_dvar ) != "" )
	{
		teamops::startTeamops( teamops );
		SetDvar( level.teamops_dvar, "" );
	}
}

function warpAllToHost( team )
{
		host = util::getHostPlayer();
		warpAllToPlayer( team, host.name );
}

function warpAllToPlayer( team, player )
{
	players = GetPlayers();
	target = undefined;
	for ( i = 0; i< players.size; i++ )
	{
		if ( players[i].name == player )
		{
			target = players[i];
			break;
		}
	}
	
	if ( isDefined( target ) )
	{	
		origin = target.origin;
	
		nodes = GetNodesInRadius( origin, 128, 32, 128, "Path" );
		
		angles = target GetPlayerAngles();
		yaw	= ( 0.0, angles[1], 0.0 );
	
		forward = AnglesToForward( yaw );
	
		spawn_origin = origin + ( forward * 128 ) + ( 0, 0, 16 );
	
		if ( !BulletTracePassed( target GetEye(), spawn_origin, false, target ) )
		{
			spawn_origin = undefined;
		}
	
		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( players[i] == target )
			{
				continue;
			}
	
			if ( isdefined(team) )
			{
				if ( StrStartsWith( team,"enemies_" ) && target.team == players[i].team )
					continue;
				if ( StrStartsWith( team, "friendlies_" ) && target.team != players[i].team )
					continue;
			}
	
			if ( isdefined( spawn_origin ) )
			{
				players[i] SetOrigin( spawn_origin );
			}
			else if ( nodes.size > 0 )
			{
				node = array::random( nodes );
				players[i] SetOrigin( node.origin );
			}
			else
			{
				players[i] SetOrigin( origin );
			}
			
		}
	}
	SetDvar( "scr_playerwarp", "" );
}

function updateDevSettingsZm()
{
	if( level.players.size > 0 )
	{
		if( GetDvarString( "r_streamDumpDistance" ) == "3" )
		{
			if(!isdefined(level.streamDumpTeamIndex))
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
			if ((location == "default" || location == "" ) && isdefined(level.default_start_location))
			{
				location = level.default_start_location;
			}		
			match_string = level.scr_zm_ui_gametype + "_" + location;
			if( level.streamDumpTeamIndex < level.teams.size )
			{
				// zombies
				structs = struct::get_array("initial_spawn", "script_noteworthy");
				if(isdefined(structs))
				{
					foreach(struct in structs)			
					{
						if(isdefined(struct.script_string) )
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
				if(!isdefined(spawnPoints) || spawnPoints.size == 0) // old method, failed new method.
				{
					spawnPoints = struct::get_array("initial_spawn_points", "targetname");
				}
				if( isdefined(spawnPoints) )
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
				wait(5);
				SetDvar("r_streamDumpDistance","2");
			}
		}
	}	
}

function updateDevSettings()
{
	show_spawns= GetDvarint( "scr_showspawns");
	show_start_spawns= GetDvarint( "scr_showstartspawns");
	
	player = util::getHostPlayer();

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
	
	if (!isdefined(level.show_spawns) || level.show_spawns!=show_spawns)
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
	
	if (!isdefined(level.show_start_spawns) || level.show_start_spawns!=show_start_spawns)
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

	dev::updateMinimapSetting();
	
	if( level.players.size > 0 )
	{
		updateHardpoints();
		updateTeamOps();
		playerwarp_string = GetDvarString( "scr_playerwarp" );
		if ( playerwarp_string == "host" )
		{
			warpAllToHost();
		}
		else if ( playerwarp_string == "enemies_host" )
		{
			warpAllToHost( playerwarp_string );
		}
		else if ( playerwarp_string == "friendlies_host" )
		{
			warpAllToHost( playerwarp_string );
		}
		else if ( strstartswith( playerwarp_string, "enemies_" ) )
		{
			name = getSubStr( playerwarp_string, 8 );
			warpAllToPlayer( playerwarp_string, name );
		}
		else if ( strstartswith( playerwarp_string, "friendlies_" ) )
		{
			name = getSubStr( playerwarp_string, 11 );
			warpAllToPlayer( playerwarp_string, name );
		}
		else if ( strstartswith( playerwarp_string, "all_" ) )
		{
			name = getSubStr( playerwarp_string, 4 );
			warpAllToPlayer( undefined, name );
		}
		else if ( playerwarp_string == "next_start_spawn" )
		{
			players = GetPlayers();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !isdefined( level.devgui_start_spawn_index ) ) 
			{
				level.devgui_start_spawn_index = 0;
			}

			player = util::getHostPlayer();
			spawns = level.spawn_start[player.pers["team"]];

			if ( !isdefined( spawns ) || spawns.size <= 0 )
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
		else if ( playerwarp_string == "prev_start_spawn" )
		{
			players = GetPlayers();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !isdefined( level.devgui_start_spawn_index ) ) 
			{
				level.devgui_start_spawn_index = 0;
			}

			player = util::getHostPlayer();
			spawns = level.spawn_start[player.pers["team"]];

			if ( !isdefined( spawns ) || spawns.size <= 0 )
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
		else if ( playerwarp_string == "next_spawn" )
		{
			players = GetPlayers();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !isdefined( level.devgui_spawn_index ) ) 
			{
				level.devgui_spawn_index = 0;
			}

			spawns = level.spawnpoints;
			spawns = ArrayCombine( spawns, level.dem_spawns, true, false );

			if ( !isdefined( spawns ) || spawns.size <= 0 )
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
		else if ( playerwarp_string == "prev_spawn" )
		{
			players = GetPlayers();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !isdefined( level.devgui_spawn_index ) ) 
			{
				level.devgui_spawn_index = 0;
			}

			spawns = level.spawnpoints;
			spawns = ArrayCombine( spawns, level.dem_spawns, true, false );

			if ( !isdefined( spawns ) || spawns.size <= 0 )
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
		else if ( GetDvarString( "scr_devgui_spawn" ) != "" )
		{
			player = util::getHostPlayer();

			if ( !isdefined( player.devgui_spawn_active ) )
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
			}

			SetDvar( "scr_devgui_spawn", "" );
		}
		else if ( GetDvarString( "scr_player_ammo" ) != "" )
		{
			players = GetPlayers();

			if ( !isdefined( level.devgui_unlimited_ammo ) )
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
		else if ( GetDvarString( "scr_player_momentum" ) != "" )
		{
			if ( !isdefined( level.devgui_unlimited_momentum ) )
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
		else if ( GetDvarString( "scr_give_player_score" ) != "" )
		{
			level thread devgui_increase_momentum( getDvarInt( "scr_give_player_score" ) );

			SetDvar( "scr_give_player_score", "" );
		}
		else if ( GetDvarString( "scr_player_zero_ammo" ) != "" )
		{
			players = GetPlayers();

			for ( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				weapons = player GetWeaponsList();
				ArrayRemoveValue( weapons, level.weaponBaseMelee );
		
				for ( j = 0; j < weapons.size; j++ )
				{
					if ( weapons[j] == level.weaponNone )
						continue;

					player SetWeaponAmmoStock( weapons[j], 0 );
					player SetWeaponAmmoClip( weapons[j], 0 );
				}
			}

			SetDvar( "scr_player_zero_ammo", "" );
		}
		else if ( GetDvarString( "scr_emp_jammed" ) != "" )
		{
			players = GetPlayers();
			
			for ( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				if ( GetDvarString( "scr_emp_jammed" ) == "0" )
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
		else if ( GetDvarString( "scr_round_pause" ) != "" )
		{
			if ( !level.timerStopped )
			{
				iprintln( "Pausing Round Timer" );
				globallogic_utils::pauseTimer();
			}
			else
			{
				iprintln( "Resuming Round Timer" );
				globallogic_utils::resumeTimer();
			}

			SetDvar( "scr_round_pause", "" );
		}
		else if ( GetDvarString( "scr_round_end" ) != "" )
		{
			level globallogic::forceEnd();
			SetDvar( "scr_round_end", "" );
		}
		else if ( GetDvarString( "scr_health_debug" ) != "0" )
		{
			players = GetPlayers();	
			host = util::getHostPlayer();

			if ( !isdefined( host.devgui_health_debug ) )
			{
				host.devgui_health_debug = false;
			}

			if ( host.devgui_health_debug )
			{
				host.devgui_health_debug = false;

				for ( i = 0; i < players.size; i++ )
				{
					players[i] notify( "devgui_health_debug" );

					if ( isdefined( players[i].debug_health_bar ) )
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
		else if ( GetDvarString( "scr_show_hq_spawns" ) != "" )
		{
			if ( !isdefined( level.devgui_show_hq ) )
			{
				level.devgui_show_hq = false;
			}
			
			if ( level.gameType == "koth" && isdefined( level.radios ) )
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

		if( GetDvarString( "r_streamDumpDistance" ) == "3" )
		{
			if(!isdefined(level.streamDumpTeamIndex))
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
				if( isdefined(level.spawn_start[teamName]) )
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
				wait(5);
				SetDvar("r_streamDumpDistance","2");
			}
		}
	}
	if ( GetDvarString( "scr_giveperk") == "0" )
	{
		players = GetPlayers();

		iprintln( "Taking all perks from all players" );

		for ( i = 0; i < players.size; i++ )
		{
			players[i] ClearPerks();
		}

		SetDvar( "scr_giveperk", "" );
	}
	if ( GetDvarString( "scr_giveperk") != "" )
	{
		perk = GetDvarString( "scr_giveperk");
		specialties = StrTok( perk, "|" );

		players = GetPlayers();

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
	if ( GetDvarString( "scr_forcegrenade" ) != "" )
	{
		force_grenade_throw( GetWeapon( GetDvarString( "scr_forcegrenade" ) ) );
		SetDvar( "scr_forcegrenade", "" );
	}
	if( GetDvarString( "scr_forceevent" ) != "" )
	{
		event = GetDvarString( "scr_forceevent" );
		player = util::getHostPlayer();
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
	if ( GetDvarString( "scr_takeperk") != "" )
	{
		perk = GetDvarString( "scr_takeperk");
		for ( i = 0; i < level.players.size; i++ )
		{
			level.players[i] unsetPerk( perk );
			level.players[i].extraPerks[ perk ] = undefined;
		}
		SetDvar( "scr_takeperk", "" );
	}
	
	if ( GetDvarString( "scr_x_kills_y" ) != "" )
	{
		nameTokens = strTok( GetDvarString( "scr_x_kills_y" ), " " );
		if ( nameTokens.size > 1 )
			thread xKillsY( nameTokens[0], nameTokens[1] );

		SetDvar( "scr_x_kills_y", "" );
	}

	if ( GetDvarString( "scr_usedogs") != "" )
	{
		ownerName = GetDvarString( "scr_usedogs" );
		SetDvar( "scr_usedogs", "" );

		owner = undefined;
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( level.players[index].name == ownerName )
				owner = level.players[index];
		}
		
		if ( isdefined( owner ) )
			owner killstreaks::trigger_killstreak( "dogs" );
	}
	
	if ( GetDvarString( "scr_set_level" ) != "" )
	{
		player.pers["rank"] = 0;
		player.pers["rankxp"] = 0;
		
		newRank = min( GetDvarint( "scr_set_level" ), 54 );
		newRank = max( newRank, 1 );

		SetDvar( "scr_set_level", "" );

		lastXp = 0;
		for ( index = 0; index <= newRank; index++ )		
		{
			newXp = rank::getRankInfoMinXP( index );
			player thread rank::giveRankXP( "kill", newXp - lastXp );
			lastXp = newXp;
			wait ( 0.25 );
			self notify ( "cancel_notify" );
		}
	}

	if ( GetDvarString( "scr_givexp" ) != "" )
	{
		player thread rank::giveRankXP( "challenge", GetDvarint( "scr_givexp" ), true );
		
		SetDvar( "scr_givexp", "" );
	}

	if ( GetDvarString( "scr_do_notify" ) != "" )
	{
		for ( i = 0; i < level.players.size; i++ )
			level.players[i] hud_message::oldNotifyMessage( GetDvarString( "scr_do_notify" ), GetDvarString( "scr_do_notify" ), game["icons"]["allies"] );
		
		announcement( GetDvarString( "scr_do_notify" ), 0 );
		SetDvar( "scr_do_notify", "" );
	}	
	if ( GetDvarString( "scr_entdebug" ) != "" )
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
				
				if ( !isdefined( level.entCounts[classname] ) )
					level.entCounts[classname] = 0;
			
				level.entCounts[classname]++;

				if ( !isdefined( level.entGroups[classname] ) )
					level.entGroups[classname] = [];
			
				level.entGroups[classname][level.entGroups[classname].size] = curEnt;
			}
		}
	}

	if( GetDvarString( "debug_dynamic_ai_spawning" ) == "1" && !isdefined( level.larry ) )
	{
		thread larry_thread();
	}
	else if ( GetDvarString( "debug_dynamic_ai_spawning" ) == "0" )
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
	if ( GetDvarint( "scr_force_finalkillcam" ) == 1 )
	{
		level thread killcam::do_final_killcam();
		level thread waitThenNotifyFinalKillcam();
	}
	if ( GetDvarint( "scr_force_roundkillcam" ) == 1 )
	{
		level thread killcam::do_final_killcam();
		level thread waitThenNotifyRoundKillcam();
	}

	if ( !level.bot_overlay && !level.bot_threat && !level.bot_path )
	{
		level notify( "bot_dpad_terminate" );
	}
}

function waitThenNotifyRoundKillcam()
{
	{wait(.05);};

	level notify ( "play_final_killcam" );
	SetDvar( "scr_force_roundkillcam", 0 );
}

function waitThenNotifyFinalKillcam()
{
	{wait(.05);};
	level notify ( "play_final_killcam" );
	{wait(.05);};
	SetDvar( "scr_force_finalkillcam", 0 );
}

function devgui_spawn_think()
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

		{wait(.05);};
	}
}

function devgui_unlimited_ammo()
{
	self notify( "devgui_unlimited_ammo" );
	self endon( "devgui_unlimited_ammo" );
	self endon( "disconnect" );

	for ( ;; )
	{
		wait( 1 );

		primary_weapons = self GetWeaponsListPrimaries();
		offhand_weapons_and_alts = array::exclude( self GetWeaponsList( true ), primary_weapons );		
		weapons = ArrayCombine(primary_weapons, offhand_weapons_and_alts, false, false);
		ArrayRemoveValue( weapons, level.weaponBaseMelee );
		
		for ( i = 0; i < weapons.size; i++ )
		{
			weapon = weapons[i];
			if ( weapon == level.weaponNone )
				continue;
			
			if ( killstreaks::is_killstreak_weapon( weapon ) )
				continue;
				
			self GiveMaxAmmo( weapon );
		}
	}
}

function devgui_unlimited_momentum()
{
	level notify( "devgui_unlimited_momentum" );
	level endon( "devgui_unlimited_momentum" );

	for ( ;; )
	{
		wait( 1 );

		players = GetPlayers();

		foreach( player in players )
		{
			if ( !isdefined( player ) )
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

			globallogic_score::_setPlayerMomentum( player, 5000 );
		}
	}
}

function devgui_increase_momentum( score )
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( !isdefined( player ) )
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

		player globallogic_score::givePlayerMomentumNotification( score, &"testPlayerScoreForTan", "PLAYER_SCORE" );
	}
}

function devgui_health_debug()
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

	if( !isdefined( self.maxhealth ) || self.maxhealth <= 0 )
		self.maxhealth = 100;
	
	for ( ;; )
	{
		{wait(.05);};

		width = self.health / self.maxhealth * 300;
		width = int( max( width, 1 ) );
		self.debug_health_bar setShader( "black", width, 8 );

		self.debug_health_text SetValue( self.health );
	}
}

function giveExtraPerks()
{
	if ( !isdefined( self.extraPerks ) )
		return;
	
	perks = getArrayKeys( self.extraPerks );
	
	for ( i = 0; i < perks.size; i++ )
	{
		/#	println( "^5Loadout " + self.name + " setPerk( " + perks[i] + " ) -- devperk" );	#/
		self setPerk( perks[i] );
	}
}

function xKillsY( attackerName, victimName )
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
		level.weaponNone, // sWeapon The weapon used to inflict the damage
		(0,0,0), // vPoint The point the damage is from?
		(0,0,0), // vDir The direction of the damage
		"none", // sHitLoc The location of the hit
		(0,0,0), // vDamageOrigin
		0, // psOffsetTime The time offset for the damage
		0,	// boneIndex
		(1,0,0) // vSurfaceNormal
	);
}


function testScriptRuntimeErrorAssert()
{
	wait(1);

	assert( 0 );
}


function testScriptRuntimeAssertMsgAssert()
{
	wait(1);

	assertmsg( "DEVGUI: Assert Message" );
}

function testScriptRuntimeErrorMsgAssert()
{
	wait(1);
/#
	errormsg( "DEVGUI: Error Message" );
#/
}

function testScriptRuntimeError2()
{
	myundefined = "test";
	if( myundefined == 1 )
		println( "undefined in testScriptRuntimeError2\n" );
}

function testScriptRuntimeError1()
{
	testScriptRuntimeError2();
}

function testScriptRuntimeError()
{
	wait 5;
	for(;;)
	{
		if(GetDvarString( "scr_testScriptRuntimeError") != "0" )
			break;
		wait 1;
	}
	
	myerror = GetDvarString( "scr_testScriptRuntimeError" );
	
	SetDvar( "scr_testScriptRuntimeError", "0" );

	if( myerror == "assert" )
		testScriptRuntimeErrorAssert();
	else if( myerror == "assertMsg" )
		testScriptRuntimeAssertMsgAssert();
	else if( myerror == "errorMsg" )
		testScriptRuntimeErrorMsgAssert();
	else
		testScriptRuntimeError1();

	thread testScriptRuntimeError();
}


function testDvars()
{
	wait 5;
	for(;;)
	{
		if(GetDvarString( "scr_testdvar") != "" )
			break;
		wait 1;
	}
	tokens 	  = StrTok( GetDvarString( "scr_testdvar"), " " );
	dvarName = tokens[0];
	dvarValue = tokens[1];

	SetDvar( dvarName, dvarValue );
	SetDvar( "scr_testdvar", "" );

	thread testDvars();
}

function addTestClients()
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

	sound::play_on_players( "vox_kls_dav_spawn" );
	
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

function addEnemyHeli()
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
	player = util::getHostPlayer();
	if( isdefined( player.pers["team"] ) )
	{
		team = util::getOtherTeam( player.pers["team"] );
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
		ent thread helicopter::useKillstreakHelicopter( "helicopter_comlink" );
		wait(0.5);
		ent notify( "confirm_location", level.helilocation ); 
		break;
	case 2:
		break;
	}

	thread addEnemyHeli();
}

function getOrMakeBot(team)
{
	for ( i = 0; i <level.players.size; i++ )
	{
		if ( level.players[i].team == team )
		{
			if ( isdefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"] )
			{
				return level.players[i];
			}
		}
	}
	
	ent = addtestclient();
	if( isdefined( ent ) ) 
	{
		sound::play_on_players( "vox_kls_dav_spawn" );
		ent.pers["isBot"] = true;
		ent thread TestClient( team );
		wait(1);
	}
		
	return ent;
}

function addTestCarePackage()
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
	
	player = util::getHostPlayer();

	if( isdefined( player.pers["team"] ) )
	{
		switch( supplydrop )
		{
		case 2: // enemy
			team = util::getOtherTeam( player.pers["team"] );
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

	ent killstreakrules::killstreakStart( "supply_drop", team );
	ent thread supplydrop::heliDeliverCrate( ent.origin, GetWeapon( "supplydrop" ), ent, team );

	thread addTestCarePackage();
}

function removeTestClients()
{
	wait 5;

	for(;;)
	{
		if(GetDvarint( "scr_testclientsremove") > 0)
			break;
		wait 1;
	}

	sound::play_on_players( "vox_kls_dav_kill" );
	
	removeType = GetDvarint( "scr_testclientsremove");
	
	SetDvar( "scr_testclientsremove", 0 );
	
	host = util::getHostPlayer();
	
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if ( isdefined(players[i].pers["isBot"]) && players[i].pers["isBot"] == true )
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

function TestClient(team) // self == test client
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
		bot_classes = bot::build_classes();
		self notify( "menuresponse", "ChooseClass_InGame", array::random( bot_classes ) );
		self waittill( "spawned_player" );
		wait ( 0.10 );
	}
}

function showOneSpawnPoint(
	spawn_point,
	color,
	notification,
	height,
	print)
{
	if ( !isdefined( height ) || height <= 0 )
	{
		height = util::get_player_height();
	}

	if ( !isdefined( print ) )
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

function showSpawnpoints()
{
	if (isdefined(level.spawnpoints))
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

function hideSpawnpoints()
{
	level notify("hide_spawnpoints");
	
	return;
}

function showStartSpawnpoints()
{
	if ( !level.teamBased )
	{
		return;
	}

	if ( !isdefined( level.spawn_start ) )
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

function hideStartSpawnpoints()
{
	level notify("hide_startspawnpoints");
	
	return;
}

function print3DUntilNotified(origin, text, color, alpha, scale, notification)
{
	level endon(notification);
	
	for(;;)
	{
		print3d(origin, text, color, alpha, scale);
		wait .05;
	}
}

function lineUntilNotified(start, end, color, depthTest, notification)
{
	level endon(notification);
	
	for(;;)
	{
		line(start, end, color, depthTest);
		wait .05;
	}
}

// this controls the engagement distance debug stuff with a dvar
function engagement_distance_debug_toggle()
{
	level endon( "kill_engage_dist_debug_toggle_watcher" );

	if( !isdefined( GetDvarint( "debug_engage_dists") ) )
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

function dvar_turned_on( val )
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

function engagement_distance_debug_init()
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

function engage_dist_debug_hud_destroy( hudArray, killNotify )
{
	level waittill( killNotify );

	for( i = 0; i < hudArray.size; i++ )
	{
		hudArray[i] Destroy();
	}
}

function weapon_engage_dists_init()
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
	engage_dists_add( "colt", genericPistol );
	engage_dists_add( "nambu", genericPistol );
	engage_dists_add( "tokarev", genericPistol );
	engage_dists_add( "walther", genericPistol );

	// SMGs
	engage_dists_add( "thompson", genericSMG );
	engage_dists_add( "type100_smg", genericSMG );
	engage_dists_add( "ppsh", genericSMG );
	engage_dists_add( "mp40", genericSMG );
	engage_dists_add( "stg44", genericSMG );
	engage_dists_add( "sten", genericSMG );
	engage_dists_add( "sten_silenced", genericSMG );

	// shotgun
	engage_dists_add( "shotgun", shotty );

	// LMGs
	engage_dists_add( "bar", genericLMG );
	engage_dists_add( "bar_bipod", genericLMG );
	engage_dists_add( "type99_lmg", genericLMG );
	engage_dists_add( "type99_lmg_bipod", genericLMG );
	engage_dists_add( "dp28", genericLMG );
	engage_dists_add( "dp28_bipod", genericLMG );
	engage_dists_add( "fg42", genericLMG );
	engage_dists_add( "fg42_bipod", genericLMG );
	engage_dists_add( "bren", genericLMG );
	engage_dists_add( "bren_bipod", genericLMG );

	// Rifles (semiautomatic)
	engage_dists_add( "m1garand", genericRifleSA );
	engage_dists_add( "m1carbine", genericRifleSA );
	engage_dists_add( "svt40", genericRifleSA );
	engage_dists_add( "gewehr43", genericRifleSA );

	// Rifles (bolt-action)
	engage_dists_add( "springfield", genericRifleBolt );
	engage_dists_add( "type99_rifle", genericRifleBolt );
	engage_dists_add( "mosin_rifle", genericRifleBolt );
	engage_dists_add( "kar98k", genericRifleBolt );
	engage_dists_add( "lee_enfield", genericRifleBolt );

	// HMGs
	engage_dists_add( "30cal", genericHMG );
	engage_dists_add( "30cal_bipod", genericHMG );
	engage_dists_add( "mg42", genericHMG );
	engage_dists_add( "mg42_bipod", genericHMG );

	// Sniper Rifles
	engage_dists_add( "springfield_scoped", genericSniper );
	engage_dists_add( "type99_rifle_scoped", genericSniper );
	engage_dists_add( "mosin_rifle_scoped", genericSniper );
	engage_dists_add( "kar98k_scoped", genericSniper );
	engage_dists_add( "fg42_scoped", genericSniper );
	engage_dists_add( "lee_enfield_scoped", genericSniper );

	// start waiting for weapon changes
	level thread engage_dists_watcher();
}

function engage_dists_add( weaponName, values )
{
	level.engageDists[GetWeapon( weaponName )] = values;
}

// returns a script_struct, or undefined, if the lookup failed
function get_engage_dists( weapon )
{
	if( isdefined( level.engageDists[weapon] ) )
	{
		return level.engageDists[weapon];
	}
	else
	{
		return undefined;
	}
}

// checks currently equipped weapon to make sure that engagement distance values are correct
function engage_dists_watcher()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_engage_dists_watcher" );

	while( 1 )
	{
		player = util::getHostPlayer();
		playerWeapon = player GetCurrentWeapon();

		if( !isdefined( player.lastweapon ) )
		{
			player.lastweapon = playerWeapon;
		}
		else
		{
			if( player.lastweapon == playerWeapon )
			{
				{wait(.05);};
				continue;
			}
		}

		values = get_engage_dists( playerWeapon );

		if( isdefined( values ) )
		{
			level.weaponEngageDistValues = values;
		}
		else
		{
			level.weaponEngageDistValues = undefined;
		}

		player.lastweapon = playerWeapon;

		{wait(.05);};
	}
}

function debug_realtime_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_realtime_engagement_distance_debug" );

	hudObjArray = engagement_distance_debug_init();
	level thread engage_dist_debug_hud_destroy( hudObjArray, "kill_all_engage_dist_debug" );

	level.debugRTEngageDistColor = level.green;

	player = util::getHostPlayer();

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

			if( !isdefined( level.weaponEngageDistValues ) )
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

		{wait(.05);};
	}
}

function hudobj_changecolor( hudObjArray, newcolor )
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
function engagedist_hud_changetext( engageDistType, units )
{
	if( !isdefined( level.lastDistType ) )
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
function debug_ai_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_ai_engagement_distance_debug" );

	player = util::getHostPlayer();

	while( 1 )
	{
		axis = GetAITeamArray( "axis" );

		if( isdefined( axis ) && axis.size > 0 )
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

					if( !isdefined( level.weaponEngageDistValues ) )
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

		WAIT_SERVER_FRAME;
	}
}
*/

// draws a circle in script
function plot_circle_fortime(radius1,radius2,time,color,origin,normal)
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
		util::plot_points(plotpoints,color[0],color[1],color[2],hangtime);
		plotpoints = [];
		wait hangtime;
	}
}


// -- end engagement distance debug --

function larry_thread()
{

	SetDvar("bot_AllowMovement", "0");
	SetDvar("bot_PressAttackBtn", "0");
	SetDvar("bot_PressMeleeBtn", "0");

	level.larry = SpawnStruct();

	player = util::getHostPlayer();
	player thread larry_init( level.larry ); 

	// Cleanup hudelems, dummy models, etc.
	level waittill ( "kill_larry" );

	larry_hud_destroy( level.larry );

	if ( isdefined( level.larry.model ) )
		level.larry.model delete();

	if ( isdefined( level.larry.ai ) )
	{
		for ( i = 0; i < level.larry.ai.size; i++ )
		{
			kick( level.larry.ai[i] GetEntityNumber() );
		}
	}

	level.larry = undefined;
}

function larry_init( larry )
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
		{wait(.05);};

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
				{wait(.05);};
		}
	}
}

function larry_ai( larry )
{
	larry.ai[larry.ai.size] = AddTestClient();
	
	i = larry.ai.size - 1;
	larry.ai[i].pers["isBot"] = true;
	larry.ai[i] thread TestClient( "autoassign" );

	larry.ai[i] thread larry_ai_thread( larry, larry.model.origin, larry.model.angles );
	larry.ai[i] thread larry_ai_damage( larry );
	larry.ai[i] thread larry_ai_health( larry );
}

function larry_ai_thread( larry, origin, angles )
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

function larry_ai_damage( larry )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point );		

		if ( !IsDefined( attacker ) )
		{
			continue;
		}

		player = util::getHostPlayer();
		if ( !isdefined( player ) )
		{
			continue;
		}

		if ( attacker != player )
		{
			continue;
		}

		eye = player GetEye();
		range = int( Distance( eye, point ) );
		
		larry.menu[larry.menu_health]	SetValue( self.health );
		larry.menu[larry.menu_damage]	SetValue( damage );	
		larry.menu[larry.menu_range]	SetValue( range );	

		if ( IsDefined( self.cac_debug_location ) )
		{
			larry.menu[larry.menu_hitloc]	SetText( self.cac_debug_location );	
		}
		else
		{
			larry.menu[larry.menu_hitloc]	SetText( "<unknown>" );	
		}

		if ( IsDefined( self.cac_debug_weapon ) )
		{
			larry.menu[larry.menu_weapon]	SetText( self.cac_debug_weapon );	
		}
		else
		{
			larry.menu[larry.menu_weapon]	SetText( "<unknown>" );	
		}
	}
}

function larry_ai_health( larry )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		{wait(.05);};

		larry.menu[larry.menu_health] SetValue( self.health );
	}
}

function larry_hud_init( larry )
{
	/#
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
	#/
}

function larry_hud_destroy( larry )
{
	if ( isdefined( larry.hud ) )
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

function new_hud( hud_name, msg, x, y, scale )
{
	if( !isdefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !isdefined( level.hud_array[hud_name] ) )
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
function set_hudelem( text, x, y, scale, alpha, sort, debug_hudelem )
{
	/#
		if( !isdefined( alpha ) )
		{
			alpha = 1;
		}

		if( !isdefined( scale ) )
		{
			scale = 1;
		}

		if( !isdefined( sort ) )
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

		if( isdefined( text ) )
		{
			hud SetText( text );
		}

		return hud;
	#/
}

function watch_botsdvars()
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
function getAttachmentChangeModifierButton()
{
	return "BUTTON_X";
}

function watchAttachmentChange()
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
		
		{wait(.05);};
	}
}

function print_weapon_name() // self == player
{
	self notify( "print_weapon_name");
	self endon( "print_weapon_name");
	
	wait(0.2);
	
	if ( self IsSwitchingWeapons() )
	{
		self waittill( "weapon_change_complete", weapon );
		fail_safe = 0;
		while ( weapon == level.weaponNone )
		{
			self waittill( "weapon_change_complete", weapon );
			{wait(.05);};
			fail_safe++;
			if( fail_safe > 120 )
			{
				break;
			}
		}
	}
	else
	{
		weapon = self getcurrentweapon();
	}
	printWeaponName = GetDvarInt( "scr_print_weapon_name", 1 );
	if ( printWeaponName ) 
		IPrintLnBold( weapon.name );
}

function set_equipment_list()
{
	if (isdefined( level.dev_equipment ))
		return;
	
	level.dev_equipment = [];

	//array starts at '1' because I need the first element to empty as GetDvarInt() returns zero if it's undefined.
	level.dev_equipment[1] = GetWeapon( "acoustic_sensor" );
	level.dev_equipment[2] = GetWeapon( "camera_spike" );
	level.dev_equipment[3] = GetWeapon( "claymore" );
	level.dev_equipment[4] = GetWeapon( "satchel_charge" );
	level.dev_equipment[5] = GetWeapon( "scrambler" );
	level.dev_equipment[6] = GetWeapon( "tactical_insertion" );
	level.dev_equipment[7] = GetWeapon( "bouncingbetty" );
	level.dev_equipment[8] = GetWeapon( "trophy_system" );
	level.dev_equipment[9] = GetWeapon( "pda_hack" );
	level.dev_equipment[10] = GetWeapon( "threat_detector" );
}

function set_grenade_list()
{
	if (isdefined( level.dev_grenade ))
		return;
	
	level.dev_grenade = [];

	//array starts at '1' because I need the first element to empty as GetDvarInt() returns zero if it's undefined.
	level.dev_grenade[1] = GetWeapon( "frag_grenade" );
	level.dev_grenade[2] = GetWeapon( "sticky_grenade" );
	level.dev_grenade[3] = GetWeapon( "hatchet" );
	level.dev_grenade[4] = GetWeapon( "willy_pete" );
	level.dev_grenade[5] = GetWeapon( "proximity_grenade" );
	level.dev_grenade[6] = GetWeapon( "flash_grenade" );
	level.dev_grenade[7] = GetWeapon( "concussion_grenade" );
	level.dev_grenade[8] = GetWeapon( "nightingale" );
	level.dev_grenade[9] = GetWeapon( "emp_grenade" );
	level.dev_grenade[10] = GetWeapon( "sensor_grenade" );
	level.dev_grenade[11] = GetWeapon( "incendiary_grenade" );
}

function take_all_grenades_and_equipment( player )
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
	
function equipment_dev_gui()
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

function grenade_dev_gui()
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

function force_grenade_throw( weapon )
{
	if ( weapon == level.weaponNone )
	{
		return;
	}

	SetDvar( "bot_AllowMovement", "0" ); 
	SetDvar( "bot_PressAttackBtn", "0" ); 
	SetDvar( "bot_PressMeleeBtn", "0" ); 
	SetDvar( "scr_botsAllowKillstreaks", "0" ); 

	host = util::getHostPlayer();

	if( !isdefined( host.team ) )
	{
		iprintln( "Unable to determine host player team" );
		return;
	}

	bot = getOrMakeBot( util::getOtherTeam( host.team ) );

	if( !isdefined( bot ) ) 
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
	
	grenade = bot MagicGrenadePlayer( Weapon, origin, velocity );
	grenade SetTeam( bot.team );
	grenade SetOwner( bot );
}

function bot_dpad_think()
{
	level notify( "bot_dpad_stop" );
	level endon( "bot_dpad_stop" );
	level endon( "bot_dpad_terminate" );

	if ( !isdefined( level.bot_index ) )
	{
		level.bot_index = 0;
	}
		
	host = util::getHostPlayer();

	while ( !isdefined( host ) )
	{
		wait( 0.5 );
		host = util::getHostPlayer();
		level.bot_index = 0;
	}

	dpad_left = false;
	dpad_right = false;

	for ( ;; )
	{
		{wait(.05);};
		host SetActionSlot( 3, "" );
		host SetActionSlot( 4, "" );

		players = GetPlayers();
		max = players.size;

		if ( !dpad_left && host ButtonPressed( "DPAD_LEFT" ) )
		{
			level.bot_index--;

			if ( level.bot_index < 0 )
			{
				level.bot_index = max - 1;
			}

			if ( !players[ level.bot_index ] util::is_bot() )
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

			if ( !players[ level.bot_index ] util::is_bot() )
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

function bot_overlay_think()
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

function bot_threat_think()
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

function bot_path_think()
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

function bot_overlay_stop()
{
	level notify( "bot_overlay_stop" );
	SetDvar( "bot_Debug", "-1" );
}

function bot_path_stop()
{
	level notify( "bot_path_stop" );
	SetDvar( "bot_DebugPaths", "-1" );
}

function bot_threat_stop()
{
	level notify( "bot_threat_stop" );
	SetDvar( "bot_DebugThreat", "-1" );
}

function devStrafeRunPathDebugDraw()
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
		if( killstreaks::should_draw_debug("planemortar") > 0 )
		{
			nodes = [];
			end = false;
			node = GetVehicleNode( "warthog_start", "targetname" );

			if ( !isdefined( node ) )
			{
				println( "No strafe run path found" );
				SetDvar( "scr_devStrafeRunPathDebugDraw", "0" );
				continue;
			}

			while( isdefined( node.target ) )
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

				if( isdefined( node.script_noteworthy ) )
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

			{wait(.05);};
		}
		else
		{
			wait( 1 );
		}
	}
}

function devHeliPathDebugDraw()
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
				if( isdefined( ent.targetname ) )
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

		{wait(.05);};
	}
}

function drawOriginLines()
{
	red =	( 1, 0, 0 );
	green = ( 0, 1, 0 );
	blue =	( 0, 0, 1 );

	Line( self.origin, self.origin + ( AnglesToForward( self.angles ) * 10 ), red );
	Line( self.origin, self.origin + ( AnglesToRight( self.angles ) * 10 ), green );
	Line( self.origin, self.origin + ( AnglesToUp( self.angles ) * 10 ), blue );
}

function drawTargetNameText( textColor, textAlpha, textScale, textOffset )
{
	if( !isdefined( textOffset ) )
		textOffset = ( 0, 0, 0 );
	Print3d( self.origin + textOffset, self.targetname, textColor, textAlpha, textScale );
}

function drawNoteWorthyText( textColor, textAlpha, textScale, textOffset )
{
	if( !isdefined( textOffset ) )
		textOffset = ( 0, 0, 0 );
	Print3d( self.origin + textOffset, self.script_noteworthy, textColor, textAlpha, textScale );
}

function drawOriginText( textColor, textAlpha, textScale, textOffset )
{
	if( !isdefined( textOffset ) )
		textOffset = ( 0, 0, 0 );
	originString = "(" + self.origin[0] + ", " + self.origin[1] + ", " + self.origin[2] + ")";
	Print3d( self.origin + textOffset, originString, textColor, textAlpha, textScale );
}

function drawSpeedAccelText( textColor, textAlpha, textScale, textOffset )
{
	if( isdefined( self.script_airspeed ) )
		Print3d( self.origin + ( 0, 0, textOffset[2] * 2 ), "script_airspeed:" + self.script_airspeed, textColor, textAlpha, textScale );
	if( isdefined( self.script_accel ) )
		Print3d( self.origin + ( 0, 0, textOffset[2] * 3 ), "script_accel:" + self.script_accel, textColor, textAlpha, textScale );
}

function drawPath( lineColor, textColor, textAlpha, textScale, textOffset, drawTime, endonMsg ) // self == starting node
{
	level endon( endonMsg );

	// draw lines from origin to origin until there is no target
	ent = self;
	entFirstTarget = ent.targetname;

	while( isdefined( ent.target ) )
	{
		entTarget = GetEnt( ent.target, "targetname" );
		ent thread drawPathSegment( entTarget, lineColor, textColor, textAlpha, textScale, textOffset, drawTime, endonMsg );

		// store the first target because we have the loop nodes that will always have a target
		if( ent.targetname == "heli_loop_start" )
			entFirstTarget = ent.target;
		else if( ent.target == entFirstTarget )
			break;

		ent = entTarget;
		{wait(.05);};
	}
}

function drawPathSegment( entTarget, lineColor, textColor, textAlpha, textScale, textOffset, drawTime, endonMsg )
{
	level endon( endonMsg );

	// draw the line for a certain amount of time
	while( drawTime > 0 )
	{
		if ( isdefined( self.targetname ) && self.targetname == "warthog_start" )
		{
			Print3d( self.origin + textOffset, self.targetname, textColor, textAlpha, textScale );
		}
				
		Line( self.origin, entTarget.origin, lineColor );


		self drawSpeedAccelText( textColor, textAlpha, textScale, textOffset );
		drawTime -= 0.05;
		{wait(.05);};
	}
}

function get_lookat_origin( player )
{
	angles = player GetPlayerAngles();
	forward = AnglesToForward( angles );
	dir = VectorScale( forward, 8000 );

	eye = player GetEye();
	trace = BulletTrace( eye, eye + dir, 0, undefined );

	return trace[ "position" ];
}

function draw_pathnode( node, color )
{
	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 1 );
	}

	Box( node.origin, ( -16, -16, 0 ), ( 16, 16, 16 ), 0, color, 1, false, 1 );
}

function draw_pathnode_think( node, color )
{
	level endon( "draw_pathnode_stop" );

	for ( ;; )
	{
		draw_pathnode( node, color );
		{wait(.05);};
	}
}

function draw_pathnodes_stop()
{
	wait( 5 );
	level notify( "draw_pathnode_stop" );
}

function node_get( player )
{
	for ( ;; )
	{
		{wait(.05);};

		origin = get_lookat_origin( player );
		node = GetNearestNode( origin );

		if ( !isdefined( node ) )
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

function dev_get_node_pair()
{
	player = util::getHostPlayer();

	start = undefined;

	while ( !isdefined( start ) )
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
		{wait(.05);};
	}

	end = undefined;

	while ( !isdefined( end ) )
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

function draw_point( origin, color )
{
	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 1 );
	}

	Sphere( origin, 16, color, 0.25, false, 16, 1 );
}

function point_get( player )
{
	for ( ;; )
	{
		{wait(.05);};

		origin = get_lookat_origin( player );

		if ( player ButtonPressed( "BUTTON_A" ) )
		{
			return origin;
		}
		else if ( player ButtonPressed( "BUTTON_B" ) )
		{
			return undefined;
		}

		draw_point( origin, ( 1, 0, 1 ) );
	}
}

function dev_get_point_pair()
{
	player = util::getHostPlayer();

	start = undefined;
	points = [];

	while ( !isdefined( start ) )
	{
		start = point_get( player );

		if ( !IsDefined( start ) )
		{
			return points;
		}
	}

	while ( player ButtonPressed( "BUTTON_A" ) )
	{
		{wait(.05);};
	}

	end = undefined;

	while ( !isdefined( end ) )
	{
		end = point_get( player );

		if ( !IsDefined( end ) )
		{
			return points;
		}
	}

	points[0] = start;
	points[1] = end;

	return points;
}

#/
