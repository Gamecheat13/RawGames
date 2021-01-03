#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\bots\_bot;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_utils;

#using scripts\zm\_util;

#precache( "eventstring", "testPlayerScoreForTan" );

#namespace dev;

/#
function autoexec __init__sytem__() {     system::register("dev",&__init__,undefined,"spawnlogic");    }

function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	if (GetDvarString( "scr_showspawns") == "")
	{
		SetDvar("scr_showspawns", "0");
	}
	if (GetDvarString( "scr_showstartspawns") == "")
	{
		SetDvar("scr_showstartspawns", "0");
	}
	if (GetDvarString( "scr_devHeliPathsDebugDraw") == "")
	{
		SetDvar("scr_devHeliPathsDebugDraw", "0");
	}
	if (GetDvarString( "scr_devStrafeRunPathDebugDraw") == "")
	{
		SetDvar("scr_devStrafeRunPathDebugDraw", "0");
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
	thread devHeliPathDebugDraw();
	thread devStrafeRunPathDebugDraw();
	thread globallogic_score::setPlayerMomentumDebug();

	
	SetDvar( "scr_giveperk", "" );
	SetDvar( "scr_forceevent", "" );
	SetDvar( "scr_draw_triggers", "0" );

	// SRS 3/19/08: engagement distance debug dvar toggle watcher
//	thread engagement_distance_debug_toggle();
	
	// give equipment through devgui
	thread equipment_dev_gui();
	
	// give grenades through devgui
	thread grenade_dev_gui();

	SetDvar( "debug_dynamic_ai_spawning", "0" );

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
		
	callback::on_connect( &on_player_connect );	

	for(;;)
	{
		updateDevSettings();
		wait .5;
	}
}

function on_player_connect()
{
	//player thread watchAttachmentChange();
}
#/

/#
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
				wait(.05);
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
		if ( GetDvarString( "scr_playerwarp" ) == "host" )
		{
			warpAllToHost();
		}
		else if ( GetDvarString( "scr_playerwarp" ) == "enemies_host" )
		{
			warpAllToHost(GetDvarString( "scr_playerwarp" ));
		}
		else if ( GetDvarString( "scr_playerwarp" ) == "friendlies_host" )
		{
			warpAllToHost(GetDvarString( "scr_playerwarp" ));
		}
		else if ( strstartswith( GetDvarString( "scr_playerwarp" ), "enemies_" ) )
		{
			name = getSubStr( GetDvarString( "scr_playerwarp" ), 8 );
			warpAllToPlayer( GetDvarString( "scr_playerwarp" ), name );
		}
		else if ( strstartswith( GetDvarString( "scr_playerwarp" ), "friendlies_" ) )
		{
			name = getSubStr( GetDvarString( "scr_playerwarp" ), 11 );
			warpAllToPlayer( GetDvarString( "scr_playerwarp" ), name );
		}
		else if ( strstartswith( GetDvarString( "scr_playerwarp" ), "all_" ) )
		{
			name = getSubStr( GetDvarString( "scr_playerwarp" ), 4 );
			warpAllToPlayer( undefined, name );
		}
		else if ( GetDvarString( "scr_playerwarp" ) == "next_start_spawn" )
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
		else if ( GetDvarString( "scr_playerwarp" ) == "prev_start_spawn" )
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
		else if ( GetDvarString( "scr_playerwarp" ) == "next_spawn" )
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
		else if ( GetDvarString( "scr_playerwarp" ) == "prev_spawn" )
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
				wait(.05);
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

	if ( GetDvarString( "scr_set_level" ) != "" )
	{
/*
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
*/
	}

	if ( GetDvarString( "scr_givexp" ) != "" )
	{
/*
		player thread rank::giveRankXP( "challenge", GetDvarint( "scr_givexp" ), true );
		
		SetDvar( "scr_givexp", "" );
*/
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

		player globallogic_score::givePlayerMomentumNotification( score, &"testPlayerScoreForTan", "PLAYER_SCORE", false );
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
		level.weaponNone, // weapon The weapon used to inflict the damage
		(0,0,0), // vPoint The point the damage is from?
		(0,0,0), // vDir The direction of the damage
		"none", // sHitLoc The location of the hit
		0, // psOffsetTime The time offset for the damage
		0	// boneIndex
	);
}


function testScriptRuntimeErrorAssert()
{
	wait(1);

	assert( 0 );
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
		if( GetDvarInt( "scr_devStrafeRunPathDebugDraw" ) > 0 )
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