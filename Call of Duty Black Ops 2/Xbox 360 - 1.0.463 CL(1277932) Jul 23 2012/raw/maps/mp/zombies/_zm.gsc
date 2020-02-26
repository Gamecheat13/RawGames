#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 



init()
{
	level.player_too_many_weapons_monitor = true;
	level.player_too_many_weapons_monitor_func = ::player_too_many_weapons_monitor;

	level._use_choke_weapon_hints = 1;
	level._use_choke_blockers = 1;

	level.spawn_funcs = [];
	level.spawn_funcs["allies"] = [];
	level.spawn_funcs["axis"] = [];
	level.spawn_funcs["team3"] = [];


	// put things you'd like to be able to turn off in here above this line
	level thread maps\mp\zombies\_zm_ffotd::main_start();

	level.zombiemode = true;
	level.reviveFeature = false;
	level.swimmingFeature = false;
	level.calc_closest_player_using_paths = true;
	level.zombie_melee_in_water = true;
	level.put_timed_out_zombies_back_in_queue = true;
	level.use_alternate_poi_positioning = true;

	level.scr_zm_game_module = getZMGameModule(GetDvar( "ui_gametype" ));
	level.scr_zm_ui_gametype = GetDvar( "ui_gametype" );
	level.scr_zm_map_start_location = GetDvar( "ui_zm_mapstartlocation" );
	
	// init game modes
	if ( GetDvar( "ui_gametype" ) != "zclassic" && GetDvar( "ui_gametype" ) != "zsurvival" )
	{
		level thread maps\mp\zombies\_zm_game_module::init();
	}

	
	// set up any gameplay modes
	level.GAME_MODULE_CLASSIC_INDEX = 0;
	maps\mp\zombies\_zm_game_module::register_game_module(level.GAME_MODULE_CLASSIC_INDEX,"classic",undefined,undefined);	
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.scr_zm_game_module);
	
	//for tracking stats
	level.zombies_timeout_spawn = 0;
	level.zombies_timeout_playspace = 0;
	level.zombies_timeout_undamaged = 0;	
	level.zombie_player_killed_count = 0;
	level.zombie_trap_killed_count = 0;
	level.zombie_pathing_failed = 0;
	level.zombie_breadcrumb_failed = 0;

	level.zombie_visionset = "zombie_neutral";

	if(GetDvar("anim_intro") == "1")
	{
		level.zombie_anim_intro = 1;
	}
	else
	{
		level.zombie_anim_intro = 0;
	}

	precache_shaders();
	precache_models();
	
	PrecacheRumble( "explosion_generic" );
	precacherumble( "dtp_rumble" );
	precacherumble( "slide_rumble" );

	precache_zombie_leaderboards();

	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;

	//Limit zombie to 24 max, must have for network purposes
	if ( !isdefined( level.zombie_ai_limit ) )
	{
		level.zombie_ai_limit = 48;
	}	
	
	
	init_dvars();
	init_mutators();
	init_strings();
	init_levelvars();
	init_sounds();
	init_shellshocks();
	init_flags();
	init_client_flags();

	RegisterClientField("world", "zombie_power_on", 1, "int");
	
	register_offhand_weapons_for_level_defaults();

	level thread drive_client_connected_notifies();
	
	// load map defaults  

	// Initialize the zone manager above any scripts that make use of zone info
	maps\mp\zombies\_zm_zonemgr::init();

	//init any pre-game module stuff 
	run_game_module_pre_init();	


	//Systems
	maps\mp\zombies\_zm_unitrigger::init();
	maps\mp\zombies\_zm_audio::init();
	maps\mp\zombies\_zm_blockers::init();
	maps\mp\zombies\_zm_bot::init();
	maps\mp\zombies\_zm_buildables::init();
	maps\mp\zombies\_zm_equipment::init();
	maps\mp\zombies\_zm_laststand::init(); 	
	maps\mp\zombies\_zm_magicbox::init();
	maps\mp\zombies\_zm_perks::init();
	maps\mp\zombies\_zm_playerhealth::init();
	maps\mp\zombies\_zm_powerups::init();	
	maps\mp\zombies\_zm_spawner::init();
	maps\mp\zombies\_zm_timer::init();
	maps\mp\zombies\_zm_traps::init();
	//maps\mp\zombies\_zm_turned::init();
	maps\mp\zombies\_zm_weapons::init();
	maps\mp\zombies\_zm_ai_dogs::init();
	
/#
	maps\mp\zombies\_zm_devgui::init();
#/
	
	init_function_overrides();
	
	// ww: init the pistols in the game so last stand has the importance order
	level thread last_stand_pistol_rank_init();

	level thread maps\mp\zombies\_zm_tombstone::init();
	
	level thread post_all_players_connected();
	
	init_utility();

	maps\mp\_utility::registerClientSys( "lsm" );

	if( isDefined( level.custom_ai_type ) )
	{
		for( i = 0; i < level.custom_ai_type.size; i++ )
		{
			[[ level.custom_ai_type[i] ]]();
		}
	}
	
	if( level.mutators[ "mutator_friendlyFire" ] )
	{
		SetDvar( "friendlyfire_enabled", "1" );
	}
	
	// initial zombies stats 
	maps\mp\zombies\_zm_stats::init();

	// STATS_TODO: will check if the following is needed later
	initializeStatTracking();	
	
	if ( GET_PLAYERS().size <= 1 )
	{
		incrementCounter( "global_solo_games", 1 );
	}
	else if( level.systemLink )
	{
		incrementCounter( "global_systemlink_games", 1 );
	}
	else if ( GetDvarInt( "splitscreen_playerCount" ) == GET_PLAYERS().size )
	{
		incrementCounter( "global_splitscreen_games", 1 );
	}
	else // coop game
	{
		incrementCounter( "global_coop_games", 1 );
	}
	
	// Test case of : Register pers_upgrade	
	maps\mp\zombies\_zm_pers_upgrades::register_pers_upgrade( "board", undefined, "boards", 6 );
	
	level thread maps\mp\zombies\_zm_pers_upgrades::pers_upgrades_monitor();

	level thread maps\mp\zombies\_zm_ffotd::main_end();
	level thread track_players_intersection_tracker();
	level thread onAllPlayersReady();
	level thread startUnitriggers();
	//post game module initialization
	run_game_module_post_init();
	
}

startUnitriggers()
{
	flag_wait_any( "start_zombie_round_logic", "start_encounters_match_logic" );
	level thread maps\mp\zombies\_zm_unitrigger::main();
}

drive_client_connected_notifies()
{
	while(1)
	{
		level waittill("connected", player);
		player Callback("on_player_connect");
	}
}

run_game_module_pre_init()
{
	level thread maps\mp\zombies\_zm_game_module::module_Onconnecting();
	
	if(!isDefined(level._game_modules))
	{
		return;
	}
	
	if ( is_Encounter() )
	{
		PreCacheShellShock( "tabun_gas_mp" );
	}
	
	for(i=0;i<level._game_modules.size;i++)
	{
		if(!isDefined(level._game_modules[i]))
		{
			continue;
		}
		
		if(isDefined(level._game_modules[i].pre_init_func))
		{
			level thread [[level._game_modules[i].pre_init_func]]();
		}
	}
}


run_game_module_post_init()
{
	if(!isDefined(level._game_modules))
	{
		return;
	}
	
	for(i=0;i<level._game_modules.size;i++)
	{
		if(!isDefined(level._game_modules[i]))
		{
			continue;
		}
		
		if(isDefined(level._game_modules[i].post_init_func))
		{
			level thread [[level._game_modules[i].post_init_func]]();
		}
	}
}




onAllPlayersReady()
{
	//wait ( 5.0 );
	
	timeOut = GetTime() + 5000;	// 5 second time out.
	
	while(GetNumExpectedPlayers() == 0  && (GetTime() < timeOut))
	{
		wait(0.1);
	}
	
/#	println( "ZM >> player_count_expected=" + GetNumExpectedPlayers());		#/

	player_count_actual = 0;
	while( (GetNumConnectedPlayers() < GetNumExpectedPlayers()) || (player_count_actual != GetNumExpectedPlayers()) )
	{
		players = GET_PLAYERS();
		player_count_actual = 0;
		for( i = 0; i < players.size; i++ )
		{
			players[i] FreezeControls( true );
			if( players[i].sessionstate == "playing" )
			{
				player_count_actual++;
			} 
		}
	
	/#	println( "ZM >> Num Connected =" + GetNumConnectedPlayers() + " Expected : " + GetNumExpectedPlayers());	#/
		wait( 0.1 );	
	}

/#	println( "ZM >> We have all players - START ZOMBIE LOGIC" );	#/
	
	
	//Check to see if we should spawn some bots to help
	if ( (1 == GetNumConnectedPlayers()) && (GetDvarInt( "scr_zm_enable_bots" )==1) )
	{
		level thread add_bots();
	}
	else
	{
		//Unfreeze all players
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
			players[i] FreezeControls( false );

		flag_set( "start_zombie_round_logic" );
	}
}


getAllOtherPlayers()
{
	aliveplayers = [];

	// Make a list of fully connected, non-spectating, alive players
	for(i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		player = level.players[i];
		
		if ( player.sessionstate != "playing" || player == self )
			continue;

		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}

getFreeSpawnpoint(spawnpoints, player)
{
	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
	{
		iprintlnbold( "ZM >> No free spawn points in map" );
		return undefined;
	}

	// only should happen on initial spawn.
	if(!Isdefined(level.side_selection))
	{
		spawnpoints = array_randomize(spawnpoints);
		level._team1_num = 0;
		level._team2_num = 0;		
		
		random_chance = randomint(100);
		if(random_chance > 50)
		{
			level.side_selection = 1;
		}
		else
		{
			level.side_selection = 2;
		}
	}	
	// used in vs. games where you switch sides on next round.
	if(flag("switchedsides") && !is_true(level.switched))
	{
		level.switched = true;
		
		if(level.side_selection == 2)
		{
			level.side_selection = 1;
		}
		else if(level.side_selection == 1)
		{
			level.side_selection = 2;
		}
	}
	
	if(IsDefined(player) && IsDefined(player.team))
	{
		i = 0; 
		while(IsDefined(spawnpoints) && i < spawnpoints.size)
		{
			If(!IsDefined(level.side_selection) || level.side_selection == 1)			
			{
				if(player.team != "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else if(player.team == "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else 
				{
					i++;
				}
			}	
			else
			{
				if(player.team == "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else if(player.team != "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else 
				{
					i++;
				}
			}		
		}	
	}	

	if(!Isdefined(self.playernum))
	{
		if(self.team == "allies")
		{
			self.playernum = level._team1_num;
			level._team1_num++;
		}	
		else
		{
			self.playernum = level._team2_num;
			level._team2_num++;
		}	
	}	

	for( j = 0; j < spawnpoints.size; j++ )
	{
		if(!IsDefined(spawnpoints[j].en_num))
		{
			for( m = 0; m < spawnpoints.size; m++ )
			{
				spawnpoints[m].en_num = m;
			}	
		}	

		if(	spawnpoints[j].en_num == self.playernum)
		{
			return spawnpoints[j];
		}	
	}

	return spawnpoints[0];
}


delete_in_createfx()
{
	exterior_goals = getstructarray( "exterior_goal", "targetname" );
	for( i = 0; i < exterior_goals.size; i++ )
	{
		if( !IsDefined( exterior_goals[i].target ) ) // If the exterior_goal entity has no targets defined then return
		{
			continue;
		}
		targets = GetEntArray( exterior_goals[i].target, "targetname" ); // Grab all the pieces that are targeted by the exterior_goal

		for( j = 0; j < targets.size; j++ ) // count total targets of exterior_goal
		{
			targets[j] self_delete();
		}
	}
}

add_bots()
{
	//Wait for the host!
	host = GetHostPlayer();
	while ( !IsDefined( host ) )
	{
		wait( 0.05 );
		host = GetHostPlayer();
	}
	
	wait( 4.0 );
	
	//Then spawn bots
	zbot_spawn();
	SetDvar("bot_AllowMovement", "1");
	SetDvar("bot_PressAttackBtn", "1");
	SetDvar("bot_PressMeleeBtn", "1");
	
	//Wait until bots are spawned
	while( GET_PLAYERS().size<2 )
	{
		wait( 0.05 );
	}
	
	//Unfreeze all players
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
		players[i] FreezeControls( false );

	level.numberBotsAdded = 1;
	flag_set( "start_zombie_round_logic" );
}

zbot_spawn()
{
	player = GetHostPlayer();
	
	spawnPoints = getstructarray( "initial_spawn_points", "targetname" ); 
	spawnPoint =  getFreeSpawnpoint( spawnPoints );
		
	bot = AddTestClient();
	if ( !IsDefined( bot ) )
	{
	/#	println( "Could not add test client" );	#/
		return;
	}
			
	bot.pers["isBot"] = true;
	bot.equipment_enabled = false;
	//bot thread bot_spawn_think( team );

	yaw = spawnPoint.angles[1];
	bot thread zbot_spawn_think( spawnPoint.origin, yaw );
	return bot;
}

zbot_spawn_think( origin, yaw )
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

post_all_players_connected()
{
	flag_wait( "start_zombie_round_logic" ); 
/#
	execdevgui( "devgui_zombie" );

	println( "sessions: mapname=", level.script, " gametype zom isserver 1 player_count=", GET_PLAYERS().size );
#/
	maps\mp\zombies\_zm_score::init();

	level thread clear_mature_blood();

	// Start the Zombie MODE!
	level thread round_end_monitor();
	level thread end_game();
	
	if(!level.zombie_anim_intro)
	{
		if(isDefined(level._round_start_func))
		{
			level thread [[level._round_start_func]]();
		}
	}

	level thread players_playing();
	//chrisp - adding spawning vo 
	//level thread spawn_vo();
	
	//add ammo tracker for VO
	level thread track_players_ammo_count();
	
	//level thread prevent_near_origin();

	DisableGrenadeSuicide();
	level.startInvulnerableTime = GetDvarInt( "player_deathInvulnerableTime" );

	if(!IsDefined(level.music_override) )
	{
		level.music_override = false;
	}
}

zombiemode_melee_miss()
{
	if( isDefined( self.enemy.curr_pay_turret ) )
	{
		self.enemy doDamage( GetDvarInt( "ai_meleeDamage" ), self.origin, self, self, "none", "melee" );
	}
}

init_additionalprimaryweapon_machine_locations()
{
	switch ( Tolower( GetDvar( "mapname" ) ) )
	{
	case "zombie_theater":
		level.zombie_additionalprimaryweapon_machine_origin = (1172.4, -359.7, 320);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 90, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (1160, -360, 448);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 0, 0);
		break;
	case "zombie_pentagon":
		level.zombie_additionalprimaryweapon_machine_origin = (-1081.4, 1496.9, -512);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 162.2, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (-1084, 1489, -448);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 341.4, 0);
		break;
	case "zombie_cosmodrome":
		level.zombie_additionalprimaryweapon_machine_origin = (420.8, 1359.1, 55);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 270, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (436, 1359, 177);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 0, 0);

		level.zombie_additionalprimaryweapon_machine_monkey_angles = (0, 0, 0);
		level.zombie_additionalprimaryweapon_machine_monkey_origins = [];
		level.zombie_additionalprimaryweapon_machine_monkey_origins[0] = (398.8, 1398.6, 60);
		level.zombie_additionalprimaryweapon_machine_monkey_origins[1] = (380.8, 1358.6, 60);
		level.zombie_additionalprimaryweapon_machine_monkey_origins[2] = (398.8, 1318.6, 60);
		break;
	case "zombie_coast":
		level.zombie_additionalprimaryweapon_machine_origin = (2424.4, -2884.3, 314);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 231.6, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (2435, -2893, 439);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 322.2, 0);
		break;
	case "zombie_temple":
		level.zombie_additionalprimaryweapon_machine_origin = (-1352.9, -1437.2, -485);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 297.8, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (-1342, -1431, -361);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 28.8, 0);
		break;
	case "zombie_moon":
		level.zombie_additionalprimaryweapon_machine_origin = (1480.8, 3450, -65);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 180, 0);
		break;
	case "zombie_cod5_prototype":
		level.zombie_additionalprimaryweapon_machine_origin = (-160, -528, 1);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 0, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (-162, -517, 17);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 0, 0);
		break;
	case "zombie_cod5_asylum":
		level.zombie_additionalprimaryweapon_machine_origin = (-91, 540, 64);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 90, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (-103, 540, 92);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 0, 0);
		break;
	case "zombie_cod5_sumpf":
		level.zombie_additionalprimaryweapon_machine_origin = (9565, 327, -529);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 90, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (9555, 327, -402);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 0, 0);
		break;
	case "zombie_cod5_factory":
		level.zombie_additionalprimaryweapon_machine_origin = (-1089, -1366, 67);
		level.zombie_additionalprimaryweapon_machine_angles = (0, 90, 0);
		level.zombie_additionalprimaryweapon_machine_clip_origin = (-1100, -1365, 70);
		level.zombie_additionalprimaryweapon_machine_clip_angles = (0, 0, 0);
		break;
	}
}

/*------------------------------------
chrisp - adding vo to track players ammo
------------------------------------*/
track_players_ammo_count()
{
	self endon("disconnect");
	self endon("death");
	
	wait(5);
	
	while(1)
	{
		players = GET_PLAYERS();
		for(i=0;i<players.size;i++)
		{
	        if(!IsDefined (players[i].player_ammo_low))	
	        {
		        players[i].player_ammo_low = 0;
	        }	
	        if(!IsDefined(players[i].player_ammo_out))
	        {
		        players[i].player_ammo_out = 0;
	        }
			
			weap = players[i] getcurrentweapon();
			//iprintln("current weapon: " + weap);
			//iprintlnbold(weap);
			//Excludes all Perk based 'weapons' so that you don't get low ammo spam.
			if( !isDefined(weap) || 
					weap == "none" || 
					isSubStr( weap, "zombie_perk_bottle" ) || 
					is_placeable_mine( weap ) || 
					is_equipment( weap ) || 
					weap == level.revive_tool || 
					weap == "zombie_knuckle_crack" || 
					weap == "zombie_bowie_flourish" || 
					weap == "zombie_sickle_flourish" || 
					issubstr( weap, "knife_ballistic_" ) || 
					( GetSubStr( weap, 0, 3) == "gl_" ) || 
					weap == "humangun_zm" || 
					weap == "humangun_upgraded_zm" ||
					weap == "equip_gasmask_zm" ||
					weap == "lower_equip_gasmask_zm" ||
					weap == "riotshield_zm" )
			{
				continue;
			}
			//iprintln("checking ammo for " + weap);
			if ( players[i] GetAmmoCount( weap ) > 5)
			{
				continue;
			}		
			if ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
			{				
				continue;
			}
			else 
			if (players[i] GetAmmoCount( weap ) < 5 && players[i] GetAmmoCount( weap ) > 0)
			{
				if (players[i].player_ammo_low != 1 )
				{
					players[i].player_ammo_low = 1;
					players[i] maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "ammo_low" );		
					players[i] thread ammo_dialog_timer();
				}
	
			}
			else if (players[i] GetAmmoCount( weap ) == 0)
			{	
				if(!isDefined(weap) || weap == "none")
				{
					continue;	
				}
				wait(2);
				
				if( !isdefined( players[i] ) )
				{
					return;
				}
				
				if( players[i] GetAmmoCount( weap ) != 0 )
				{
					continue;
				}
				
				if( players[i].player_ammo_out != 1 )	
				{		
				    players[i].player_ammo_out = 1;
				    players[i] maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "ammo_out" );	
				    players[i] thread ammoout_dialog_timer();		
				}										
			}
			else
			{
				continue;
			}
		}
		wait(.5);
	}	
}
ammo_dialog_timer()
{
	self endon("disconnect");
	self endon("death");

	wait(20);
	self.player_ammo_low = 0;			
}
ammoout_dialog_timer()
{
	self endon("disconnect");
	self endon("death");

    wait(20);
	self.player_ammo_out = 0;
}

/*------------------------------------
audio plays when more than 1 player connects
------------------------------------*/
spawn_vo()
{
	//not sure if we need this
	wait(1);
	
	players = GET_PLAYERS();
	
	//just pick a random player for now and play some vo 
	if(players.size > 1)
	{
		player = random(players);
		index = maps\mp\zombies\_zm_weapons::get_player_index(player);
		player thread spawn_vo_player(index,players.size);
	}

}

spawn_vo_player(index,num)
{
	sound = "plr_" + index + "_vox_" + num +"play";
	self PlaySoundWithNotify(sound, "sound_done");			
	self waittill("sound_done");
}

precache_shaders()
{
 	PrecacheShader( "hud_chalk_1" );
 	PrecacheShader( "hud_chalk_2" );
 	PrecacheShader( "hud_chalk_3" );
 	PrecacheShader( "hud_chalk_4" );
 	PrecacheShader( "hud_chalk_5" );

	PrecacheShader( "zom_icon_community_pot" );
	PrecacheShader( "zom_icon_community_pot_strip" );

	precacheshader("zom_icon_player_life");
}

precache_models()
{
	//precachemodel( "char_ger_zombieeye" ); 
	
	precachemodel( "p_zom_win_bars_01_vert04_bend_180" ); 
	precachemodel( "p_zom_win_bars_01_vert01_bend_180" );
	precachemodel( "p_zom_win_bars_01_vert04_bend" ); 
	precachemodel( "p_zom_win_bars_01_vert01_bend" );
	PreCacheModel( "p_zom_win_cell_bars_01_vert04_bent" ); 
	precachemodel( "p_zom_win_cell_bars_01_vert01_bent" );
	PrecacheModel( "tag_origin" );

	// Counter models
	PrecacheModel( "p_zom_counter_0" );
	PrecacheModel( "p_zom_counter_1" );
	PrecacheModel( "p_zom_counter_2" );
	PrecacheModel( "p_zom_counter_3" );
	PrecacheModel( "p_zom_counter_4" );
	PrecacheModel( "p_zom_counter_5" );
	PrecacheModel( "p_zom_counter_6" );
	PrecacheModel( "p_zom_counter_7" );
	PrecacheModel( "p_zom_counter_8" );
	PrecacheModel( "p_zom_counter_9" );

	//	Bonus Points
	PrecacheModel( "zombie_z_money_icon" );
	
	if ( isDefined( level.precacheCustomCharacters ) )
	{
		self [[level.precacheCustomCharacters]]();
	}
}

init_shellshocks()
{
	level.player_killed_shellshock = "zombie_death";
	PrecacheShellshock( level.player_killed_shellshock );
	PrecacheShellShock( "pain" );
	PreCacheShellShock( "explosion" );
}

init_strings()
{
	PrecacheString( &"ZOMBIE_WEAPONCOSTAMMO" );
	PrecacheString( &"ZOMBIE_ROUND" );
	PrecacheString( &"SCRIPT_PLUS" );
	PrecacheString( &"ZOMBIE_GAME_OVER" );
	PrecacheString( &"ZOMBIE_SURVIVED_ROUND" );
	PrecacheString( &"ZOMBIE_SURVIVED_ROUNDS" );
	PrecacheString( &"ZOMBIE_SURVIVED_NOMANS" );
	PrecacheString( &"ZOMBIE_EXTRA_LIFE" );
 
	add_zombie_hint( "undefined", &"ZOMBIE_UNDEFINED" );

	// Random Treasure Chest
	add_zombie_hint( "default_treasure_chest_950", &"ZOMBIE_RANDOM_WEAPON_950" );

	// Barrier Pieces
	add_zombie_hint( "default_buy_barrier_piece_10", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_10" );
	add_zombie_hint( "default_buy_barrier_piece_20", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_20" );
	add_zombie_hint( "default_buy_barrier_piece_50", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_50" );
	add_zombie_hint( "default_buy_barrier_piece_100", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_100" );

	// REWARD Barrier Pieces
	add_zombie_hint( "default_reward_barrier_piece", &"ZOMBIE_BUTTON_REWARD_BARRIER" );
	add_zombie_hint( "default_reward_barrier_piece_10", &"ZOMBIE_BUTTON_REWARD_BARRIER_10" );
	add_zombie_hint( "default_reward_barrier_piece_20", &"ZOMBIE_BUTTON_REWARD_BARRIER_20" );
	add_zombie_hint( "default_reward_barrier_piece_30", &"ZOMBIE_BUTTON_REWARD_BARRIER_30" );
	add_zombie_hint( "default_reward_barrier_piece_40", &"ZOMBIE_BUTTON_REWARD_BARRIER_40" );
	add_zombie_hint( "default_reward_barrier_piece_50", &"ZOMBIE_BUTTON_REWARD_BARRIER_50" );

	// Debris
	add_zombie_hint( "default_buy_debris_100", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_100" );
	add_zombie_hint( "default_buy_debris_200", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_200" );
	add_zombie_hint( "default_buy_debris_250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_250" );
	add_zombie_hint( "default_buy_debris_500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_500" );
	add_zombie_hint( "default_buy_debris_750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_750" );
	add_zombie_hint( "default_buy_debris_1000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1000" );
	add_zombie_hint( "default_buy_debris_1250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1250" );
	add_zombie_hint( "default_buy_debris_1500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500" );
	add_zombie_hint( "default_buy_debris_1750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1750" );
	add_zombie_hint( "default_buy_debris_2000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_2000" );

	// Doors
	add_zombie_hint( "default_buy_door_100", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_100" );
	add_zombie_hint( "default_buy_door_200", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_200" );
	add_zombie_hint( "default_buy_door_250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_250" );
	add_zombie_hint( "default_buy_door_500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_500" );
	add_zombie_hint( "default_buy_door_750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_750" );
	add_zombie_hint( "default_buy_door_1000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1000" );
	add_zombie_hint( "default_buy_door_1250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1250" );
	add_zombie_hint( "default_buy_door_1500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1500" );
	add_zombie_hint( "default_buy_door_1750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1750" );
	add_zombie_hint( "default_buy_door_2000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2000" );
	add_zombie_hint( "default_buy_door_2500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2500" );
	add_zombie_hint( "default_buy_door_4000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_4000" );
	add_zombie_hint( "default_buy_door_8000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_8000" );
	add_zombie_hint( "default_buy_door_16000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_16000" );

	
	// Areas
	add_zombie_hint( "default_buy_area_100", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_100" );
	add_zombie_hint( "default_buy_area_200", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_200" );
	add_zombie_hint( "default_buy_area_250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_250" );
	add_zombie_hint( "default_buy_area_500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_500" );
	add_zombie_hint( "default_buy_area_750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_750" );
	add_zombie_hint( "default_buy_area_1000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1000" );
	add_zombie_hint( "default_buy_area_1250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1250" );
	add_zombie_hint( "default_buy_area_1500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1500" );
	add_zombie_hint( "default_buy_area_1750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1750" );
	add_zombie_hint( "default_buy_area_2000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_2000" );

	// POWER UPS
	add_zombie_hint( "powerup_fire_sale_cost", &"ZOMBIE_FIRE_SALE_COST" );

}

init_sounds()
{
	add_sound( "end_of_round", "mus_zmb_round_over" );
	add_sound( "end_of_game", "mus_zmb_game_over" ); //Had to remove this and add a music state switch so that we can add other musical elements.
	add_sound( "chalk_one_up", "mus_zmb_chalk" );
	add_sound( "purchase", "zmb_cha_ching" );
	add_sound( "no_purchase", "zmb_no_cha_ching" );

	// Zombification
	// TODO need to vary these up
	add_sound( "playerzombie_usebutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "playerzombie_attackbutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "playerzombie_adsbutton_sound", "zmb_zombie_vocals_attack" );

	// Head gib
	add_sound( "zombie_head_gib", "zmb_zombie_head_gib" );

	// Blockers
	add_sound( "rebuild_barrier_piece", "zmb_repair_boards" );
	add_sound( "rebuild_barrier_metal_piece", "zmb_metal_repair" );
	add_sound( "rebuild_barrier_hover", "zmb_boards_float" );
	add_sound( "debris_hover_loop", "zmb_couch_loop" );
	add_sound( "break_barrier_piece", "zmb_break_boards" );
	add_sound( "grab_metal_bar", "zmb_bar_pull" );
	add_sound( "break_metal_bar", "zmb_bar_break" );
	add_sound( "drop_metal_bar", "zmb_bar_drop" );
	add_sound("blocker_end_move", "zmb_board_slam");
	add_sound( "barrier_rebuild_slam", "zmb_board_slam" );
	add_sound( "bar_rebuild_slam", "zmb_bar_repair" );
	add_sound( "zmb_rock_fix", "zmb_break_rock_barrier_fix" );
	add_sound( "zmb_vent_fix", "evt_vent_slat_repair" );

	// Doors
	add_sound( "door_slide_open", "zmb_door_slide_open" );
	add_sound( "door_rotate_open", "zmb_door_slide_open" );

	// Debris
	add_sound( "debris_move", "zmb_weap_wall" );

	// Random Weapon Chest
	add_sound( "open_chest", "zmb_lid_open" );
	add_sound( "music_chest", "zmb_music_box" );
	add_sound( "close_chest", "zmb_lid_close" );

	// Weapons on walls
	add_sound( "weapon_show", "zmb_weap_wall" );
	
	add_sound( "break_stone", "break_stone" );
}

init_levelvars()
{
	// Variables
	// used to a check in last stand for players to become zombies
	level.is_zombie_level			= true; 
	level.laststandpistol			= "m1911_zm";		// so we dont get the uber colt when we're knocked out
	level.start_weapon				= "m1911_zm";
	level.first_round				= true;
	level.round_number				= 1;
	level.round_start_time			= 0;
	level.pro_tips_start_time		= 0;
	level.intermission				= false;
	level.dog_intermission			= false;
	level.zombie_total				= 0;
	level.total_zombies_killed		= 0;
	level.hudelem_count				= 0;
	level.zombie_move_speed			= 1; 
	level.zombie_spawn_locations				= [];				// List of normal zombie spawners
	level.zombie_rise_spawners		= [];				// List of zombie riser locations

	// Used for kill counters
	level.counter_model[0] = "p_zom_counter_0";
	level.counter_model[1] = "p_zom_counter_1";
	level.counter_model[2] = "p_zom_counter_2";
	level.counter_model[3] = "p_zom_counter_3";
	level.counter_model[4] = "p_zom_counter_4";
	level.counter_model[5] = "p_zom_counter_5";
	level.counter_model[6] = "p_zom_counter_6";
	level.counter_model[7] = "p_zom_counter_7";
	level.counter_model[8] = "p_zom_counter_8";
	level.counter_model[9] = "p_zom_counter_9";

	level.zombie_vars = [];

	difficulty = 1;
	column = int(difficulty) + 1;

	//#######################################################################
	// NOTE:  These values are in mp/zombiemode.csv and will override 
	//	whatever you put in as a value below.  However, if they don't exist
	//	in the file, then the values below will be used.
	//#######################################################################
	//	set_zombie_var( identifier, 					value,	float,	column );

	// AI
	set_zombie_var( "zombie_health_increase", 			100,	false,	column );	//	cumulatively add this to the zombies' starting health each round (up to round 10)
	set_zombie_var( "zombie_health_increase_multiplier",0.1, 	true,	column );	//	after round 10 multiply the zombies' starting health by this amount
	set_zombie_var( "zombie_health_start", 				150,	false,	column );	//	starting health of a zombie at round 1
	set_zombie_var( "zombie_spawn_delay", 				2.0,	true,	column );	// Base time to wait between spawning zombies.  This is modified based on the round number.
	set_zombie_var( "zombie_new_runner_interval", 		 10,	false,	column );	//	Interval between changing walkers who are too far away into runners 
	set_zombie_var( "zombie_move_speed_multiplier", 	  8,	false,	column );	//	Multiply by the round number to give the base speed value.  0-40 = walk, 41-70 = run, 71+ = sprint

	set_zombie_var( "zombie_max_ai", 					24,		false,	column );	//	Base number of zombies per player (modified by round #)
	set_zombie_var( "zombie_ai_per_player", 			6,		false,	column );	//	additional zombie modifier for each player in the game
	set_zombie_var( "below_world_check", 				-1000 );					//	Check height to see if a zombie has fallen through the world.

	// Round	
	set_zombie_var( "spectators_respawn", 				true );		// Respawn in the spectators in between rounds
	set_zombie_var( "zombie_use_failsafe", 				true );		// Will slowly kill zombies who are stuck
	set_zombie_var( "zombie_between_round_time", 		10 );		// How long to pause after the round ends
	set_zombie_var( "zombie_intermission_time", 		15 );		// Length of time to show the end of game stats
	set_zombie_var( "game_start_delay", 				0,		false,	column );	// How much time to give people a break before starting spawning

	// Life and death
	set_zombie_var( "penalty_no_revive", 				0.10, 	true,	column );	// Percentage of money you lose if you let a teammate die
	set_zombie_var( "penalty_died",						0.0, 	true,	column );	// Percentage of money lost if you die
	set_zombie_var( "penalty_downed", 					0.05, 	true,	column );	// Percentage of money lost if you go down // ww: told to remove downed point loss
	set_zombie_var( "starting_lives", 					1, 		false,	column );	// How many lives a solo player starts out with

	set_zombie_var( "zombie_score_kill_4player", 		50 );		// Individual Points for a zombie kill in a 4 player game
	set_zombie_var( "zombie_score_kill_3player",		50 );		// Individual Points for a zombie kill in a 3 player game
	set_zombie_var( "zombie_score_kill_2player",		50 );		// Individual Points for a zombie kill in a 2 player game
	set_zombie_var( "zombie_score_kill_1player",		50 );		// Individual Points for a zombie kill in a 1 player game

	set_zombie_var( "zombie_score_kill_4p_team", 		30 );		// Team Points for a zombie kill in a 4 player game
	set_zombie_var( "zombie_score_kill_3p_team",		35 );		// Team Points for a zombie kill in a 3 player game
	set_zombie_var( "zombie_score_kill_2p_team",		45 );		// Team Points for a zombie kill in a 2 player game
	set_zombie_var( "zombie_score_kill_1p_team",		 0 );		// Team Points for a zombie kill in a 1 player game

	set_zombie_var( "zombie_score_damage_normal",		10 );		// points gained for a hit with a non-automatic weapon
	set_zombie_var( "zombie_score_damage_light",		10 );		// points gained for a hit with an automatic weapon

	set_zombie_var( "zombie_score_bonus_melee", 		80 );		// Bonus points for a melee kill
	set_zombie_var( "zombie_score_bonus_head", 			50 );		// Bonus points for a head shot kill
	set_zombie_var( "zombie_score_bonus_neck", 			20 );		// Bonus points for a neck shot kill
	set_zombie_var( "zombie_score_bonus_torso", 		10 );		// Bonus points for a torso shot kill
	set_zombie_var( "zombie_score_bonus_burn", 			10 );		// Bonus points for a burn kill

	set_zombie_var( "zombie_flame_dmg_point_delay",		500 );	

	set_zombie_var( "zombify_player", 					false );	// Default to not zombify the player till further support

	if ( IsSplitScreen() )
	{
		set_zombie_var( "zombie_timer_offset", 			280 );	// hud offsets
	}
	
	level thread init_player_levelvars();
}

init_player_levelvars()
{
	flag_wait( "start_zombie_round_logic" );
	
	difficulty = 1;
	column = int(difficulty) + 1;	
	players = GET_PLAYERS();
	
	points = set_zombie_var( ("zombie_score_start_"+players.size+"p"), 3000, false, column );
	points = set_zombie_var( ("zombie_score_start_"+players.size+"p"), 3000, false, column );
}

init_dvars()
{
//t6.5todo: move these dvars out of script, dangerous to leave them here like this

	if( GetDvar( "zombie_debug" ) == "" )
	{
		SetDvar( "zombie_debug", "0" );
	}

	if( GetDvar( "scr_zm_enable_bots" ) == "" )
	{
		SetDvar( "scr_zm_enable_bots", "0" );
	}

	if( GetDvar( "zombie_cheat" ) == "" )
	{
		SetDvar( "zombie_cheat", "0" );
	}
	
	if ( level.script != "zombie_cod5_prototype" )
	{
		SetDvar( "magic_chest_movable", "1" );
	}

	SetDvar( "revive_trigger_radius", "75" ); 
	SetDvar( "player_lastStandBleedoutTime", "45" );

	SetDvar( "scr_deleteexplosivesonspawn", "0" );
}


init_mutators()
{
	level.mutators = [];

	init_mutator( "mutator_noPerks" );
	init_mutator( "mutator_noTraps" );
	init_mutator( "mutator_noMagicBox" );
	init_mutator( "mutator_noRevive" );
	init_mutator( "mutator_noPowerups" );
	init_mutator( "mutator_noReloads" );
	init_mutator( "mutator_noBoards" );
	init_mutator( "mutator_quickStart" );
	init_mutator( "mutator_headshotsOnly" );
	init_mutator( "mutator_friendlyFire" );
	init_mutator( "mutator_doubleMoney" );
	init_mutator( "mutator_susceptible" );
	init_mutator( "mutator_powerShot" );
	
	level.mutators["mutator_friendlyFire"] = 0;
}

init_mutator( mutator_s )
{
	level.mutators[ mutator_s ] = ( "1" == GetDvar( mutator_s ) );
}


init_function_overrides()
{
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.overridePlayerDamage		= ::player_damage_override; //_cheat;
	level.callbackPlayerKilled		= ::player_killed_override;
	
	level.playerlaststand_func		= ::player_laststand;
	level.callbackPlayerLastStand	= ::Callback_PlayerLastStand;
	
	level.prevent_player_damage		= ::player_prevent_damage;

	level.callbackActorKilled		= ::actor_killed_override;
	level.callbackActorDamage		= ::actor_damage_override_wrapper;

	level.custom_introscreen		= ::zombie_intro_screen; 
	level.custom_intermission		= ::player_intermission; 

	level.global_damage_func		= maps\mp\zombies\_zm_spawner::zombie_damage; 
	level.global_damage_func_ads	= maps\mp\zombies\_zm_spawner::zombie_damage_ads;
	
	level.reset_clientdvars			= ::onPlayerConnect_clientDvars;
	
	level.zombie_last_stand 		= ::last_stand_pistol_swap;
	level.zombie_last_stand_pistol_memory = ::last_stand_save_pistol_ammo;
	level.zombie_last_stand_ammo_return		= ::last_stand_restore_pistol_ammo;

	level.player_becomes_zombie		= ::zombify_player; 	
}

Callback_PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon( "disconnect" );
	//self Callback("on_player_last_stand");
	[[maps\mp\zombies\_zm_laststand::PlayerLastStand]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ); 
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && (eAttacker.sessionteam == self.sessionteam) && !eAttacker HasPerk( "specialty_noname" ) && !is_true( self.is_zombie ) )
	{
		if ( self != eAttacker )
		{
			//one player shouldn't damage another player, grenades, airstrikes called in by another player
		/#	println("Exiting - players can't hurt each other.");	#/
			return;
		}
		else if ( sMeansOfDeath != "MOD_GRENADE_SPLASH"
				&& sMeansOfDeath != "MOD_GRENADE"
				&& sMeansOfDeath != "MOD_EXPLOSIVE"
				&& sMeansOfDeath != "MOD_PROJECTILE"
				&& sMeansOfDeath != "MOD_PROJECTILE_SPLASH"
				&& sMeansOfDeath != "MOD_BURNED"
				&& sMeansOfDeath != "MOD_SUICIDE" )
		{
		/#	println("Exiting - damage type verbotten.");	#/
			//player should be able to damage they're selves with grenades and stuff
			//otherwise don't damage the player, so like airstrikes  won't kill the player
			return;
		}
	}
	
	if( IsDefined( self.overridePlayerDamage ) )
	{
		iDamage = self [[self.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
	else if( IsDefined( level.overridePlayerDamage ) )
	{
		iDamage = self [[level.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}

	Assert(IsDefined(iDamage), "You must return a value from a damage override function.");

//	self Callback("on_player_damage");

	if (is_true(self.magic_bullet_shield))
	{
		// save out and restore the maxHealth, because setting health below modifies it
		maxHealth = self.maxHealth;

		// increase health by damage, because it will be subtracted back out below in finishActorDamage
		self.health += iDamage;

		// restore the maxHealth to what it was
		self.maxHealth = maxHealth;
	}
	
	// DtP: When player is diving to prone away from the grenade, the damage is reduced

	// player is diving
	if( isdefined( self.divetoprone ) && self.divetoprone == 1 )
	{
		// grenade splash damage
		if( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
		{
			// if the player is at least 32 units away
			dist = Distance2d(vPoint, self.origin);
			if( dist > 32 )
			{
				// if player is diving away
				dot_product = vectordot( AnglesToForward( self.angles ), vDir ); 
				if( dot_product > 0 )
				{
					// grenade is behind player
					iDamage = int( iDamage * 0.5 ); // halves damage
				}
			}
		}
	}
	
/#	println("CB PD");	#/

	// players can only hurt themselves, zombie players can hurt any other player and be hurt by human players
/*	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && !eAttacker HasPerk( "specialty_noname" ) && !is_true( self.is_zombie ) )
	{
		if ( self != eAttacker )
		{
			//one player shouldn't damage another player, grenades, airstrikes called in by another player
			println("Exiting - players can't hurt each other.");
			return;
		}
		else if ( sMeansOfDeath != "MOD_GRENADE_SPLASH"
				&& sMeansOfDeath != "MOD_GRENADE"
				&& sMeansOfDeath != "MOD_EXPLOSIVE"
				&& sMeansOfDeath != "MOD_PROJECTILE"
				&& sMeansOfDeath != "MOD_PROJECTILE_SPLASH"
				&& sMeansOfDeath != "MOD_BURNED"
				&& sMeansOfDeath != "MOD_SUICIDE" )
		{
			println("Exiting - damage type verbotten.");
			//player should be able to damage they're selves with grenades and stuff
			//otherwise don't damage the player, so like airstrikes  won't kill the player
			return;
		}
	}*/

	if ( isdefined( level.prevent_player_damage ) )
	{
		if ( self [[ level.prevent_player_damage ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ) )
		{
			return;
		}
	}
	

	iDFlags = iDFlags | level.iDFLAGS_NO_KNOCKBACK;

/#	PrintLn("Finishplayerdamage wrapper.");		#/
	self finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ); 
}

finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ); 
	
	// the MP version of finishPlayerDamage does not take 11 parameters 
	// the 11 parameter version in SP does not take these parameters (10 is modelIndex and 11 is pOffsetTime)
	//surface = "flesh";
	//self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, surface );

}

init_flags()
{
	flag_init( "solo_game" );
	flag_init( "start_zombie_round_logic" );
	flag_init("start_encounters_match_logic");
	flag_init( "spawn_point_override" );
	flag_init( "power_on" );
	flag_init( "crawler_round" );
	flag_init( "spawn_zombies", true );
	flag_init( "dog_round" );
	flag_init( "begin_spawning" );
	flag_init( "end_round_wait" );
	flag_init( "wait_and_revive" );
	flag_init("instant_revive");
	flag_init( "_start_zm_pistol_rank" );
	flag_init("initial_blackscreen_passed");
	flag_init( "switchedsides" );
}

// Client flags registered here should be for global zombie systems, and should
// prefer to use high flag numbers and work downwards.

// Level specific flags should be registered in the level, and should prefer 
// low numbers, and work upwards.

// Ensure that this function and the function in _zombiemode.csc match.

init_client_flags()
{
	// Client flags for script movers
	
	level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM	= 15;
	
	
	if(is_true(level.use_clientside_board_fx))
	{
		//for tearing down and repairing the boards and rock chunks
		level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX	= 14;
		level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX	= 13;
	}
	if(is_true(level.use_clientside_rock_tearin_fx))
	{
		level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX	= 12;	
	}
	
	// Client flags for the player
	
	level._ZOMBIE_PLAYER_FLAG_CLOAK_WEAPON = 14;
	level._ZOMBIE_PLAYER_FLAG_DIVE2NUKE_VISION = 13;
	level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK = 12;

	if(is_true(level.riser_fx_on_client))
	{
		level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX = 8;
		if(!isDefined(level._no_water_risers))
		{
			level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX_WATER = 9;		
		}
		if(is_true(level.risers_use_low_gravity_fx))
		{
			level._ZOMBIE_ACTOR_ZOMBIE_RISER_LOWG_FX = 7;
		}
	}
}

init_fx()
{
	level.createfx_callback_thread = ::delete_in_createfx;

	level._effect["wood_chunk_destory"]	 		= LoadFX( "impacts/fx_large_woodhit" );
	level._effect["fx_zombie_bar_break"]		= LoadFX( "maps/zombie/fx_zombie_bar_break" );
	level._effect["fx_zombie_bar_break_lite"]	= LoadFX( "maps/zombie/fx_zombie_bar_break_lite" );
	
	level._effect["edge_fog"]			 		= LoadFX( "maps/zombie/fx_fog_zombie_amb" ); 
	level._effect["chest_light"]		 		= LoadFX( "env/light/fx_ray_sun_sm_short" ); 

	level._effect["eye_glow"]			 		= LoadFX( "misc/fx_zombie_eye_single" ); 

	level._effect["headshot"] 					= LoadFX( "impacts/fx_flesh_hit" );
	level._effect["headshot_nochunks"] 			= LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"] 				= LoadFX( "misc/fx_zombie_bloodspurt" );
	level._effect["tesla_head_light"]			= LoadFX( "maps/zombie/fx_zombie_tesla_neck_spurt");

	level._effect["rise_burst_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_burst");
	level._effect["rise_billow_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_billowing");
	level._effect["rise_dust_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_falling");

	level._effect["rise_burst"]					= LoadFX("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["rise_billow"]				= LoadFX("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["rise_dust"]					= LoadFX("maps/zombie/fx_mp_zombie_body_dust_falling");	

	level._effect["fall_burst"]					= LoadFX("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["fall_billow"]				= LoadFX("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["fall_dust"]					= LoadFX("maps/zombie/fx_mp_zombie_body_dust_falling");	

	// Flamethrower
	level._effect["character_fire_pain_sm"]     = LoadFX( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"]    = LoadFX( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFX( "env/fire/fx_fire_player_torso" );

	level._effect["def_explosion"]				= LoadFX("explosions/fx_default_explosion");
	level._effect["betty_explode"]				= LoadFX("weapon/bouncing_betty/fx_explosion_betty_generic");
	
//	level._effect["default_weapon_glow"]		= LoadFx("maps/zombie/fx_zmb_tranzit_weapon_glow");
	level._effect["870mcs_zm_fx"]						= LoadFx("maps/zombie/fx_zmb_wall_buy_870mcs");
	level._effect["ak74u_zm_fx"]						= LoadFx("maps/zombie/fx_zmb_wall_buy_ak74u");
	level._effect["beretta93r_zm_fx"]				= LoadFx("maps/zombie/fx_zmb_wall_buy_berreta93r");
	level._effect["bowie_knife_zm_fx"]			= LoadFx("maps/zombie/fx_zmb_wall_buy_bowie");
	level._effect["claymore_zm_fx"]					= LoadFx("maps/zombie/fx_zmb_wall_buy_claymore");
	level._effect["m14_zm_fx"]							= LoadFx("maps/zombie/fx_zmb_wall_buy_m14");
	level._effect["m16_zm_fx"]							= LoadFx("maps/zombie/fx_zmb_wall_buy_m16");
	level._effect["mp5k_zm_fx"]							= LoadFx("maps/zombie/fx_zmb_wall_buy_mp5k");
	level._effect["rottweil72_zm_fx"]				= LoadFx("maps/zombie/fx_zmb_wall_buy_olympia");
	level._effect["sticky_grenade_zm_fx"]		= LoadFx("maps/zombie/fx_zmb_wall_buy_semtex");
	level._effect["tazer_knuckles_zm_fx"]		= LoadFx("maps/zombie/fx_zmb_wall_buy_taseknuck");
}

// Handles the intro screen
zombie_intro_screen( string1, string2, string3, string4, string5 )
{
	flag_wait( "start_zombie_round_logic" );
}

players_playing()
{
	// initialize level.players_playing
	players = GET_PLAYERS();
	level.players_playing = players.size;

	wait( 20 );

	players = GET_PLAYERS();
	level.players_playing = players.size;
}


//
// NETWORK SECTION ====================================================================== //
//

onPlayerConnect_clientDvars()
{
	self SetClientCompass( 0 );
	self SetClientThirdPerson( 0 );
	self SetClientFOV( 65 );
	self SetClientThirdPersonAngle( 0 );
	self SetClientAmmoCounterHide( 1 );
	self SetClientMiniScoreboardHide( 1 );
	self SetClientHUDHardcore( 0 );
	self SetClientPlayerPushAmount( 1 );

	self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );
	
	self SetClientAimLockonPitchStrength( 0.0 );
	
	self maps\mp\zombies\_zm_laststand::player_getup_setup();
}



checkForAllDead()
{
	players = GET_PLAYERS();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( !(players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand()) && !(players[i].sessionstate == "spectator") )
		{
			count++;
		}
	}
	
	if( count==0 && !is_true( level.no_end_game_check ) )
	{
		level notify( "end_game" );
	}
}
	

//
//	Runs when the player spawns into the map
//	self is the player.surprise!
//
onPlayerSpawned()
{
	self endon( "disconnect" ); 

	for( ;; )
	{
		self waittill( "spawned_player" ); 
		
		self freezecontrols( false );
		self.hits = 0;

		self init_player_offhand_weapons();

/#
		if ( GetDvarInt( "zombie_cheat" ) >= 1 && GetDvarInt( "zombie_cheat" ) <= 3 ) 
		{
			self EnableInvulnerability();
		}
#/

		self SetActionSlot( 3, "altMode" );
		self PlayerKnockback( false );

		self SetClientThirdPerson( 0 );
		self SetClientFOV( 65 );
		self SetClientThirdPersonAngle( 0 );

		self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );

		self cameraactivate(false);

		self.num_perks = 0;
		self.on_lander_last_stand = undefined;
		
		if ( is_true( level.player_out_of_playable_area_monitor ) )
		{
			self thread player_out_of_playable_area_monitor();
		}

		if ( is_true( level.player_too_many_weapons_monitor ) )
		{
			self thread [[level.player_too_many_weapons_monitor_func]]();
		}

		if( isdefined( self.initialized ) )
		{
			if( self.initialized == false )
			{
				self.initialized = true; 
				
				//t6.5todo self freezecontrols( true ); // first spawn only, intro_black_screen will pull them out of it

				self giveweapon( self get_player_lethal_grenade() );	
				self setweaponammoclip( self get_player_lethal_grenade(), 0);
				self SetClientAmmoCounterHide( 0 );
				self SetClientMiniScoreboardHide( 0 );				
				// ww: set the is_drinking variable
				self.is_drinking = 0;

				// set the initial score on the hud		
				self maps\mp\zombies\_zm_score::set_player_score_hud( true ); 
				self thread player_zombie_breadcrumb();				
			
				self thread player_monitor_travel_dist();	

				self thread shock_onpain();

				self thread player_grenade_watcher();
				self maps\mp\zombies\_zm_laststand::revive_hud_create();
			
				if(isDefined(level.zm_gamemodule_spawn_func))
				{
					self thread [[level.zm_gamemodule_spawn_func]]();
				}

			}
		}
	}
}


spawn_life_brush( origin, radius, height )
{
	life_brush = spawn( "trigger_radius", origin, 0, radius, height );
	life_brush.script_noteworthy = "life_brush";
	
	return life_brush;
}


in_life_brush()
{
	life_brushes = getentarray( "life_brush", "script_noteworthy" );

	if ( !IsDefined( life_brushes ) )
	{
		return false;
	}
	
	for ( i = 0; i < life_brushes.size; i++ )
	{

		if ( self IsTouching( life_brushes[i] ) )
		{
			return true;
		}
	}

	return false;
}


spawn_kill_brush( origin, radius, height )
{
	kill_brush = spawn( "trigger_radius", origin, 0, radius, height );
	kill_brush.script_noteworthy = "kill_brush";
	
	return kill_brush;
}


in_kill_brush()
{
	kill_brushes = getentarray( "kill_brush", "script_noteworthy" );

	if ( !IsDefined( kill_brushes ) )
	{
		return false;
	}
	
	for ( i = 0; i < kill_brushes.size; i++ )
	{

		if ( self IsTouching( kill_brushes[i] ) )
		{
			return true;
		}
	}

	return false;
}


in_enabled_playable_area()
{
	playable_area = getentarray( "player_volume", "script_noteworthy" );

	if( !IsDefined( playable_area ) )
	{
		return false;
	}
	
	for ( i = 0; i < playable_area.size; i++ )
	{
		if ( maps\mp\zombies\_zm_zonemgr::zone_is_enabled( playable_area[i].targetname ) && self IsTouching( playable_area[i] ) )
		{
			return true;
		}
	}

	return false;
}


get_player_out_of_playable_area_monitor_wait_time()
{
/#
	if ( is_true( level.check_kill_thread_every_frame ) )
	{
		return 0.05;
	}
#/

	return 3;
}


player_out_of_playable_area_monitor()
{
	self notify( "stop_player_out_of_playable_area_monitor" );
	self endon( "stop_player_out_of_playable_area_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );

	// load balancing
	wait( (0.15 * self.characterindex) );

	while ( true )
	{
		// skip over players in spectate, otherwise Sam keeps laughing every 3 seconds since their corpse is still invisibly in a kill area
		if ( self.sessionstate == "spectator" )
		{
			wait( get_player_out_of_playable_area_monitor_wait_time() );
			continue;
		}

		if ( !self in_life_brush() && (self in_kill_brush() || !self in_enabled_playable_area()) )
		{
			if ( !isdefined( level.player_out_of_playable_area_monitor_callback ) || self [[level.player_out_of_playable_area_monitor_callback]]() )
			{
/#
				//iprintlnbold( "out of playable" );
				if ( isdefined( self isinmovemode( "ufo", "noclip" ) ) || is_true( level.disable_kill_thread ) || GetDvarInt( "zombie_cheat" ) > 0 )
				{
					wait( get_player_out_of_playable_area_monitor_wait_time() );
					continue;
				}
#/
 				if( is_true( level.player_4_vox_override ) )
				{
					self playlocalsound( "zmb_laugh_rich" );
				}
				else
				{
					self playlocalsound( "zmb_laugh_child" );	
				}
				
				wait( 0.5 );

				if ( GET_PLAYERS().size == 1 && flag( "solo_game" ) && is_true( self.waiting_to_revive ) )
				{
					level notify( "end_game" );
				}
				else
				{
					self.lives = 0;
					self dodamage( self.health + 1000, self.origin );
					self.bleedout_time = 0;
				}
			}
		}

		wait( get_player_out_of_playable_area_monitor_wait_time() );
	}
}


get_player_too_many_weapons_monitor_wait_time()
{
	return 3;
}


player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take )
{
	self endon( "player_too_many_weapons_monitor_takeaway_sequence_done" );

	self waittill_any( "player_downed", "replace_weapon_powerup" );

	for ( i = 0; i < primary_weapons_to_take.size; i++ )
	{
		self TakeWeapon( primary_weapons_to_take[i] );
	}

	self maps\mp\zombies\_zm_score::minus_to_player_score( self.score );
	self give_start_weapon( false );
	if ( !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		self decrement_is_drinking();
	}
	else if ( flag( "solo_game" ) )
	{
		self.score_lost_when_downed = 0;
	}

	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
}


player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take )
{
	self thread player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take );

	self endon( "player_downed" );
	self endon( "replace_weapon_powerup" );

	self increment_is_drinking();
	score_decrement = round_up_to_ten( int( self.score / (primary_weapons_to_take.size + 1) ) );

	for ( i = 0; i < primary_weapons_to_take.size; i++ )
	{
		if( is_true( level.player_4_vox_override ) )
		{
			self playlocalsound( "zmb_laugh_rich" );
		}
		else
		{
			self playlocalsound( "zmb_laugh_child" );	
		}
		self SwitchToWeapon( primary_weapons_to_take[i] );
		self maps\mp\zombies\_zm_score::minus_to_player_score( score_decrement );
		wait( 3 );

		self TakeWeapon( primary_weapons_to_take[i] );
	}

	if( is_true( level.player_4_vox_override ) )
	{
		self playlocalsound( "zmb_laugh_rich" );
	}
	else
	{
		self playlocalsound( "zmb_laugh_child" );	
	}
	self maps\mp\zombies\_zm_score::minus_to_player_score( self.score );
	wait( 1 );
	self give_start_weapon( true );
	self decrement_is_drinking();

	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
}

player_too_many_weapons_monitor()
{
	self notify( "stop_player_too_many_weapons_monitor" );
	self endon( "stop_player_too_many_weapons_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );

	// load balancing
	wait( (0.15 * self.characterindex) );

	while ( true )
	{
		if ( self has_powerup_weapon() || self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || self.sessionstate == "spectator" )
		{
			wait( get_player_too_many_weapons_monitor_wait_time() );
			continue;
		}

/#
		if ( GetDvarInt( "zombie_cheat" ) > 0 )
		{
			wait( get_player_too_many_weapons_monitor_wait_time() );
			continue;
		}
#/

		weapon_limit = 2;
		if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
		{
			weapon_limit = 3;
		}

		primaryWeapons = self GetWeaponsListPrimaries();

		if ( primaryWeapons.size > weapon_limit )
		{
			self maps\mp\zombies\_zm_weapons::take_fallback_weapon();
			primaryWeapons = self GetWeaponsListPrimaries();
		}

		primary_weapons_to_take = [];
		for ( i = 0; i < primaryWeapons.size; i++ )
		{
			if ( maps\mp\zombies\_zm_weapons::is_weapon_included( primaryWeapons[i] ) || maps\mp\zombies\_zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
			{
				primary_weapons_to_take[primary_weapons_to_take.size] = primaryWeapons[i];
			}
		}

		if ( primary_weapons_to_take.size > weapon_limit )
		{
			if ( !isdefined( level.player_too_many_weapons_monitor_callback ) || self [[level.player_too_many_weapons_monitor_callback]]( primary_weapons_to_take ) )
			{
				self thread player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take );
				self waittill( "player_too_many_weapons_monitor_takeaway_sequence_done" );
			}
		}

		wait( get_player_too_many_weapons_monitor_wait_time() );
	}
}


player_monitor_travel_dist()
{
	self endon("disconnect");
	
	prevpos = self.origin;
	while(1)
	{
		wait .1;

		self.pers["distance_traveled"] += distance( self.origin, prevpos ) ; 
		prevpos = self.origin;
	}
}

player_grenade_watcher()
{
	self endon( "disconnect" );

	while ( 1 )
	{
		self waittill( "grenade_fire", grenade, weapName );

		if( isdefined( grenade ) && isalive( grenade ) )
		{
			grenade.team = self.team;
		}
	}
}

player_prevent_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if( !isdefined( eInflictor ) || !isdefined( eAttacker ) )
	{
		return false;
	}
	
	if ( eInflictor == self || eAttacker == self )
	{
		return false;
	}

	if ( isdefined( eInflictor ) && isdefined( eInflictor.team ) )
	{
		if ( eInflictor.team == self.team )
		{
			return true;
		}
	}

	return false;
}

//
//	Keep track of players going down and getting revived
player_revive_monitor()
{
	self endon( "disconnect" ); 

	while (1)
	{
		self waittill( "player_revived", reviver );	
        
        //AYERS: Working on Laststand Audio
        //self clientnotify( "revived" );
        
		bbPrint( "zombie_playerdeaths: round %d playername %s deathtype revived x %f y %f z %f", level.round_number, self.name, self.origin );

		//self laststand_giveback_player_perks();

		if ( IsDefined(reviver) )
		{
			self maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "revive_up" );
			
			//reviver maps\_zombiemode_rank::giveRankXp( "revive" );
			//maps\_zombiemode_challenges::doMissionCallback( "zm_revive", reviver );

			// Check to see how much money you lost from being down.
			points = self.score_lost_when_downed;
			
		/#	println( "ZM >> LAST STAND - points = " + points);	#/
			
			reviver maps\mp\zombies\_zm_score::player_add_points( "reviver", points );
			self.score_lost_when_downed = 0;
		}
	}
}


// self = a player
// If the player has just 1 perk, they wil always get it back
// If the player has more than 1 perk, they will lose a single perk
laststand_giveback_player_perks()
{
	if ( IsDefined( self.laststand_perks ) )
	{
		// Calculate a lost perk index
		lost_perk_index = int( -1 );
		if( self.laststand_perks.size > 1 )
		{
			lost_perk_index = RandomInt( self.laststand_perks.size-1 );
		}
		
		// Give the player back their perks
		for ( i=0; i<self.laststand_perks.size; i++ )
		{
			if ( self HasPerk( self.laststand_perks[i] ) )
			{
				continue;
			}
			if( i == lost_perk_index )
			{
				continue;
			}
			
			maps\mp\zombies\_zm_perks::give_perk( self.laststand_perks[i] );
		}
	}
}

remote_revive_watch()
{
	self endon( "death" );
	self endon( "player_revived" );

	self waittill( "remote_revive", reviver );

	self maps\mp\zombies\_zm_laststand::remote_revive( reviver );
}

remove_deadshot_bottle()
{
	wait( 0.05 );

	if ( isdefined( self.lastActiveWeapon ) && self.lastActiveWeapon == "zombie_perk_bottle_deadshot" ) 
	{
		self.lastActiveWeapon = "none";
	}
}

take_additionalprimaryweapon()
{
	weapon_to_take = undefined;

	if ( is_true( self._retain_perks ) )
	{
		return weapon_to_take;
	}

	primary_weapons_that_can_be_taken = [];

	primaryWeapons = self GetWeaponsListPrimaries();
	for ( i = 0; i < primaryWeapons.size; i++ )
	{
		if ( maps\mp\zombies\_zm_weapons::is_weapon_included( primaryWeapons[i] ) || maps\mp\zombies\_zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
		{
			primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryWeapons[i];
		}
	}

	if ( primary_weapons_that_can_be_taken.size >= 3 )
	{
		weapon_to_take = primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size - 1];
		if ( weapon_to_take == self GetCurrentWeapon() )
		{
			self SwitchToWeapon( primary_weapons_that_can_be_taken[0] );
		}
		self TakeWeapon( weapon_to_take );
	}

	return weapon_to_take;
}

player_laststand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
/#	println( "ZM >> LAST STAND - player_laststand called" );	#/
	
	// Grab the perks, we'll give them back to the player if he's revived
	if ( is_true( self.HasPerkSpecialtyTombstone ) )
	{
		self.laststand_perks = maps\mp\zombies\_zm_tombstone::tombstone_save_perks( self );
	}

 	if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
 	{
		primary_weapons_that_can_be_taken = [];

		primaryWeapons = self GetWeaponsListPrimaries();
		for ( i = 0; i < primaryWeapons.size; i++ )
		{
			if ( maps\mp\zombies\_zm_weapons::is_weapon_included( primaryWeapons[i] ) || maps\mp\zombies\_zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
			{
				primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryWeapons[i];
			}
		}

		if ( primary_weapons_that_can_be_taken.size >= 3 )
		{
			weapon_to_take = primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size - 1];
			self TakeWeapon( weapon_to_take );
			self.weapon_taken_by_losing_specialty_additionalprimaryweapon = weapon_to_take;
		}
 	}

	//AYERS: Working on Laststand Audio
	/*
	players = GET_PLAYERS();
	if( players.size >= 2 )
	{
	    self clientnotify( "lststnd" );
	}
	*/
	
	if ( is_true( self.HasPerkSpecialtyTombstone ) )
	{
		self [[ level.tombstone_laststand_func ]]();
		self thread [[ level.tombstone_spawn_func ]]();
		
		self.HasPerkSpecialtyTombstone = undefined;
	
		self notify( "specialty_scavenger_stop" );
	}
	
	self clear_is_drinking();

	self thread remove_deadshot_bottle();
	
	self thread remote_revive_watch();
	
	self maps\mp\zombies\_zm_score::player_downed_penalty();
	
	// Turns out we need to do this after all, but we don't want to change _laststand.gsc postship, so I'm doing it here manually instead
	self DisableOffhandWeapons();

	self thread last_stand_grenade_save_and_return();
	
	if( sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_FALLING" )
	{
	    self maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "revive_down" );
	}
	
	bbPrint( "zombie_playerdeaths: round %d playername %s deathtype downed x %f y %f z %f", level.round_number, self.name, self.origin );
	
	if( IsDefined( level._zombie_minigun_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_minigun_powerup_last_stand_func]]();
	}
	
	if( IsDefined( level._zombie_tesla_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_tesla_powerup_last_stand_func]]();
	}

	if( IsDefined( self.intermission ) && self.intermission )
	{
		//maps\_zombiemode_challenges::doMissionCallback( "playerDied", self );

		bbPrint( "zombie_playerdeaths: round %d playername %s deathtype died x %f y %f z %f", level.round_number, self.name, self.origin );

		level waittill( "forever" );
	}
}


failsafe_revive_give_back_weapons()
{
	for ( i = 0; i < 10; i++ )
	{
		wait( 0.05 );
		
		if ( !isdefined( self.reviveProgressBar ) )
		{
			continue;
		}

		players = GET_PLAYERS();
		for ( playerIndex = 0; playerIndex < players.size; playerIndex++ )
		{
			revivee = players[playerIndex];

			if ( self maps\mp\zombies\_zm_laststand::is_reviving( revivee ) )
			{
				// don't clean up revive stuff if he is reviving someone else
				continue;
			}
		}

		// he's not reviving anyone but he still has revive stuff up, clean it all up
/#
iprintlnbold( "FAILSAFE CLEANING UP REVIVE HUD AND GUN" );
#/
		// pass in "none" since we have no idea what the weapon they should be showing is
		self maps\mp\zombies\_zm_laststand::revive_give_back_weapons( "none" );

		if ( isdefined( self.reviveProgressBar ) )
		{
			self.reviveProgressBar maps\mp\gametypes\_hud_util::destroyElem();
		}

		if ( isdefined( self.reviveTextHud ) )
		{
			self.reviveTextHud destroy();
		}

		return;
	}
}


spawnSpectator()
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	self notify( "spawned" ); 
	self notify( "end_respawn" );

	if( level.intermission )
	{
		return;
	}

	if( IsDefined( level.no_spectator ) && level.no_spectator )
	{
		wait( 3 );
		ExitLevel();
	}

	// The check_for_level_end looks for this
	self.is_zombie = true;

	//failsafe against losing viewarms due to the thread returning them getting an endon from "zombified"
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( self != players[i] )
		{
			players[i] thread failsafe_revive_give_back_weapons();
		}
	}

	// Remove all reviving abilities
	self notify ( "zombified" );

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}

	self.zombification_time = GetTime(); //set time when player died

	resetTimeout(); 

	// Stop shellshock and rumble
	self StopShellshock(); 
	self StopRumble( "damage_heavy" ); 

	self.sessionstate = "spectator"; 
	self.spectatorclient = -1;

	self.maxhealth = self.health;
	self.shellshocked = false; 
	self.inWater = false; 
	self.friendlydamage = undefined; 
	self.hasSpawned = true; 
	self.spawnTime = GetTime(); 
	self.afk = false; 

/#	println( "*************************Zombie Spectator***" );	#/
	self detachAll();

	self setSpectatePermissions( true );
	self thread spectator_thread();

	self Spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
}

setSpectatePermissions( isOn )
{
	self AllowSpectateTeam( "allies", isOn );
	self AllowSpectateTeam( "axis", false );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", false );	
}

spectator_thread()
{
	self endon( "disconnect" ); 
	self endon( "spawned_player" );

/*	we are not currently supporting the shared screen tech
	if( IsSplitScreen() )
	{
		last_alive = undefined;
		players = GET_PLAYERS();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, true );

		return;
	}
*/

//	self thread spectator_toggle_3rd_person();
}

spectator_toggle_3rd_person()
{
	self endon( "disconnect" ); 
	self endon( "spawned_player" );

	third_person = true;
	self set_third_person( true );
	//	self NotifyOnCommand( "toggle_3rd_person", "weapnext" );

	//	while( 1 )
	//	{
	//		self waittill( "toggle_3rd_person" );
	//
	//		if( third_person )
	//		{
	//			third_person = false;
	//			self set_third_person( false );
	//			wait( 0.5 );
	//		}
	//		else
	//		{
	//			third_person = true;
	//			self set_third_person( true );
	//			wait( 0.5 );
	//		}
	//	}
}


set_third_person( value )
{
	if( value )
	{
		self SetClientThirdPerson( 1 );
		self SetClientFOV( 40 );
		self SetClientThirdPersonAngle( 354 );

		self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
	}
	else
	{
		self SetClientThirdPerson( 0 );
		self SetClientFOV( 65 );
		self SetClientThirdPersonAngle( 0 );

		self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
	}
}

last_stand_revive()
{
	level endon( "between_round_over" );

	players = GET_PLAYERS();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && players[i].revivetrigger.beingRevived == 0 )
		{
			players[i] maps\mp\zombies\_zm_laststand::auto_revive();
		}
	}
}

// ww: arrange the last stand pistols so when it come time to choose which one they are inited
last_stand_pistol_rank_init()
{
	level.pistol_values = [];
	
	flag_wait( "_start_zm_pistol_rank" );
	
	if( flag( "solo_game" ) ) 
	{
		// ww: in a solo game the ranking of the pistols is a bit different based on the upgraded 1911 swap
		// any pistol ranked 4 or lower will be ignored and the player will be given the upgraded 1911
		level.pistol_values[ level.pistol_values.size ] = "m1911_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm"; // ww: this is spot 4, anything scoring lower than this should be replaced
		level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "m1911_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_zm";
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_upgraded_zm";
	}
	else
	{
		level.pistol_values[ level.pistol_values.size ] = "m1911_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "m1911_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_zm";
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_upgraded_zm";
	}

}

// ww: changing the _laststand scripts to this one so we interfere with SP less
last_stand_pistol_swap()
{
	if ( self has_powerup_weapon() )
	{
		// this will force the laststand module to switch us to any primary weapon, since we will no longer have this after revive
		self.lastActiveWeapon = "none";
	}

	if ( !self HasWeapon( self.laststandpistol ) )
	{
		self GiveWeapon( self.laststandpistol );
	}
	ammoclip = WeaponClipSize( self.laststandpistol );
	doubleclip = ammoclip * 2;
	
	if( is_true( self._special_solo_pistol_swap ) || (self.laststandpistol == "m1911_upgraded_zm" && !self.hadpistol) )
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = false;
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if( flag("solo_game") && self.laststandpistol == "m1911_upgraded_zm")
	{
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol == "m1911_zm" )
	{
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol == "ray_gun_zm" || self.laststandpistol == "ray_gun_upgraded_zm" )
	{
		if ( self.stored_weapon_info[ self.laststandpistol ].total_amt >= ammoclip )
		{
			self SetWeaponAmmoClip( self.laststandpistol, ammoclip );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = ammoclip;
		}
		else
		{
			self SetWeaponAmmoClip( self.laststandpistol, self.stored_weapon_info[ self.laststandpistol ].total_amt );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = self.stored_weapon_info[ self.laststandpistol ].total_amt;
		}
		self SetWeaponAmmoStock( self.laststandpistol, 0 );
	}
	else
	{
		if ( self.stored_weapon_info[ self.laststandpistol ].stock_amt >= doubleclip )
		{
			self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = doubleclip + self.stored_weapon_info[ self.laststandpistol ].clip_amt + self.stored_weapon_info[ self.laststandpistol ].left_clip_amt;
		}
		else
		{
			self SetWeaponAmmoStock( self.laststandpistol, self.stored_weapon_info[ self.laststandpistol ].stock_amt );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = self.stored_weapon_info[ self.laststandpistol ].total_amt;
		}
	}
	
	self SwitchToWeapon( self.laststandpistol );
}

// ww: make sure the player has the best pistol when they go in to last stand
last_stand_best_pistol()
{
	pistol_array = [];

	current_weapons = self GetWeaponsListPrimaries();
	
	for( i = 0; i < current_weapons.size; i++ )
	{
		// make sure the weapon is a pistol
		if( WeaponClass( current_weapons[i] ) == "pistol" )
		{
			if (  (current_weapons[i] != "m1911_zm" && !flag("solo_game") )  || (!flag("solo_game") && current_weapons[i] != "m1911_upgraded_zm" ))
			{
				
				if ( self GetAmmoCount( current_weapons[i] ) <= 0 )
				{
					continue;
				}
			}

			pistol_array_index = pistol_array.size; // set up the spot in the array 
			pistol_array[ pistol_array_index ] = SpawnStruct(); // struct to store info on
			
			pistol_array[ pistol_array_index ].gun = current_weapons[i];
			pistol_array[ pistol_array_index ].value = 0; // add a value in case a new weapon is introduced that hasn't been set up in level.pistol_values
			
			// compare the current weapon to the level.pistol_values to see what the value is
			for( j = 0; j < level.pistol_values.size; j++ )
			{
				if( level.pistol_values[j] == current_weapons[i] )
				{
					pistol_array[ pistol_array_index ].value = j;
					break;
				}
			}
		}
	}
	
	self.laststandpistol = last_stand_compare_pistols( pistol_array );
}

// ww: compares the array passed in for the highest valued pistol
last_stand_compare_pistols( struct_array )
{
	if( !IsArray( struct_array ) || struct_array.size <= 0 )
	{
		self.hadpistol = false;
		
		//array will be empty if the pistol had no ammo...so lets see if the player had the pistol
		if(isDefined(self.stored_weapon_info))
		{
			stored_weapon_info = GetArrayKeys( self.stored_weapon_info );
			for( j = 0; j < stored_weapon_info.size; j++ )
			{
				if( stored_weapon_info[ j ] == level.laststandpistol)
				{
					self.hadpistol = true;
				}
			}
		}
				
		return level.laststandpistol; // nothing in the array then give the level last stand pistol
	}
	
	highest_score_pistol = struct_array[0]; // first time through give the first one to the highest score

	for( i = 1; i < struct_array.size; i++ )
	{
		if( struct_array[i].value > highest_score_pistol.value )
		{
			highest_score_pistol = struct_array[i];
		}
	}

	if( flag( "solo_game" ) )
	{
		self._special_solo_pistol_swap = 0; // ww: this way the weapon knows to pack texture when given
		if( highest_score_pistol.value <= 4 )
		{
			self.hadpistol = false;
			self._special_solo_pistol_swap = 1;
			return level.laststandpistol; // ww: if it scores too low the player gets the 1911 upgraded
		}
		else
		{
			return highest_score_pistol.gun; // ww: gun is high in ranking and won't be replaced
		}
	}
	else // ww: happens when not in solo
	{
		return highest_score_pistol.gun;
	}

}

// ww: override function for saving player pistol ammo count
last_stand_save_pistol_ammo()
{
	weapon_inventory = self GetWeaponsList( true );
	self.stored_weapon_info = [];

	for( i = 0; i < weapon_inventory.size; i++ )
	{
		weapon = weapon_inventory[i];

		if ( WeaponClass( weapon ) == "pistol" ) 
		{
			self.stored_weapon_info[ weapon ] = SpawnStruct();
			self.stored_weapon_info[ weapon ].clip_amt = self GetWeaponAmmoClip( weapon );
			self.stored_weapon_info[ weapon ].left_clip_amt = 0;
			dual_wield_name = WeaponDualWieldWeaponName( weapon );
			if ( "none" != dual_wield_name )
			{
				self.stored_weapon_info[ weapon ].left_clip_amt = self GetWeaponAmmoClip( dual_wield_name );
			}
			self.stored_weapon_info[ weapon ].stock_amt = self GetWeaponAmmoStock( weapon );
			self.stored_weapon_info[ weapon ].total_amt = self.stored_weapon_info[ weapon ].clip_amt + self.stored_weapon_info[ weapon ].left_clip_amt + self.stored_weapon_info[ weapon ].stock_amt;
			self.stored_weapon_info[ weapon ].given_amt = 0;
		}
	}
	
	self last_stand_best_pistol();
}

// ww: override to restore the player's pistol ammo after being picked up
last_stand_restore_pistol_ammo()
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;

	if( !IsDefined( self.stored_weapon_info ) )
	{
		return;
	}
	
	weapon_inventory = self GetWeaponsList( true );
	weapon_to_restore = GetArrayKeys( self.stored_weapon_info );
	
	for( i = 0; i < weapon_inventory.size; i++ )
	{
		weapon = weapon_inventory[i];
		
		if ( weapon != self.laststandpistol )
		{
			continue;
		}
		
		for( j = 0; j < weapon_to_restore.size; j++ )
		{
			check_weapon = weapon_to_restore[j];
			
			if( weapon == check_weapon )
			{
				dual_wield_name = WeaponDualWieldWeaponName( weapon_to_restore[j] );
				if ( weapon != "m1911_zm" )
				{
					last_clip = self GetWeaponAmmoClip( weapon );
					last_left_clip = 0;
					if ( "none" != dual_wield_name )
					{
						last_left_clip = self GetWeaponAmmoClip( dual_wield_name );
					}
					last_stock = self GetWeaponAmmoStock( weapon );
					last_total = last_clip + last_left_clip + last_stock;

					used_amt = self.stored_weapon_info[ weapon ].given_amt - last_total;

					if ( used_amt >= self.stored_weapon_info[ weapon ].stock_amt )
					{
						used_amt -= self.stored_weapon_info[ weapon ].stock_amt;
						self.stored_weapon_info[ weapon ].stock_amt = 0;

						self.stored_weapon_info[ weapon ].clip_amt -= used_amt;
						if ( self.stored_weapon_info[ weapon ].clip_amt < 0 )
						{
							self.stored_weapon_info[ weapon ].clip_amt = 0;
						}
					}
					else 
					{
						new_stock_amt = self.stored_weapon_info[ weapon ].stock_amt - used_amt;
						if ( new_stock_amt < self.stored_weapon_info[ weapon ].stock_amt )
						{
							self.stored_weapon_info[ weapon ].stock_amt = new_stock_amt;
						}
					}
				}

				self SetWeaponAmmoClip( weapon_to_restore[j], self.stored_weapon_info[ weapon_to_restore[j] ].clip_amt );
				if ( "none" != dual_wield_name )
				{
					self SetWeaponAmmoClip( dual_wield_name , self.stored_weapon_info[ weapon_to_restore[j] ].left_clip_amt );
				}
				self SetWeaponAmmoStock( weapon_to_restore[j], self.stored_weapon_info[ weapon_to_restore[j] ].stock_amt );
				break;
			}
		}
	}
}

// ww: changes the last stand pistol to the upgraded 1911s if it is solo
zombiemode_solo_last_stand_pistol()
{
	level.laststandpistol = "m1911_upgraded_zm";
}

// ww: zeros out the player's grenades until they revive
last_stand_grenade_save_and_return()
{
	self endon( "death" );
	
	lethal_nade_amt = 0;
	has_lethal_nade = false;
	tactical_nade_amt = 0;
	has_tactical_nade = false;
	
	// figure out which nades this player has
	weapons_on_player = self GetWeaponsList( true );
	for ( i = 0; i < weapons_on_player.size; i++ )
	{
		if ( self is_player_lethal_grenade( weapons_on_player[i] ) )
		{
			has_lethal_nade = true;
			lethal_nade_amt = self GetWeaponAmmoClip( self get_player_lethal_grenade() );
			self SetWeaponAmmoClip( self get_player_lethal_grenade(), 0 );
			self TakeWeapon( self get_player_lethal_grenade() );
		}
		else if ( self is_player_tactical_grenade( weapons_on_player[i] ) )
		{
			has_tactical_nade = true;
			tactical_nade_amt = self GetWeaponAmmoClip( self get_player_tactical_grenade() );
			self SetWeaponAmmoClip( self get_player_tactical_grenade(), 0 );
			self TakeWeapon( self get_player_tactical_grenade() );
		}
	}
	
	self waittill( "player_revived" );
	
	if ( has_lethal_nade )
	{
		self GiveWeapon( self get_player_lethal_grenade() );
		self SetWeaponAmmoClip( self get_player_lethal_grenade(), lethal_nade_amt );
	}
	
	if ( has_tactical_nade )
	{
		self GiveWeapon( self get_player_tactical_grenade() );
		self SetWeaponAmmoClip( self get_player_tactical_grenade(), tactical_nade_amt );
	}
}

spectators_respawn()
{
	level endon( "between_round_over" );

	if( !IsDefined( level.zombie_vars["spectators_respawn"] ) || !level.zombie_vars["spectators_respawn"] )
	{
		return;
	}

	if( !IsDefined( level.custom_spawnPlayer ) )
	{
		// Custom spawn call for when they respawn from spectator
		level.custom_spawnPlayer = ::spectator_respawn;
	}

	while( 1 )
	{
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "spectator" && IsDefined( players[i].spectator_respawn ))	
			{
				players[i] [[level.spawnPlayer]]();
				if (isDefined(level.script) && level.round_number > 6 && players[i].score < 1500)
				{
					players[i].old_score = players[i].score;
					players[i].score = 1500;
					players[i] maps\mp\zombies\_zm_score::set_player_score_hud();
				}
			}
		}

		wait( 1 );
	}
}

spectator_respawn()
{
/#	println( "*************************Respawn Spectator***" );	#/
	assert( IsDefined( self.spectator_respawn ) );

	origin = self.spectator_respawn.origin;
	angles = self.spectator_respawn.angles;

	self setSpectatePermissions( false );

	new_origin = undefined;
	
	
	if ( isdefined( level.check_valid_spawn_override ) )
	{
		new_origin = [[ level.check_valid_spawn_override ]]( self );
	}

	if ( !isdefined( new_origin ) )
	{
		new_origin = check_for_valid_spawn_near_team( self );
	}
	

	if( IsDefined( new_origin ) )
	{
		self Spawn( new_origin, angles );
	}
	else
	{
		self Spawn( origin, angles );
	}


	if ( IsDefined( self get_player_placeable_mine() ) )
	{
		self TakeWeapon( self get_player_placeable_mine() );
		self set_player_placeable_mine( undefined );
	}

	self maps\mp\zombies\_zm_equipment::equipment_take();

	self.is_burning = undefined;
	self.abilities = [];

	// The check_for_level_end looks for this
	self.is_zombie = false;
	self.ignoreme = false;

	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self RevivePlayer();

	self notify( "spawned_player" );

	if(IsDefined(level._zombiemode_post_respawn_callback))
	{
		self thread [[level._zombiemode_post_respawn_callback]]();
	}
	
	// Penalize the player when we respawn, since he 'died'
	self maps\mp\zombies\_zm_score::player_reduce_points( "died" );
	
	self maps\mp\zombies\_zm_melee_weapon::spectator_respawn_all();

	// ww: inside _zombiemode_claymore the claymore triggers are fixed for players who haven't bought them
	// to see them after someone respawns from bleedout
	// it isn't the best way to do it but it is late in the project and probably better if i don't modify it
	// unless a bug comes through on it
	claymore_triggers = getentarray("claymore_purchase","targetname");
	for(i = 0; i < claymore_triggers.size; i++)
	{
		claymore_triggers[i] SetVisibleToPlayer(self);
		claymore_triggers[i].claymores_triggered = false;		
	}	

	self thread player_zombie_breadcrumb();

	return true;
}

check_for_valid_spawn_near_team( revivee, return_struct )
{

	players = GET_PLAYERS();
	//spawn_points = getstructarray("player_respawn_point", "targetname");
	spawn_points = maps\mp\gametypes\_zm_gametype::get_player_spawns_for_gametype();
	
	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;

	if( spawn_points.size == 0 )
		return undefined;

	// Look for the closest group that is within the specified ideal distances
	//	If we can't find one within a valid area, use the closest unlocked group.
	for( i = 0; i < players.size; i++ )
	{
		if( is_player_valid( players[i] ) && (players[i] != self) )
		{
			for( j = 0 ; j < spawn_points.size; j++ )
			{
				if( isdefined(spawn_points[i].script_int) )
					ideal_distance = spawn_points[i].script_int;
				else
					ideal_distance = 1000;

				if ( spawn_points[j].locked == false )
				{
					plyr_dist = DistanceSquared( players[i].origin, spawn_points[j].origin );
					if( plyr_dist < ( ideal_distance * ideal_distance ) )
					{
						if ( plyr_dist < closest_distance )
						{
							closest_distance = plyr_dist;
							closest_group = j;
						}
					}
					else
					{
						if ( plyr_dist < backup_distance )
						{
							backup_group = j;
							backup_distance = plyr_dist;
						}
					}
				}
			}
		}
		//	If we don't have a closest_group, let's use the backup
		if ( !IsDefined( closest_group ) )
		{
			closest_group = backup_group;
		}

		if ( IsDefined( closest_group ) )
		{
			spawn_array = getstructarray( spawn_points[closest_group].target, "targetname" );
			spawn_array = array_randomize(spawn_array);
			
			for( k = 0; k < spawn_array.size; k++ )
			{
				if(!positionWouldTelefrag(spawn_array[k].origin))
				{	
					if(is_true(return_struct))
					{
						return spawn_array[k];
					}
					else
					{			
						return spawn_array[k].origin;
					}
				}
			}	

			if(is_true(return_struct))
			{
				return spawn_array[0];
			}
			
			return spawn_array[0].origin;
		}
	}

	return undefined;

}


get_players_on_team(exclude)
{

	teammates = [];

	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{		
		//check to see if other players on your team are alive and not waiting to be revived
		if(players[i].spawn_side == self.spawn_side && !isDefined(players[i].revivetrigger) && players[i] != exclude )
		{
			teammates[teammates.size] = players[i];
		}
	}

	return teammates;
}



get_safe_breadcrumb_pos( player )
{
	players = GET_PLAYERS();
	valid_players = [];

	min_dist = 150 * 150;
	for( i = 0; i < players.size; i++ )
	{
		if( !is_player_valid( players[i] ) )
		{
			continue;
		}

		valid_players[valid_players.size] = players[i];
	}

	for( i = 0; i < valid_players.size; i++ )
	{
		count = 0;
		for( q = 1; q < player.zombie_breadcrumbs.size; q++ )
		{
			if( DistanceSquared( player.zombie_breadcrumbs[q], valid_players[i].origin ) < min_dist )
			{
				continue;
			}
			
			count++;
			if( count == valid_players.size )
			{
				return player.zombie_breadcrumbs[q];
			}
		}
	}

	return undefined;
}

default_max_zombie_func( max_num )
{
	max = max_num;

	if ( level.first_round )
	{
		max = int( max_num * 0.25 );	
	}
	else if (level.round_number < 3)
	{
		max = int( max_num * 0.3 );
	}
	else if (level.round_number < 4)
	{
		max = int( max_num * 0.5 );
	}
	else if (level.round_number < 5)
	{
		max = int( max_num * 0.7 );
	}
	else if (level.round_number < 6)
	{
		max = int( max_num * 0.9 );
	}
	
	return max;
}

round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/

	if( level.intermission )
	{
		return;
	}


/#
	if ( GetDvarInt( "zombie_cheat" ) == 2 || GetDvarInt( "zombie_cheat" ) >= 4 ) 
	{
		return;
	}
#/

	if( level.zombie_spawn_locations.size < 1 )
	{
		ASSERTMSG( "No active spawners in the map.  Check to see if the zone is active and if it's pointing to spawners." ); 
		return; 
	}

	ai_calculate_health( level.round_number ); 

	count = 0; 

	//CODER MOD: TOMMY K
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		players[i].zombification_time = 0;
	}

	max = level.zombie_vars["zombie_max_ai"];

	multiplier = level.round_number / 5;
	if( multiplier < 1 )
	{
		multiplier = 1;
	}

	// After round 10, exponentially have more AI attack the player
	if( level.round_number >= 10 )
	{
		multiplier *= level.round_number * 0.15;
	}

	player_num = GET_PLAYERS().size;

	if( player_num == 1 )
	{
		max += int( ( 0.5 * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}
	else
	{
		max += int( ( ( player_num - 1 ) * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}

	if( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = ::default_max_zombie_func;
	}

	// Now set the total for the new round, except when it's already been set by the
	//	kill counter.
	if ( !(IsDefined( level.kill_counter_hud ) && level.zombie_total > 0) )
	{
		level.zombie_total = [[ level.max_zombie_func ]]( max );
		level notify( "zombie_total_set" );
	}
	
	if ( IsDefined( level.zombie_total_set_func ) )
	{
		level thread [[ level.zombie_total_set_func ]]();
	}
	
	if ( level.round_number < 10 )
	{
		level thread zombie_speed_up();
	}

	mixed_spawns = 0;	// Number of mixed spawns this round.  Currently means number of dogs in a mixed round

	// DEBUG HACK:	
	//max = 1;
	old_spawn = undefined;
//	while( level.zombie_total > 0 )
	while( 1 )
	{
		while( get_enemy_count() >= level.zombie_ai_limit || level.zombie_total <= 0 )
		{
			wait( 0.1 );
		}
		
		// added ability to pause zombie spawning
		if ( !flag("spawn_zombies" ) )
		{
			flag_wait( "spawn_zombies" );
		}

		spawn_point = level.zombie_spawn_locations[RandomInt( level.zombie_spawn_locations.size )]; 

		if( !IsDefined( old_spawn ) )
		{
				old_spawn = spawn_point;
		}
		else if( Spawn_point == old_spawn )
		{
				spawn_point = level.zombie_spawn_locations[RandomInt( level.zombie_spawn_locations.size )]; 
		}
		old_spawn = spawn_point;

	//	iPrintLn(spawn_point.targetname + " " + level.zombie_vars["zombie_spawn_delay"]);

		// MM Mix in dog spawns...
		if ( IsDefined( level.mixed_rounds_enabled ) && level.mixed_rounds_enabled == 1 )
		{
			spawn_dog = false;
			if ( level.round_number > 30 )
			{
				if ( RandomInt(100) < 3 )
				{
					spawn_dog = true;
				}
			}
			else if ( level.round_number > 25 && mixed_spawns < 3 )
			{
				if ( RandomInt(100) < 2 )
				{
					spawn_dog = true;
				}
			}
			else if ( level.round_number > 20 && mixed_spawns < 2 )
			{
				if ( RandomInt(100) < 2 )
				{
					spawn_dog = true;
				}
			}
			else if ( level.round_number > 15 && mixed_spawns < 1 )
			{
				if ( RandomInt(100) < 1 )
				{
					spawn_dog = true;
				}
			}
			
			if ( spawn_dog )
			{
				keys = GetArrayKeys( level.zones );
				for ( i=0; i<keys.size; i++ )
				{
					if ( level.zones[ keys[i] ].is_occupied )
					{
						akeys = GetArrayKeys( level.zones[ keys[i] ].adjacent_zones );
						for ( k=0; k<akeys.size; k++ )
						{
							if ( level.zones[ akeys[k] ].is_active &&
								 !level.zones[ akeys[k] ].is_occupied &&
								 level.zones[ akeys[k] ].dog_locations.size > 0 )
							{
								maps\mp\zombies\_zm_ai_dogs::special_dog_spawn( undefined, 1 );
								level.zombie_total--;
								wait_network_frame();
							}
						}
					}
				}
			}
		}

		if(IsDefined(level.zombie_spawners))
		{
			spawner = random(level.zombie_spawners);		
			ai = spawn_zombie( spawner,spawner.targetname,spawn_point); 
 		}
 		
		if( IsDefined( ai ) )
		{
			level.zombie_total--;
			ai thread round_spawn_failsafe();
			count++; 
		}

		wait( level.zombie_vars["zombie_spawn_delay"] ); 
		wait_network_frame();
	}
}

//
//	Make the last few zombies run
//
zombie_speed_up()
{
	if( level.round_number <= 3 )
	{
		return;
	}

	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/

	// Wait until we've finished spawning
	while ( level.zombie_total > 4 )
	{
		wait( 2.0 );
	}

	// Now wait for these guys to get whittled down
	num_zombies = get_enemy_count();
	while( num_zombies > 3 )
	{
		wait( 2.0 );

		num_zombies = get_enemy_count();
	}

	zombies = get_round_enemy_array(); //GetAiSpeciesArray( "axis", "all" );
	
	while( zombies.size > 0 )
	{
		if( zombies.size == 1 && zombies[0].has_legs == true )
		{
			if ( isdefined( level.zombie_speed_up ) )
			{
				zombies[0] thread [[ level.zombie_speed_up ]]();
				break;
			}
			else
			{
				//set_zombie_run_cycle to sprint
				if( zombies[0].zombie_move_speed != "sprint" )
				{
					zombies[0] set_zombie_run_cycle( "sprint" );
					zombies[0].zombie_move_speed_original = zombies[0].zombie_move_speed;
				}
			}
		}
		wait(0.5);
		zombies = get_round_enemy_array(); //GetAiSpeciesArray( "axis", "all" );
	}
}

// TESTING: spawn one zombie at a time
round_spawning_test()
{
	while (true)
	{
		spawn_point = level.zombie_spawn_locations[RandomInt( level.zombie_spawn_locations.size )];	// grab a random spawner

		spawner = random(level.zombie_spawners);		
		ai = spawn_zombie( spawner,spawner.targetname,spawn_point); 
		
		ai waittill("death");

		wait 5;
	}
}


/////////////////////////////////////////////////////////

// round_text( text )
// {
// 	if( level.first_round )
// 	{
// 		intro = true;
// 	}
// 	else
// 	{
// 		intro = false;
// 	}
// 
// 	hud = create_simple_hud();
// 	hud.horzAlign = "center"; 
// 	hud.vertAlign = "middle";
// 	hud.alignX = "center"; 
// 	hud.alignY = "middle";
// 	hud.y = -100;
// 	hud.foreground = 1;
// 	hud.fontscale = 16.0;
// 	hud.alpha = 0; 
// 	hud.color = ( 1, 1, 1 );
// 
// 	hud SetText( text ); 
// 	hud FadeOverTime( 1.5 );
// 	hud.alpha = 1;
// 	wait( 1.5 );
// 
// 	if( intro )
// 	{
// 		wait( 1 );
// 		level notify( "intro_change_color" );
// 	}
// 
// 	hud FadeOverTime( 3 );
// 	//hud.color = ( 0.8, 0, 0 );
// 	hud.color = ( 0.21, 0, 0 );
// 	wait( 3 );
// 
// 	if( intro )
// 	{
// 		level waittill( "intro_hud_done" );
// 	}
// 
// 	hud FadeOverTime( 1.5 );
// 	hud.alpha = 0;
// 	wait( 1.5 ); 
// 	hud destroy();
// }


//	Allows the round to be paused.  Displays a countdown timer.
//
round_pause( delay )
{
	if ( !IsDefined( delay ) )
	{
		delay = 30;
	}

	level.countdown_hud = create_counter_hud();
	level.countdown_hud SetValue( delay );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 1;
	level.countdown_hud FadeOverTime( 2.0 );
	wait( 2.0 );

	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud FadeOverTime( 3.0 );
	wait(3);

	while (delay >= 1)
	{
		wait (1);
		delay--;
		level.countdown_hud SetValue( delay );
	}

	// Zero!  Play end sound
	players = GET_PLAYERS();
	for (i=0; i<players.size; i++ )
	{
		players[i] playlocalsound( "zmb_perks_packa_ready" );
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );

	level.countdown_hud destroy_hud();
}


//	Zombie spawning
//
round_start()
{
/#	PrintLn( "ZM >> round_start start" );	#/

	if ( IsDefined(level.round_prestart_func) )
	{
		[[ level.round_prestart_func ]]();
	}
	else
	{
		wait( 2 );
	}

	level.zombie_health = level.zombie_vars["zombie_health_start"]; 

	// so players get init'ed with grenades
/*	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
	{
		players[i] giveweapon( players[i] get_player_lethal_grenade() );	
		players[i] setweaponammoclip( players[i] get_player_lethal_grenade(), 0);
		players[i] SetClientAmmoCounterHide( 0 );
		players[i] SetClientMiniScoreboardHide( 0 );
	}*/

	if( GetDvarInt( "scr_writeconfigstrings" ) == 1 )
	{
		wait(5);
		ExitLevel();
		return;
	}
//	if( isDefined(level.chests) && isDefined(level.chest_index) )
//	{
//		Objective_Add( 0, "active", "Mystery Box", level.chests[level.chest_index].chest_lid.origin, "minimap_icon_mystery_box" );
//	}

	if ( level.zombie_vars["game_start_delay"] > 0 )
	{
		round_pause( level.zombie_vars["game_start_delay"] );
	}

	flag_set( "begin_spawning" );

	if( !isdefined(level.noChalk) || level.noChalk==false )
	{
		level.chalk_hud1 = create_chalk_hud();
		level.chalk_hud2 = create_chalk_hud( 64 );
	}

	if( !isDefined(level.round_spawn_func) )
	{
		level.round_spawn_func = ::round_spawning;
	}
/#
	if (GetDvarInt( "zombie_rise_test") )
	{
		level.round_spawn_func = ::round_spawning_test;		// FOR TESTING, one zombie at a time, no round advancement
	}
#/

	if ( !isDefined(level.round_wait_func) )
	{
		level.round_wait_func = ::round_wait;
	}

	if ( !IsDefined(level.round_think_func) )
	{
		level.round_think_func = ::round_think;
	}

	level thread [[ level.round_think_func ]]();
}


//
//
create_chalk_hud( x )
{
	if( !IsDefined( x ) )
	{
		x = 0;
	}

	hud = create_simple_hud();
	hud.alignX = "left"; 
	hud.alignY = "bottom";
	hud.horzAlign = "user_left"; 
	hud.vertAlign = "user_bottom";
	hud.color = ( 0.21, 0, 0 );
	hud.x = x; 
	hud.y = -4; 
	hud.alpha = 0;
	hud.fontscale = 4.2; //32.0;

	hud SetShader( "hud_chalk_1", 64, 64 );

	return hud;
}


//
//
destroy_chalk_hud()
{
	if( isDefined( level.chalk_hud1 ) )
	{
		level.chalk_hud1 Destroy();
		level.chalk_hud1 = undefined;
	}

	if( isDefined( level.chalk_hud2 ) )
	{
		level.chalk_hud2 Destroy();
		level.chalk_hud2 = undefined;
	}
}


//
// Let's the players know that you need power to open these
play_door_dialog()
{
	level endon( "power_on" );
	self endon ("warning_dialog");
	timer = 0;

	while(1)
	{
		wait(0.05);
		players = GET_PLAYERS();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer =0;
				continue;
			}
			while(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer++;
			}
			if(dist > 70*70 && timer >= 3)
			{
				self playsound("door_deny");
				
				players[i] maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "door_deny" );	
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}

wait_until_first_player()
{
	players = GET_PLAYERS();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
}

//
//	Set the current round number hud display
chalk_one_up()
{
	level endon("end_game");
	if( isdefined(level.noChalk) && level.noChalk==true )
	{
		return;
	}
	
	huds = [];
	huds[0] = level.chalk_hud1;
	huds[1] = level.chalk_hud2;

	// Hud1 shader
	if( level.round_number >= 1 && level.round_number <= 5 )
	{
		huds[0] SetShader( "hud_chalk_" + level.round_number, 64, 64 );
	}
	else if ( level.round_number >= 5 && level.round_number <= 10 )
	{
		huds[0] SetShader( "hud_chalk_5", 64, 64 );
	}

	// Hud2 shader
	if( level.round_number > 5 && level.round_number <= 10 )
	{
		huds[1] SetShader( "hud_chalk_" + ( level.round_number - 5 ), 64, 64 );
	}

	// Display value
	if ( IsDefined( level.chalk_override ) )
	{
		huds[0] SetText( level.chalk_override );
		huds[1] SetText( " " );
	}
	else if( level.round_number <= 5 )
	{
		huds[1] SetText( " " );
	}
	else if( level.round_number > 10 )
	{
		huds[0].fontscale = 32;
		huds[0] SetValue( level.round_number );
		huds[1] SetText( " " );
	}

	if(!IsDefined(level.doground_nomusic))
	{
		level.doground_nomusic = 0;
	}
	if( level.first_round )
	{
		intro = true;
		if( isdefined( level._custom_intro_vox ) )
		{
			level thread [[level._custom_intro_vox]]();
		}
		else
		{
			level thread play_level_start_vox_delayed();
		};
	}
	else
	{
		intro = false;
	}
	
	//Round Number Specific Lines
	if( level.round_number == 5 || level.round_number == 10 || level.round_number == 20 || level.round_number == 35 || level.round_number == 50 )
	{
	    players = GET_PLAYERS();
	    rand = RandomIntRange(0,players.size);
	    players[rand] thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "round_" + level.round_number );
	}

	round = undefined;	
	if( intro )
	{
		// Create "ROUND" hud text
		round = create_simple_hud();
		round.alignX = "center"; 
		round.alignY = "bottom";
		round.horzAlign = "user_center"; 
		round.vertAlign = "user_bottom";
		round.fontscale = 4.2; //16;
		round.color = ( 1, 1, 1 );
		round.x = 0;
		round.y = -265;
		round.alpha = 0;
		round SetText( &"ZOMBIE_ROUND" );

//		huds[0] FadeOverTime( 0.05 );
		huds[0].color = ( 1, 1, 1 );
		huds[0].alpha = 0;
		huds[0].horzAlign = "user_center";
		huds[0].x = -5;
		huds[0].y = -200;

		huds[1] SetText( " " );

		// Fade in white
		round FadeOverTime( 1 );
		round.alpha = 1;

		huds[0] FadeOverTime( 1 );
		huds[0].alpha = 1;

		wait( 1 );

		// Fade to red
		round FadeOverTime( 2 );
		round.color = ( 0.21, 0, 0 );

		huds[0] FadeOverTime( 2 );
		huds[0].color = ( 0.21, 0, 0 );
		wait(2);
	}
	else
	{
		for ( i=0; i<huds.size; i++ )
		{
			huds[i] FadeOverTime( 0.5 );
			huds[i].alpha = 0;
		}
		wait( 0.5 );
	}

// 	if( (level.round_number <= 5 || level.round_number >= 11) && IsDefined( level.chalk_hud2 ) )
// 	{
// 		huds[1] = undefined;
// 	}
// 	
	for ( i=0; i<huds.size; i++ )
	{
		huds[i] FadeOverTime( 2 );
		huds[i].alpha = 1;
	}

	if( intro )
	{
		wait( 3 );

		if( IsDefined( round ) )
		{
			round FadeOverTime( 1 );
			round.alpha = 0;
		}

		wait( 0.25 );

		level notify( "intro_hud_done" );
		huds[0] MoveOverTime( 1.75 );
		huds[0].horzAlign = "user_left";
		//		huds[0].x = 0;
		huds[0].y = -4;
		wait( 2 );

		round destroy_hud();
	}
	else
	{
		for ( i=0; i<huds.size; i++ )
		{
			huds[i].color = ( 1, 1, 1 );
		}
	}

	// Okay now wait just a bit to let the number set in
	if ( !intro )
	{
		wait( 2 ); 

		for ( i=0; i<huds.size; i++ )
		{
			huds[i] FadeOverTime( 1 );
			huds[i].color = ( 0.21, 0, 0 );
		}
	}
	
	ReportMTU(level.round_number);	// In network debug instrumented builds, causes network spike report to generate.

	// Remove any override set since we're done with it
	if ( IsDefined( level.chalk_override ) )
	{
		level.chalk_override = undefined;
	}
}


//	Flash the round display at the end of the round
//
chalk_round_over()
{
	if( isdefined(level.noChalk) && level.noChalk==true )
	{
		return;
	}
	
	huds = [];
	huds[huds.size] = level.chalk_hud1;
	huds[huds.size] = level.chalk_hud2;

	if( level.round_number <= 5 || level.round_number > 10 )
	{
		level.chalk_hud2 SetText( " " );
	}

	time = level.zombie_vars["zombie_between_round_time"];
	if ( time > 3 )
	{
		time = time - 2;	// add this deduction back in at the bottom
	}

	for( i = 0; i < huds.size; i++ )
	{
		if( IsDefined( huds[i] ) )
		{
			huds[i] FadeOverTime( time * 0.25 );
			huds[i].color = ( 1, 1, 1 );
		}
	}

	// Pulse
	fade_time = 0.5;
	steps =  ( time * 0.5 ) / fade_time;
	for( q = 0; q < steps; q++ )
	{
		for( i = 0; i < huds.size; i++ )
		{
			if( !IsDefined( huds[i] ) )
			{
				continue;
			}

			huds[i] FadeOverTime( fade_time );
			huds[i].alpha = 0;
		}

		wait( fade_time );

		for( i = 0; i < huds.size; i++ )
		{
			if( !IsDefined( huds[i] ) )
			{
				continue;
			}

			huds[i] FadeOverTime( fade_time );
			huds[i].alpha = 1;		
		}

		wait( fade_time );
	}

	for( i = 0; i < huds.size; i++ )
	{
		if( !IsDefined( huds[i] ) )
		{
			continue;
		}

		huds[i] FadeOverTime( time * 0.25 );
		//		huds[i].color = ( 0.8, 0, 0 );
		huds[i].color = ( 0.21, 0, 0 );
		huds[i].alpha = 0;
	}

	wait ( 2.0 );
}

round_think()
{
/#	PrintLn( "ZM >> round_think start" );	#/

	// Wait for blackscreen to end if in use
	if ( IsDefined( level.initial_round_wait_func ))
		[[level.initial_round_wait_func]]();
	
	for( ;; )
	{
		//////////////////////////////////////////
		//designed by prod DT#36173
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
			maxreward = 500;
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		//////////////////////////////////////////

		level.pro_tips_start_time = GetTime();
		level.zombie_last_run_time = GetTime();	// Resets the last time a zombie ran
	
       level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_start" );
		chalk_one_up();
		//		round_text( &"ZOMBIE_ROUND_BEGIN" );

		maps\mp\zombies\_zm_powerups::powerup_round_start();

		players = GET_PLAYERS();
		array_thread( players, maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset );

		level thread award_grenades_for_survivors();

		bbPrint( "zombie_rounds: round %d player_count %d", level.round_number, players.size );

	/#	PrintLn( "ZM >> round_think, round="+level.round_number+", player_count=" + players.size );		#/

		level.round_start_time = GetTime();
		level thread [[level.round_spawn_func]]();

		level notify( "start_of_round" );

		[[level.round_wait_func]]();

		level.first_round = false;
		level notify( "end_of_round" );
		
		level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_end" );
		
		UploadStats();

		if ( 1 != players.size )
		{
			level thread spectators_respawn();
			//level thread last_stand_revive();
		}

		//		round_text( &"ZOMBIE_ROUND_END" );
		level chalk_round_over();

		// here's the difficulty increase over time area
		timer = level.zombie_vars["zombie_spawn_delay"];
		if ( timer > 0.08 )
		{
			level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
		}
		else if ( timer < 0.08 )
		{
			level.zombie_vars["zombie_spawn_delay"] = 0.08;
		}

		// 
		// Increase the zombie move speed
		level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];

// 		iPrintlnBold( "End of Round " + level.round_number );
// 		for ( i=0; i<level.team_pool.size; i++ )
// 		{
// 			iPrintlnBold( "Team Pool "+(i+1)+" score: ", level.team_pool[i].score_total );
// 		}
// 
// 		players = GET_PLAYERS();
// 		for ( p=0; p<players.size; p++ )
// 		{
// 			iPrintlnBold( "Total Player "+(p+1)+" score : "+ players[p].score_total );
// 		}

		level.round_number++;

		level notify( "between_round_over" );
	}
}


award_grenades_for_survivors()
{
	players = GET_PLAYERS();

	for (i = 0; i < players.size; i++)
	{
		if (!players[i].is_zombie)
		{
			lethal_grenade = players[i] get_player_lethal_grenade();
			if( !players[i] HasWeapon( lethal_grenade ) )
			{
				players[i] GiveWeapon( lethal_grenade );	
				players[i] SetWeaponAmmoClip( lethal_grenade, 0 );
			}

			if ( players[i] GetFractionMaxAmmo( lethal_grenade ) < .25 )
			{
				players[i] SetWeaponAmmoClip( lethal_grenade, 2 );
			}
			else if (players[i] GetFractionMaxAmmo( lethal_grenade ) < .5 )
			{
				players[i] SetWeaponAmmoClip( lethal_grenade, 3 );
			}
			else
			{
				players[i] SetWeaponAmmoClip( lethal_grenade, 4 );
			}
		}
	}
}

ai_calculate_health( round_number )
{
	level.zombie_health = level.zombie_vars["zombie_health_start"]; 
	for ( i=2; i<=round_number; i++ )
	{
		// After round 10, get exponentially harder
		if( i >= 10 )
		{
			level.zombie_health += Int( level.zombie_health * level.zombie_vars["zombie_health_increase_multiplier"] ); 
		}
		else
		{
			level.zombie_health = Int( level.zombie_health + level.zombie_vars["zombie_health_increase"] ); 
		}
	}
}

/#
round_spawn_failsafe_debug()
{
	level notify( "failsafe_debug_stop" );
	level endon( "failsafe_debug_stop" );

	start = GetTime();
	level.chunk_time = 0;

	while ( 1 )
	{
		level.failsafe_time = GetTime() - start;

		if ( isdefined( self.lastchunk_destroy_time ) )
		{
			level.chunk_time = GetTime() - self.lastchunk_destroy_time;
		}
		wait_network_frame();
	}
}
#/

//put the conditions in here which should
//cause the failsafe to reset
round_spawn_failsafe()
{
	self endon("death");//guy just died

	//////////////////////////////////////////////////////////////
	//FAILSAFE "hack shit"  DT#33203
	//////////////////////////////////////////////////////////////
	prevorigin = self.origin;
	while(1)
	{
		if( !level.zombie_vars["zombie_use_failsafe"] )
		{
			return;
		}

		if ( is_true( self.ignore_round_spawn_failsafe ) )
		{
			return;
		}
		
		wait( 30 );

		if( !self.has_legs )
		{
			wait( 10.0 );
		}

		//inert zombies can ignore this
		if ( is_true( self.is_inert ) )
		{
			continue;
		}

		//if i've torn a board down in the last 5 seconds, just 
		//wait 30 again.
		if ( isDefined(self.lastchunk_destroy_time) )
		{
			if ( (GetTime() - self.lastchunk_destroy_time) < 8000 )
				continue; 
		}

		//fell out of world
		if ( self.origin[2] < level.zombie_vars["below_world_check"] )
		{
			if(is_true(level.put_timed_out_zombies_back_in_queue ) && !flag("dog_round") && !is_true( self.isscreecher ) )
			{
				level.zombie_total++;	
			}			
			
			/#
			if ( GetDvarInt( "scr_zombie_failsafe_debug" ) != 0 )
			{
				maps\mp\gametypes\_dev::showOneSpawnPoint( self, ( 1, 0, 0 ), "zombie_failsafe_debug_flush", undefined, "FELL OUT" );
			}
			#/
			
			self dodamage( self.health + 100, (0,0,0) );				
			break;
		}

		//hasnt moved 24 inches in 30 seconds?	
		if ( DistanceSquared( self.origin, prevorigin ) < 576 ) 
		{
			
			//add this zombie back into the spawner queue to be re-spawned
			if(is_true(level.put_timed_out_zombies_back_in_queue ) && !flag("dog_round"))
			{
				//only if they have crawled thru a window and then timed out
				if(!self.ignoreall && !is_true(self.nuked) && !is_true(self.marked_for_death) && !is_true( self.isscreecher ) && is_true( self.has_legs ))
				{
					level.zombie_total++;	
				}
			}
			
			//add this to the stats even tho he really didn't 'die' 
			level.zombies_timeout_playspace++;
			
			/#
			if ( GetDvarInt( "scr_zombie_failsafe_debug" ) != 0 )
			{
				maps\mp\gametypes\_dev::showOneSpawnPoint( self, ( 1, 0, 0 ), "zombie_failsafe_debug_flush", undefined, "STUCK" );
			}
			#/
			
			// DEBUG HACK
			self dodamage( self.health + 100, (0,0,0) );
			break;
		}

		prevorigin = self.origin;
	}
	//////////////////////////////////////////////////////////////
	//END OF FAILSAFE "hack shit"
	//////////////////////////////////////////////////////////////
}

// Waits for the time and the ai to die
round_wait()
{
/#
    if (GetDvarInt( "zombie_rise_test") )
	{
		level waittill("forever"); // TESTING: don't advance rounds
	}
#/

/#
	if ( GetDvarInt( "zombie_cheat" ) == 2 || GetDvarInt( "zombie_cheat" ) >= 4 )
	{
		level waittill("forever");
	}
#/

	wait( 1 );

	if( flag("dog_round" ) )
	{
		wait(7);
		while( level.dog_intermission )
		{
			wait(0.5);
		}
	}
	else
	{
		while( get_enemy_count() > 0 || level.zombie_total > 0 || level.intermission )
		{
			if( flag( "end_round_wait" ) )
			{
				return;
			}
			wait( 1.0 );
		}
	}
}


zombify_player()
{
	self maps\mp\zombies\_zm_score::player_died_penalty(); 

	bbPrint( "zombie_playerdeaths: round %d playername %s deathtype died x %f y %f z %f", level.round_number, self.name, self.origin );

	if ( IsDefined( level.deathcard_spawn_func ) )
	{
		self [[level.deathcard_spawn_func]]();
	}

	if( !IsDefined( level.zombie_vars["zombify_player"] ) || !level.zombie_vars["zombify_player"] )
	{
		self thread spawnSpectator(); 
		return; 
	}

	self.ignoreme = true; 
	self.is_zombie = true; 
	self.zombification_time = GetTime(); 

	self.team = "axis"; 
	self notify( "zombified" ); 

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger Delete(); 
	}
	self.revivetrigger = undefined; 

	self setMoveSpeedScale( 0.3 ); 
	self reviveplayer(); 

	self TakeAllWeapons(); 
	//self starttanning(); 
	self GiveWeapon( "zombie_melee", 0 ); 
	self SwitchToWeapon( "zombie_melee" ); 
	self DisableWeaponCycling(); 
	self DisableOffhandWeapons(); 

	setClientSysState( "zombify", 1, self ); 	// Zombie grain goooo

	self thread maps\mp\zombies\_zm_spawner::zombie_eye_glow(); 

	self thread playerzombie_player_damage(); 
	self thread playerzombie_soundboard(); 
}

playerzombie_player_damage()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self thread playerzombie_infinite_health();  // manually keep regular health up
	self.zombiehealth = level.zombie_health; 

	// enable PVP damage on this guy
	// self EnablePvPDamage(); 

	while( 1 )
	{
		self waittill( "damage", amount, attacker, directionVec, point, type ); 

		if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
		{
			wait( 0.05 ); 
			continue; 
		}

		self.zombiehealth -= amount; 

		if( self.zombiehealth <= 0 )
		{
			// "down" the zombie
			self thread playerzombie_downed_state(); 
			self waittill( "playerzombie_downed_state_done" ); 
			self.zombiehealth = level.zombie_health; 
		}
	}
}

playerzombie_downed_state()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	downTime = 15; 

	startTime = GetTime(); 
	endTime = startTime +( downTime * 1000 ); 

	self thread playerzombie_downed_hud(); 

	self.playerzombie_soundboard_disable = true; 
	self thread maps\mp\zombies\_zm_spawner::zombie_eye_glow_stop(); 
	self DisableWeapons(); 
	self AllowStand( false ); 
	self AllowCrouch( false ); 
	self AllowProne( true ); 

	while( GetTime() < endTime )
	{
		wait( 0.05 ); 
	}

	self.playerzombie_soundboard_disable = false; 
	self thread maps\mp\zombies\_zm_spawner::zombie_eye_glow(); 
	self EnableWeapons(); 
	self AllowStand( true ); 
	self AllowCrouch( false ); 
	self AllowProne( false ); 

	self notify( "playerzombie_downed_state_done" ); 
}

playerzombie_downed_hud()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	text = NewClientHudElem( self ); 
	text.alignX = "center"; 
	text.alignY = "middle"; 
	text.horzAlign = "user_center"; 
	text.vertAlign = "user_bottom"; 
	text.foreground = true; 
	text.font = "default"; 
	text.fontScale = 1.8; 
	text.alpha = 0; 
	text.color = ( 1.0, 1.0, 1.0 ); 
	text SetText( &"ZOMBIE_PLAYERZOMBIE_DOWNED" ); 

	text.y = -113; 	
	if( IsSplitScreen() )
	{
		text.y = -137; 
	}

	text FadeOverTime( 0.1 ); 
	text.alpha = 1; 

	self waittill( "playerzombie_downed_state_done" ); 

	text FadeOverTime( 0.1 ); 
	text.alpha = 0; 
}

playerzombie_infinite_health()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	bighealth = 100000; 

	while( 1 )
	{
		if( self.health < bighealth )
		{
			self.health = bighealth; 
		}

		wait( 0.1 ); 
	}
}

playerzombie_soundboard()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self.playerzombie_soundboard_disable = false; 

	self.buttonpressed_use = false; 
	self.buttonpressed_attack = false; 
	self.buttonpressed_ads = false; 

	self.useSound_waitTime = 3 * 1000;  // milliseconds
	self.useSound_nextTime = GetTime(); 
	useSound = "playerzombie_usebutton_sound"; 

	self.attackSound_waitTime = 3 * 1000; 
	self.attackSound_nextTime = GetTime(); 
	attackSound = "playerzombie_attackbutton_sound"; 

	self.adsSound_waitTime = 3 * 1000; 
	self.adsSound_nextTime = GetTime(); 
	adsSound = "playerzombie_adsbutton_sound"; 

	self.inputSound_nextTime = GetTime();  // don't want to be able to do all sounds at once

	while( 1 )
	{
		if( self.playerzombie_soundboard_disable )
		{
			wait( 0.05 ); 
			continue; 
		}

		if( self UseButtonPressed() )
		{
			if( self can_do_input( "use" ) )
			{
				self thread playerzombie_play_sound( useSound ); 
				self thread playerzombie_waitfor_buttonrelease( "use" ); 
				self.useSound_nextTime = GetTime() + self.useSound_waitTime; 
			}
		}
		else if( self AttackButtonPressed() )
		{
			if( self can_do_input( "attack" ) )
			{
				self thread playerzombie_play_sound( attackSound ); 
				self thread playerzombie_waitfor_buttonrelease( "attack" ); 
				self.attackSound_nextTime = GetTime() + self.attackSound_waitTime; 
			}
		}
		else if( self AdsButtonPressed() )
		{
			if( self can_do_input( "ads" ) )
			{
				self thread playerzombie_play_sound( adsSound ); 
				self thread playerzombie_waitfor_buttonrelease( "ads" ); 
				self.adsSound_nextTime = GetTime() + self.adsSound_waitTime; 
			}
		}

		wait( 0.05 ); 
	}
}

can_do_input( inputType )
{
	if( GetTime() < self.inputSound_nextTime )
	{
		return false; 
	}

	canDo = false; 

	switch( inputType )
	{
	case "use":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_use )
		{
			canDo = true; 
		}
		break; 

	case "attack":
		if( GetTime() >= self.attackSound_nextTime && !self.buttonpressed_attack )
		{
			canDo = true; 
		}
		break; 

	case "ads":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_ads )
		{
			canDo = true; 
		}
		break; 

	default:
		ASSERTMSG( "can_do_input(): didn't recognize inputType of " + inputType ); 
		break; 
	}

	return canDo; 
}

playerzombie_play_sound( alias )
{
	self play_sound_on_ent( alias ); 
}

playerzombie_waitfor_buttonrelease( inputType )
{
	if( inputType != "use" && inputType != "attack" && inputType != "ads" )
	{
		ASSERTMSG( "playerzombie_waitfor_buttonrelease(): inputType of " + inputType + " is not recognized." ); 
		return; 
	}

	notifyString = "waitfor_buttonrelease_" + inputType; 
	self notify( notifyString ); 
	self endon( notifyString ); 

	if( inputType == "use" )
	{
		self.buttonpressed_use = true; 
		while( self UseButtonPressed() )
		{
			wait( 0.05 ); 
		}
		self.buttonpressed_use = false; 
	}

	else if( inputType == "attack" )
	{
		self.buttonpressed_attack = true; 
		while( self AttackButtonPressed() )
		{
			wait( 0.05 ); 
		}
		self.buttonpressed_attack = false; 
	}

	else if( inputType == "ads" )
	{
		self.buttonpressed_ads = true; 
		while( self AdsButtonPressed() )
		{
			wait( 0.05 ); 
		}
		self.buttonpressed_ads = false; 
	}
}

remove_ignore_attacker()
{
	self notify( "new_ignore_attacker" );
	self endon( "new_ignore_attacker" );
	self endon( "disconnect" );
	
	if( !isDefined( level.ignore_enemy_timer ) )
	{
		level.ignore_enemy_timer = 0.4;
	}
	
	wait( level.ignore_enemy_timer );
	
	self.ignoreAttacker = undefined;
}

player_shield_facing_attacker( vDir, limit )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );

	toFaceeVec = -vDir;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > limit ); // more or less in front
}

player_damage_override_cheat( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	return 0;
}


//
//	player_damage_override
//		MUST return the value of the damage override
//
// MM (08/10/09) - Removed calls to PlayerDamageWrapper because it's always called in 
//		Callback_PlayerDamage now.  We just need to return the damage.
//
player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	//check to see if we are in a game module that wants to do something with PvP damage
	if(isDefined(level._game_module_player_damage_callback))
	{
		self [[level._game_module_player_damage_callback]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
	
	iDamage = self check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	if ( !iDamage )
	{
		return 0;
	}
	
	// WW (8/14/10) - If a player is hit by the crossbow bolt then set them as the holder of the monkey shot
	if( sWeapon == "crossbow_explosive_upgraded_zm" && sMeansOfDeath == "MOD_IMPACT" )
	{
		level.monkey_bolt_holder = self;
	}

	// WW (8/20/10) - Sledgehammer fix for Issue 43492. This should stop the player from taking any damage while in laststand
	if( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		return 0;
	}
	
	if ( isDefined( eInflictor ) )
	{
		if ( is_true( eInflictor.water_damage ) )
		{
			return 0;
		}
	}

	if ( IsDefined(self.hasRiotShield) && self.hasRiotShield && IsDefined(vDir) )
	{
		if ( IsDefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped  )
		{
			if ( self player_shield_facing_attacker(vDir, 0.2) && isdefined(self.player_shield_apply_damage))
			{
				self [[self.player_shield_apply_damage]](100, false);
				return 0;
			}
		}
		else if ( !IsDefined( self.riotshieldEntity ))
		{
			// shield on back - half damage to player, half to shield
			if ( !self player_shield_facing_attacker(vDir, -0.2) && isdefined(self.player_shield_apply_damage))
			{
				self [[self.player_shield_apply_damage]](100, false);
				return 0;
			}
		}
	}
	
	if ( isDefined( eAttacker ) )
	{
		
		if( isDefined( self.ignoreAttacker ) && self.ignoreAttacker == eAttacker ) 
		{
			return 0;
		}
		
		// AR (5/30/12) - Stop Zombie players from damaging other Zombie players
		if ( is_true( self.is_zombie ) && is_true( eAttacker.is_zombie ) )
		{
			return 0;
		}
		
		if( (isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie) || level.mutators["mutator_friendlyFire"] )
		{
			self.ignoreAttacker = eAttacker;
			self thread remove_ignore_attacker();

			if ( isdefined( eAttacker.custom_damage_func ) )
			{
				iDamage = eAttacker [[ eAttacker.custom_damage_func ]]( self );
			}
			else if ( isdefined( eAttacker.meleeDamage ) )
			{
				iDamage = eAttacker.meleeDamage;
			}
			else
			{
				iDamage = 50;		// 45
			}
		}
		
		eAttacker notify( "hit_player" ); 

		if( sMeansOfDeath != "MOD_FALLING" )
		{
			self thread playSwipeSound( sMeansOfDeath, eattacker );
		    if(RandomIntRange(0,1) == 0 )
		    {
		        self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "hitmed" );
		    }
		    else
		    {
		        self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "hitlrg" );
		    }
		}
	}
	finalDamage = iDamage;
	
	// claymores and freezegun shatters, like bouncing betties, harm no players
	if ( is_placeable_mine( sWeapon ) || sWeapon == "freezegun_zm" || sWeapon == "freezegun_upgraded_zm" )
	{
		return 0;
	}

	if ( isDefined( self.player_damage_override ) )
	{
		self thread [[ self.player_damage_override ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}

	if( sMeansOfDeath == "MOD_FALLING" )
	{
		if ( self HasPerk( "specialty_flakjacket" ) && isdefined( self.divetoprone ) && self.divetoprone == 1 )
		{
			if ( IsDefined( level.zombiemode_divetonuke_perk_func ) )
			{
				[[ level.zombiemode_divetonuke_perk_func ]]( self, self.origin );
			}

			return 0;
		}
	}

	if( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		// check for reduced damage from flak jacket perk
		if ( self HasPerk( "specialty_flakjacket" ) )
		{
			return 0;
		}

		if( self.health > 75 )
		{
			// MM (08/10/09)
			return 75;
		}
	}
	
	if( iDamage < self.health )
	{
		if ( IsDefined( eAttacker ) )
		{
			eAttacker.sound_damage_player = self;
			
			if( IsDefined( eAttacker.has_legs ) && !eAttacker.has_legs )
			{
			    self maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "crawl_hit" );
			}
			else if( IsDefined( eAttacker.animname ) && ( eAttacker.animname == "monkey_zombie" ) )
			{
			    self maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "monkey_hit" );
			}
		}
		
		// MM (08/10/09)
		return finalDamage;
	}
		
	if( level.intermission )
	{
		level waittill( "forever" );
	}
	
	// AR (3/7/12) - Keep track of which player killed player in Zombify modes like Cleansed / Turned
	if ( is_true( level.is_zombie_level ) )
	{
		if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) && eAttacker.team != self.team && ( ( !is_true( self.laststand ) && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() ) || !IsDefined( self.last_player_attacker ) ) )
		{
			self.last_player_attacker = eAttacker;
		}
	}

	players = GET_PLAYERS();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self || players[i].is_zombie || players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() || players[i].sessionstate == "spectator" )
		{
			count++;
		}
	}
	if( count < players.size || (isDefined(level._game_module_game_end_check) && ![[level._game_module_game_end_check]]()) )
	{
		// MM (08/10/09)
		return finalDamage;
	}

	if ( players.size == 1 && flag( "solo_game" ) )
	{
		if ( self.lives == 0 )
		{
			self.intermission = true;
		}
	}
	
	// WW (01/05/11): When a two players enter a system link game and the client drops the host will be treated as if it was a solo game
	// when it wasn't. This led to SREs about undefined and int being compared on death (self.lives was never defined on the host). While
	// adding the check for the solo game flag we found that we would have to create a complex OR inside of the if check below. By breaking
	// the conditions out in to their own variables we keep the complexity without making it look like a mess.
	solo_death = ( players.size == 1 && flag( "solo_game" ) && self.lives == 0 ); // there is only one player AND the flag is set AND self.lives equals 0
	non_solo_death = ( ( count > 1 || ( players.size == 1 && !flag( "solo_game" ) ) ) /*&& !level.is_zombie_level*/ ); // the player size is greater than one OR ( players.size equals 1 AND solo flag isn't set ) AND not a zombify game level
	if ( solo_death || non_solo_death ) // if only one player on their last life or any game that started with more than one player
	{
		self thread maps\mp\zombies\_zm_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
		if ( isdefined(level.custom_player_fake_death) )
			[[level.custom_player_fake_death]](vDir);
		else
			self player_fake_death();
	}

	if( count == players.size && !is_true( level.no_end_game_check ) )
	{
		if ( players.size == 1 && flag( "solo_game" ))
		{
			if ( self.lives == 0 ) // && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand()
			{
				
				level notify("pre_end_game");
				wait_network_frame();
				
				level notify( "end_game" );
			}
			else
			{
				self thread wait_and_revive();
				return finalDamage;
			}
		}
		else
		{
			level notify("pre_end_game");
			wait_network_frame();
			
			level notify( "end_game" );
		}
		return 0;	// MM (09/16/09) Need to return something
	}
	else
	{
		// MM (08/10/09)
		
		surface = "flesh";
		//self finishPlayerDamage( eInflictor, eAttacker, finalDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, surface );
		
		return finalDamage;
	}
}


check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( !isdefined( level.player_damage_callbacks ) )
	{
		return iDamage;
	}

	for ( i = 0; i < level.player_damage_callbacks.size; i++ )
	{
		newDamage = self [[ level.player_damage_callbacks[i] ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		if ( -1 != newDamage )
		{
			return newDamage;
		}
	}

	return iDamage;
}


register_player_damage_callback( func )
{
	if ( !isdefined( level.player_damage_callbacks ) )
	{
		level.player_damage_callbacks = [];
	}

	level.player_damage_callbacks[level.player_damage_callbacks.size] = func;
}


wait_and_revive()
{
	flag_set( "wait_and_revive" );

	if ( isdefined( self.waiting_to_revive ) && self.waiting_to_revive == true )
	{
		return;
	}

	self.waiting_to_revive = true;
	if ( isdefined( level.exit_level_func ) )
	{
		self thread [[ level.exit_level_func ]]();
	}
	else
	{
		self thread default_exit_level();
	}

	// wait to actually go into last stand before reviving
	while ( 1 )
	{
		if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			break;
		}

		wait_network_frame();
	}

	solo_revive_time = 10.0;

	self.revive_hud setText( &"ZOMBIE_REVIVING_SOLO", self );
	self maps\mp\zombies\_zm_laststand::revive_hud_show_n_fade( solo_revive_time );

	flag_wait_or_timeout("instant_revive", solo_revive_time);

	flag_clear( "wait_and_revive" );

	self maps\mp\zombies\_zm_laststand::auto_revive( self );
	self.lives--;
	self.waiting_to_revive = false;
}

//
//		MUST return the value of the damage override
//
actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime )
{
	// WW (8/14/10) - define the owner of the monkey shot
	if( weapon == "crossbow_explosive_upgraded_zm" && meansofdeath == "MOD_IMPACT" ) 
	{
		level.monkey_bolt_holder = self;
	}

	// skip conditions
	if( !isdefined( self) || !isdefined( attacker ) )
		return damage;

	if ( isdefined( attacker.animname ) && attacker.animname == "quad_zombie" )
	{
		if ( isdefined( self.animname ) && self.animname == "quad_zombie" )
		{
			return 0;
		}
	}
	
	if ( !isplayer( attacker ) && isdefined( self.non_attacker_func ) )
	{
		return self [[ self.non_attacker_func ]]( damage, weapon );
	}
	if ( !isplayer( attacker ) && !isplayer( self ) )
		return damage;
	if( !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;

	

	//println( "*********HIT :  Zombie health: "+self.health+",  dam:"+damage+", weapon:"+ weapon );

	old_damage = damage;
	final_damage = damage;

	if ( IsDefined( self.actor_damage_func ) )
	{
		final_damage = [[ self.actor_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime );
	}

	// debug
/#
		if ( GetDvarInt( "scr_perkdebug") )
			println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
#/
	
	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;

	if( !isDefined( self.damage_assists ) )
	{
		self.damage_assists = [];
	}

	if ( !isdefined( self.damage_assists[attacker.entity_num] ) )
	{
		self.damage_assists[attacker.entity_num] = attacker;
	}

	if( level.mutators[ "mutator_headshotsOnly" ] && !is_headshot( weapon, sHitLoc, meansofdeath ) )
	{
		return 0;
	}

	if( level.mutators[ "mutator_powerShot" ] )
	{
		final_damage = int( final_damage * 1.5 );
	}

	if ( is_true( self.in_water ) )
	{
		if ( int( final_damage ) >= self.health )
		{
			self.water_damage = true;
		}
	}
	
	//println( "checkhit = "+ weapon );
	//stats tracking
	attacker thread maps\mp\gametypes\_weapons::checkHit( weapon );

	// return unchanged damage
	//iPrintln( final_damage );
	return int( final_damage );
}


actor_damage_override_wrapper( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime )
{
	damage_override = self actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime );

	self finishActorDamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime );
}

is_headshot( sWeapon, sHitLoc, sMeansOfDeath )
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_BAYONET" && sMeansOfDeath != "MOD_IMPACT"; //CoD5: MGs need to cause headshots as well. && !isMG( sWeapon );
}

actor_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime)
{
	if ( game["state"] == "postgame" )
		return;	
	
	if( isai(attacker) && isDefined( attacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( attacker.script_owner.team != self.aiteam )
			attacker = attacker.script_owner;
	}
		
	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;
		
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		multiplier = 1;
		if( is_headshot( sWeapon, sHitLoc, sMeansOfDeath ) )
		{
			multiplier = 1.5;
		}

		type = undefined;

		//MM (3/18/10) no animname check
		if ( IsDefined(self.animname) )
		{
			switch( self.animname )
			{
			case "quad_zombie":
				type = "quadkill";
				break;
			case "ape_zombie":
				type = "apekill";
				break;
			case "zombie":
				type = "zombiekill";
				break;
			case "zombie_dog":
				type = "dogkill";
				break;
			}
		}
		//if( isDefined( type ) )
		//{
		//	value = maps\_zombiemode_rank::getScoreInfoValue( type );
		//	self process_assist( type, attacker );

		//	value = int( value * multiplier );
		//	attacker thread maps\_zombiemode_rank::giveRankXP( type, value, false, false );
		//}
	}
	
	if(is_true(self.is_ziplining))
	{
		self.deathanim = undefined;
	}

	if ( IsDefined( self.actor_killed_override ) )
	{
		self [[ self.actor_killed_override ]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
	}

}


process_assist( type, attacker )
{
	if ( isDefined( self.damage_assists ) )
	{
		for ( j = 0; j < self.damage_assists.size; j++ )
		{
			player = self.damage_assists[j];
			
			if ( !isDefined( player ) )
				continue;
			
			if ( player == attacker )
				continue;
			
			//assist_xp = maps\_zombiemode_rank::getScoreInfoValue( type + "_assist" );
			//player thread maps\_zombiemode_rank::giveRankXP( type + "_assist", assist_xp );
		}
		self.damage_assists = undefined;
	}
}

round_end_monitor()
{
	while(1)
	{
		level waittill( "end_of_round" );

		maps\mp\_demo::bookmark( "zm_round_end", gettime() );
		BBPostDemoStreamStatsForRound( level.round_number );

		wait( 0.05 );
	}
}

end_game()
{
	level waittill ( "end_game" );
	
/#	println( "end_game TRIGGERED " );	#/
	
	clientnotify( "zesn" );
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "game_over" );
	
	//AYERS: Turn off ANY last stand audio at the end of the game
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		setClientSysState( "lsm", "0", players[i] );
	}

	StopAllRumbles();
	
	recordNumZombieRounds(level.round_number);

	level.intermission = true;
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
	level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;
	wait 0.1;

	maps\mp\zombies\_zm_stats::update_players_stats_at_match_end( players );
	
	upload_leaderboards();

	game_over = [];
	survived = [];

	players = GET_PLAYERS();

 	if(!isDefined(level._supress_survived_screen))
 	{
		
		for( i = 0; i < players.size; i++ )
		{
			game_over[i] = NewClientHudElem( players[i] );
			game_over[i].alignX = "center";
			game_over[i].alignY = "middle";
			game_over[i].horzAlign = "center";
			game_over[i].vertAlign = "middle";
			game_over[i].y -= 130;
			game_over[i].foreground = true;
			game_over[i].fontScale = 3;
			game_over[i].alpha = 0;
			game_over[i].color = ( 1.0, 1.0, 1.0 );
			game_over[i] SetText( &"ZOMBIE_GAME_OVER" );
	
			game_over[i] FadeOverTime( 1 );
			game_over[i].alpha = 1;
			if ( players[i] isSplitScreen() )
			{
				game_over[i].y += 40;
			}
	
			survived[i] = NewClientHudElem( players[i] );
			survived[i].alignX = "center";
			survived[i].alignY = "middle";
			survived[i].horzAlign = "center";
			survived[i].vertAlign = "middle";
			survived[i].y -= 100;
			survived[i].foreground = true;
			survived[i].fontScale = 2;
			survived[i].alpha = 0;
			survived[i].color = ( 1.0, 1.0, 1.0 );
			if ( players[i] isSplitScreen() )
			{
				survived[i].y += 40;
			}
	
			//OLD COUNT METHOD
			if( level.round_number < 2 )
			{
				if( level.script == "zombie_moon" )
				{
					if( !isdefined(level.left_nomans_land) )
					{
						nomanslandtime = level.nml_best_time; 
						player_survival_time = int( nomanslandtime/1000 ); 
						player_survival_time_in_mins = maps\mp\zombies\_zm::to_mins( player_survival_time );		
						survived[i] SetText( &"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins );
					}
					else if( level.left_nomans_land==2 )
					{
						survived[i] SetText( &"ZOMBIE_SURVIVED_ROUND" );
					}
				}
				else
				{
					survived[i] SetText( &"ZOMBIE_SURVIVED_ROUND" );
				}
			}
			else
			{
				survived[i] SetText( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number );
			}
	
			survived[i] FadeOverTime( 1 );
			survived[i].alpha = 1;
		}
	}


	for (i = 0; i < players.size; i++)
	{
		players[i] SetClientAmmoCounterHide( true );
		players[i] SetClientMiniScoreboardHide( true );
	}

	destroy_chalk_hud();

	UploadStats();

	wait( 1 );

	//play_sound_at_pos( "end_of_game", ( 0, 0, 0 ) );
	wait( 2 );
	intermission();
	wait( level.zombie_vars["zombie_intermission_time"] );

	level notify( "stop_intermission" );
	array_thread( GET_PLAYERS(), ::player_exit_level );

	bbPrint( "zombie_epilogs: rounds %d", level.round_number );
	if(!isDefined(level._supress_survived_screen))
 	{
		players = GET_PLAYERS();
		for (i = 0; i < players.size; i++)
		{
			survived[i] FadeOverTime( 1 );
			survived[i].alpha = 0;
			game_over[i] FadeOverTime( 1 );
			game_over[i].alpha = 0;
		}
	}

	wait( 1.5 );

	
/*	we are not currently supporting the shared screen tech
	if( IsSplitScreen() )
	{
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
		{
			share_screen( players[i], false );
		}
	}
*/

	players = GET_PLAYERS();
	for ( j = 0; j < players.size; j++ )
	{
		player = players[j];
		player CameraActivate( false );	
		
		if(!isDefined(level._supress_survived_screen))
 		{
			survived[j] Destroy();
			game_over[j] Destroy();
		}
	}
	
	if ( players.size > 1 || !flag( "solo_game" ) ) //level.onlineGame || SessionModeIsSystemlink() )
	{
		ExitLevel( false );
	}
	else
	{
		Map_Restart(); // this is faster, but exposes more restart crashes
		//MissionFailed();  
	}

	// Let's not exit the function
	wait( 666 );
}

// this will save the leaderboard data per round, for use in single player
upload_leaderboards()
{	
	// place restrictions on whether leaderboards are uploaded to in the precache leaderboards function
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		players[i] uploadleaderboards();
	}
}


initializeStatTracking()
{
	level.global_zombies_killed = 0;
}

uploadGlobalStatCounters()
{
	incrementCounter( "global_zombies_killed", level.global_zombies_killed );
	incrementCounter( "global_zombies_killed_by_players", level.zombie_player_killed_count );
	incrementCounter( "global_zombies_killed_by_traps", level.zombie_trap_killed_count );	
}

player_fake_death()
{
	level notify ("fake_death");
	self notify ("fake_death");

	self TakeAllWeapons();
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowProne( true );

	self.ignoreme = true;
	self EnableInvulnerability();

	wait( 1 );
	self FreezeControls( true );
}

player_exit_level()
{
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );

	if( IsDefined( self.game_over_bg ) )
	{
		self.game_over_bg.foreground = true;
		self.game_over_bg.sort = 100;
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 1;
	}
}


player_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	// BLANK
	level waittill( "forever" );
}
	
player_zombie_breadcrumb()
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	level endon( "intermission" );

	self.zombie_breadcrumbs = []; 
	self.zombie_breadcrumb_distance = 24 * 24; // min dist (squared) the player must move to drop a crumb
	self.zombie_breadcrumb_area_num = 3;	   // the number of "rings" the area breadcrumbs use
	self.zombie_breadcrumb_area_distance = 16; // the distance between each "ring" of the area breadcrumbs

	self store_crumb( self.origin ); 
	last_crumb = self.origin;

	self thread debug_breadcrumbs(); 

	while( 1 )
	{
		wait_time = 0.1;
		
	/*
		//T6.5todo
		if( self isnotarget() )
		{
			wait( wait_time ); 
			continue;
		}
	*/
	
		//For cloaking ability
		//if( self.ignoreme )
		//{
		//	wait( wait_time ); 
		//	continue;
		//}


		store_crumb = true; 
		airborne = false;
		crumb = self.origin;

//TODO TEMP SCRIPT for vehicle testing Delete/comment when done
		if ( !self IsOnGround() && self isinvehicle() )
		{
			trace = bullettrace( self.origin + (0,0,10), self.origin, false, undefined );
			crumb = trace["position"];
		}

//TODO TEMP DISABLE for vehicle testing.  Uncomment when reverting
// 		if ( !self IsOnGround() )
// 		{
// 			airborne = true;
// 			store_crumb = false; 
// 			wait_time = 0.05;
// 		}
// 		
		if( !airborne && DistanceSquared( crumb, last_crumb ) < self.zombie_breadcrumb_distance )
		{
			store_crumb = false; 
		}

		if ( airborne && self IsOnGround() )
		{
			// player was airborne, store crumb now that he's on the ground
			store_crumb = true;
			airborne = false;
		}
		
		if( isDefined( level.custom_breadcrumb_store_func ) )
		{
			store_crumb = self [[ level.custom_breadcrumb_store_func ]]( store_crumb );
		}
		
		if( isDefined( level.custom_airborne_func ) )
		{
			airborne = self [[ level.custom_airborne_func ]]( airborne );
		}
		
		if( store_crumb )
		{
			debug_print( "Player is storing breadcrumb " + crumb );
			
			if( IsDefined(self.node) )
			{
				debug_print( "has closest node " );
			}
			
			last_crumb = crumb;
			self store_crumb( crumb );
		}

		wait( wait_time ); 
	}
}


store_crumb( origin )
{
	offsets = [];
	height_offset = 32;
	
	index = 0;
	for( j = 1; j <= self.zombie_breadcrumb_area_num; j++ )
	{
		offset = ( j * self.zombie_breadcrumb_area_distance );
		
		offsets[0] = ( origin[0] - offset, origin[1], origin[2] );
		offsets[1] = ( origin[0] + offset, origin[1], origin[2] );
		offsets[2] = ( origin[0], origin[1] - offset, origin[2] );
		offsets[3] = ( origin[0], origin[1] + offset, origin[2] );

		offsets[4] = ( origin[0] - offset, origin[1], origin[2] + height_offset );
		offsets[5] = ( origin[0] + offset, origin[1], origin[2] + height_offset );
		offsets[6] = ( origin[0], origin[1] - offset, origin[2] + height_offset );
		offsets[7] = ( origin[0], origin[1] + offset, origin[2] + height_offset );

		for ( i = 0; i < offsets.size; i++ )
		{
			self.zombie_breadcrumbs[index] = offsets[i];
			index++;
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LEADERBOARD CODE///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
to_mins( seconds )
{
	hours = 0; 
	minutes = 0; 
	
	if( seconds > 59 )
	{
		minutes = int( seconds / 60 );

		seconds = int( seconds * 1000 ) % ( 60 * 1000 );
		seconds = seconds * 0.001; 

		if( minutes > 59 )
		{
			hours = int( minutes / 60 );
			minutes = int( minutes * 1000 ) % ( 60 * 1000 );
			minutes = minutes * 0.001; 		
		}
	}

	if( hours < 10 )
	{
		hours = "0" + hours; 
	}

	if( minutes < 10 )
	{
		minutes = "0" + minutes; 
	}

	seconds = Int( seconds ); 
	if( seconds < 10 )
	{
		seconds = "0" + seconds; 
	}

	combined = "" + hours  + ":" + minutes  + ":" + seconds; 

	return combined; 
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// INTERMISSION =========================================================== //
//

intermission()
{
	level.intermission = true;
	level notify( "intermission" );

	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		setclientsysstate( "levelNotify", "zi", players[i] ); // Tell clientscripts we're in zombie intermission

		players[i] SetClientThirdPerson( 0 );
		players[i] SetClientFOV( 65 );

		players[i].health = 100; // This is needed so the player view doesn't get stuck
		players[i] thread [[level.custom_intermission]]();
	}

	wait( 0.25 );

	// Delay the last stand monitor so we are 100% sure the zombie intermission ("zi") is set on the cients
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		setClientSysState( "lsm", "0", players[i] );
	}

	level thread zombie_game_over_death();
}

zombie_game_over_death()
{
	// Kill remaining zombies, in style!
	zombies = GetAiArray( "axis" );
	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		zombies[i] SetGoalPos( zombies[i].origin );
	}

	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		wait( 0.5 + RandomFloat( 2 ) );

		if ( isdefined( zombies[i] ) )
		{
			zombies[i] maps\mp\zombies\_zm_spawner::zombie_head_gib();
			zombies[i] DoDamage( zombies[i].health + 666, zombies[i].origin );
		}
	}
}

player_intermission()
{
	self closeMenu();
	self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;	

	self.sessionstate = "intermission";
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	points = getstructarray( "intermission", "targetname" );

	if( !IsDefined( points ) || points.size == 0 )
	{
		points = getentarray( "info_intermission", "classname" ); 
		if( points.size < 1 )
		{
		/#	println( "NO info_intermission POINTS IN MAP" ); 	#/
			return;
		}	
	}

	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	org = undefined;
	while( 1 )
	{
		points = array_randomize( points );
		for( i = 0; i < points.size; i++ )
		{
			point = points[i];
			// Only spawn once if we are using 'moving' org
			// If only using info_intermissions, this will respawn after 5 seconds.
			if( !IsDefined( org ) )
			{
				self Spawn( point.origin, point.angles );
			}

			// Only used with STRUCTS
			if( IsDefined( points[i].target ) )
			{
				if( !IsDefined( org ) )
				{
					org = Spawn( "script_model", self.origin + ( 0, 0, -60 ) );
					org SetModel("tag_origin");
				}

//				self LinkTo( org, "", ( 0, 0, -60 ), ( 0, 0, 0 ) );
//				self SetPlayerAngles( points[i].angles );
				org.origin = points[i].origin;
				org.angles = points[i].angles;
				

				for ( j = 0; j < GET_PLAYERS().size; j++ )
				{
					player = GET_PLAYERS()[j];
					player CameraSetPosition( org );
					player CameraSetLookAt();
					player CameraActivate( true );	
				}

				speed = 20;
				if( IsDefined( points[i].speed ) )
				{
					speed = points[i].speed;
				}

				target_point = getstruct( points[i].target, "targetname" );
				dist = Distance( points[i].origin, target_point.origin );
				time = dist / speed;

				q_time = time * 0.25;
				if( q_time > 1 )
				{
					q_time = 1;
				}

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 0;

				org MoveTo( target_point.origin, time, q_time, q_time );
				org RotateTo( target_point.angles, time, q_time, q_time );
				wait( time - q_time );

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 1;

				wait( q_time );
			}
			else
			{
				self.game_over_bg FadeOverTime( 1 );
				self.game_over_bg.alpha = 0;

				wait( 5 );
				
				self.game_over_bg thread fade_up_over_time(1);

				//wait( 1 );
			}
		}
	}
}

fade_up_over_time(t)
{
		self FadeOverTime( t );
		self.alpha = 1;
}

prevent_near_origin()
{
	while (1)
	{
		players = GET_PLAYERS();

		for (i = 0; i < players.size; i++)
		{
			for (q = 0; q < players.size; q++)
			{
				if (players[i] != players[q])
				{	
					if (check_to_kill_near_origin(players[i], players[q]))
					{
						p1_org = players[i].origin;
						p2_org = players[q].origin;

						wait 5;

						if (check_to_kill_near_origin(players[i], players[q]))
						{
							if ( (distance(players[i].origin, p1_org) < 30) && distance(players[q].origin, p2_org) < 30)
							{
								players[i] DoDamage( players[i].health + 1000, players[i].origin, undefined, undefined, "none", "riflebullet" );
							}
						}
					}	
				}
			}	
		}

		wait 0.2;
	}
}

check_to_kill_near_origin(player1, player2)
{
	if (!isdefined(player1) || !isdefined(player2))
	{
		return false;		
	}

	if (distance(player1.origin, player2.origin) > 12)
	{
		return false;
	}

	if ( player1 maps\mp\zombies\_zm_laststand::player_is_in_laststand() || player2 maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		return false;
	}

	if (!isalive(player1) || !isalive(player2))
	{
		return false;		
	}

	return true;
}


default_exit_level()
{
	zombies = GetAiArray( "axis" );
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( is_true( zombies[i].ignore_solo_last_stand ) )
		{
			continue;
		}

		if ( isDefined( zombies[i].find_exit_point ) )
		{
			zombies[i] thread [[ zombies[i].find_exit_point ]]();
			continue;
		}

		if ( zombies[i].ignoreme )
		{
			zombies[i] thread default_delayed_exit();
		}
		else
		{
			zombies[i] thread default_find_exit_point();
		}
	}
}

default_delayed_exit()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( !flag( "wait_and_revive" ) )
		{
			return;
		}

		// broke through the barricade, find an exit point
		if ( !self.ignoreme )
		{
			break;
		}
		wait_network_frame();
	}

	self thread default_find_exit_point();
}

default_find_exit_point()
{
	self endon( "death" );

	player = GET_PLAYERS()[0];

	dist_zombie = 0;
	dist_player = 0;
	dest = 0;

	away = VectorNormalize( self.origin - player.origin );
	endPos = self.origin + VectorScale( away, 600 );

	locs = array_randomize( level.enemy_dog_locations );

	for ( i = 0; i < locs.size; i++ )
	{
		dist_zombie = DistanceSquared( locs[i].origin, endPos );
		dist_player = DistanceSquared( locs[i].origin, player.origin );

		if ( dist_zombie < dist_player )
		{
			dest = i;
			break;
		}
	}

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	if( isdefined( locs[dest] ) )
	{
		self setgoalpos( locs[dest].origin );
	}

	while ( 1 )
	{
		if ( !flag( "wait_and_revive" ) )
		{
			break;
		}
		wait_network_frame();
	}
	
	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

play_level_start_vox_delayed()
{
    wait(3);
    players = GET_PLAYERS();
	num = RandomIntRange( 0, players.size );
	players[num] maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "intro" );
}


register_sidequest( id, sidequest_stat )
{
	if ( !IsDefined( level.zombie_sidequest_stat ) )
	{
		level.zombie_sidequest_previously_completed = [];
		level.zombie_sidequest_stat = [];
	}
	
	level.zombie_sidequest_stat[id] = sidequest_stat;

	//flag_wait( "all_players_spawned" );
	flag_wait( "start_zombie_round_logic" );

	level.zombie_sidequest_previously_completed[id] = false;

	// don't do stats stuff if it's not an online game
	if ( level.systemLink || GetDvarInt( "splitscreen_playerCount" ) == GET_PLAYERS().size )
	{
		return;
	}

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] maps\mp\zombies\_zm_stats::get_global_stat( level.zombie_sidequest_stat[id] ) )
		{
			level.zombie_sidequest_previously_completed[id] = true;
			return;
		}
	}
}


is_sidequest_previously_completed(id)
{
	return is_true( level.zombie_sidequest_previously_completed[id] );
}


set_sidequest_completed(id)
{
	level notify( "zombie_sidequest_completed", id );
	level.zombie_sidequest_previously_completed[id] = true;

	// don't do stats stuff if it's not an online game
	if ( level.systemLink )
	{
		return; 
	}
	if ( GetDvarInt( "splitscreen_playerCount" ) == GET_PLAYERS().size )
	{
		return;
	}

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( level.zombie_sidequest_stat[id] ) )
		{
			players[i] maps\mp\zombies\_zm_stats::add_global_stat( level.zombie_sidequest_stat[id], 1 );
		}
	}
}

getZMGameModule( value )
{
	
	test_dvar = getdvar("zm_gametype");
	if(test_dvar != "")
	{
		value = test_dvar;
	}
	
	switch(value)
	{
		case "zclassic" : return 0;		
		case "zsurvival" : return 0;		
		case "zcontainment":	return 1;			
		case "zrace":			return 2;			
		case "zdeadpool":		return 3;
		case "zmeat":			return 4;
		case "znml":			return 5;
		case "zturned":			return 6;
		case "zpitted":			return 7;
		case "zcleansed":			return 8;
		case "zgrief":			return 9;
		case "zstandard":		return 10; 	
	}
}

playSwipeSound( mod, attacker )
{
	if( is_true(attacker.is_zombie) )
	{
		self playsoundtoplayer( "evt_player_swiped", self );
		return;
	}
}

precache_zombie_leaderboards()
{
	// don't save leaderboards for systemlink
	if( SessionModeIsSystemlink() )
	{
		return; 
	}

	// global ones
	globalLeaderboards = "LB_ZM_GB_BULLETS_FIRED_AT ";
	globalLeaderboards += "LB_ZM_GB_BULLETS_HIT_AT "; 
	globalLeaderboards += "LB_ZM_GB_DEATHS_AT "; 
	globalLeaderboards += "LB_ZM_GB_DISTANCE_TRAVELED_AT "; 
	globalLeaderboards += "LB_ZM_GB_DOORS_PURCHASED_AT "; 
	globalLeaderboards += "LB_ZM_GB_DOWNS_AT "; 
	globalLeaderboards += "LB_ZM_GB_GIBS_AT "; 
	globalLeaderboards += "LB_ZM_GB_GRENADE_KILLS_AT "; 
	globalLeaderboards += "LB_ZM_GB_HEADSHOTS_AT "; 
	globalLeaderboards += "LB_ZM_GB_KILLS_AT "; 
	globalLeaderboards += "LB_ZM_GB_PERKS_DRANK_AT "; 
	globalLeaderboards += "LB_ZM_GB_REVIVES_AT "; 

	// gamemode leaderboards
	gameMode = GetDvar( "ui_gametype" );

	if ( gameMode == "zsurvival")// survival
	{
		mapLocationName = level.scr_zm_map_start_location;
		if ((mapLocationName == "default" || mapLocationName == "" ) && IsDefined(level.default_start_location))
		{
			mapLocationName = level.default_start_location;
		}			
			
		// TODO: will see if we can precache only one of the following later
		gamemodeLeaderboard = "LB_ZM_CLASSIC_" + mapLocationName + "_1PLAYER_AT "; 
		gamemodeLeaderboard += "LB_ZM_CLASSIC_" + mapLocationName + "_2PLAYERS_AT "; 
		gamemodeLeaderboard += "LB_ZM_CLASSIC_" + mapLocationName + "_3PLAYERS_AT "; 
		gamemodeLeaderboard += "LB_ZM_CLASSIC_" + mapLocationName + "_4PLAYERS_AT"; 
	}
	else // encounters
	{		
		gamemodeLeaderboard = "LB_ZM_" + gameMode + "_AT"; 		
	}	

	precacheLeaderboards( globalLeaderboards + gamemodeLeaderboard );
}
