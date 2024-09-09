#include common_scripts\utility;
//#include common_scripts\shared;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_ks;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;
#include maps\mp\bots\_bots_personality;

//========================================================
//					main 
//========================================================
main()
{
	if( IsDefined( level.createFX_enabled ) && level.createFX_enabled )
		return;

	// This is called directly from native code on game startup
	// The particular gametype's main() is called from native code afterward
	
	setup_callbacks();
	setup_personalities();
	setup_persistent_values();

	// Enable badplaces in destructibles
	level.badplace_cylinder_func = ::badplace_cylinder;
	level.badplace_delete_func = ::badplace_delete;
	
	// Init bot killstreak script
	maps\mp\bots\_bots_ks::bot_killstreak_setup();

	// Init bot loadout data
	// Needs to be after _bots_ks::bot_killstreak_setup
	maps\mp\bots\_bots_loadout::init();
	
	// Needs to be after _bots_loadout::init()
	level thread init();
}


//========================================================
//					setup_callbacks 
//========================================================
setup_callbacks()
{
	// Setup level.bot_funcs callback function table
	level.bot_funcs = [];
	
	// Bot System functions
	level.bot_funcs["bots_spawn"]						= ::spawn_bots;
	level.bot_funcs["bots_wait_for_player"]				= ::bot_wait_for_player;

	// Bot entity functions
	level.bot_funcs["think"]							= ::bot_think;
	level.bot_funcs["on_killed"]						= ::on_bot_killed;
	level.bot_funcs["should_do_killcam"]				= ::bot_should_do_killcam;
	level.bot_funcs["should_pickup_weapons"]			= ::bot_should_pickup_weapons;
	level.bot_funcs["on_damaged"]						= ::bot_damage_callback;
	level.bot_funcs["can_use_crate"]					= ::default_can_use_crate;
	level.bot_funcs["gametype_think"]					= ::default_gametype_think;
	level.bot_funcs["leader_dialog"]					= ::bot_leader_dialog;
	level.bot_funcs["player_spawned"]					= ::bot_player_spawned;
	level.bot_funcs["should_start_cautious_approach"]	= ::should_start_cautious_approach_default;
	level.bot_funcs["know_enemies_on_start"]			= ::bot_know_enemies_on_start;
	level.bot_funcs["make_entity_sentient"]				= ::bot_make_entity_sentient;
	
	// temp model swap for siege mode
	if( level.gametype == "siege" )
	{
		level.bot_funcs["setup_appearance"]	= ::bot_setup_appearance;
	}

	// War (TDM) gametype serves as the default, so we use it to setup default gametype callbacks
	maps\mp\bots\_bots_gametype_war::setup_callbacks();
}


//========================================================
//				setup_persistent_values 
//========================================================
setup_persistent_values()
{
	file_name		= "mp/botDifficultyTable.csv";
	row 			= 0;
	
	level.bot_persistent_values = [];
	
	// loop over all the rows in the lookup table
	while( true )
	{
		bot_value_name = TableLookupByRow( file_name, row, 0 );
	 
		// stop at at the end of the file 
		if ( bot_value_name == "" )
		{
		 	break;
		}
		
		for ( i=0; i<=3; i++ )
		{
			string_value = TableLookupByRow( file_name, row, (i+1) );
			bot_setting_value = Float(string_value);
	 		
			level.bot_persistent_values[bot_value_name][i] = bot_setting_value;
		}
	 
		row++;
	}
}

//========================================================
//					init 
//========================================================
init()
{	
	initLevelVariables();
	
	/#
    level thread bot_debug_drawing();
    #/
	
	if( !shouldSpawnBots() )
		return;

	refresh_existing_bots();
	
	if( BotAutoConnectEnabled() == 0 )
		return;
	
    // drop and spawn bots as needed
    level thread bot_connect_monitor();
    	
	setMatchData( "hasBots", true );
}


//========================================================
//					initVariables 
//========================================================
initLevelVariables()
{
	if ( !IsDefined(level.crateOwnerUseTime) )
	{
		level.crateOwnerUseTime = 500;
	}
	
	if ( !IsDefined(level.crateNonOwnerUseTime) )
	{
		level.crateNonOwnerUseTime	= 3000;
	}
	
	// Time it takes (after losing track of an enemy) for a bot to consider himself "out of combat"
	level.bot_out_of_combat_time = 3000;
	
	// Should match BG_VIEWHEIGHT_STANDING_DEFAULT in code
	level.bot_eye_height = 55;
}


//========================================================
//					shouldSpawnBots 
//========================================================
shouldSpawnBots()
{
	//	bypassing for siege entirely for now to simplify prototyping, will re-integrate as game mode evolves
	if( level.gameType == "siege" )
	{
		return false;
	}
	
	return true;
}


refresh_existing_bots()
{
	wait 1; // give level.players a chance to initialize between rounds

	// If we switched sides, the bots will still exist in game but will have lost their think threads.  So we need to restart them
	foreach ( player in level.players )
	{
		if ( IsBot( player ) )
		{
 			player.equipment_enabled = true;
 			player.bot_team = player.team;
 			player.bot_spawned_before = true;
 			player thread [[ level.bot_funcs["think"] ]]();	
		}
	}
}

/#
bot_debug_drawing()
{
	level endon( "game_ended" );
	
	level.defense_debug_structs = [];
	for( i=0; i<10; i++ )
	{
		level.defense_debug_structs[level.defense_debug_structs.size] = SpawnStruct();
	}
	
	for(;;)
	{
		draw_debug_type = GetDvar("bot_DrawDebugSpecial");
		
		if ( draw_debug_type == "defend" )
		{
			bot_debug_draw_defense();
		}
		else if ( draw_debug_type == "entrances" )
		{
			bot_debug_draw_watch_nodes();
		}
		else if ( draw_debug_type == "defend_with_entrances" )
		{
			bot_debug_draw_defense();
			bot_debug_draw_watch_nodes();
		}
		else if ( draw_debug_type == "key_entry_points" )
		{
			bot_debug_draw_cached_entrances();
		}
		else if ( draw_debug_type == "key_cached_paths" )
		{
			bot_debug_draw_cached_paths();
		}
		
		wait(0.05);
	}
}

bot_debug_draw_defense()
{
	level.cur_num_defense_debug_structs = 0;
	players = bot_get_all_players_and_agents();
	foreach( player in players )
	{
		if ( player.health > 0 && IsAIGameParticipant( player ) && player bot_is_defending() )
		{
			struct_for_defense = undefined;
			for( i=0; i<level.cur_num_defense_debug_structs; i++ )
			{
				struct = level.defense_debug_structs[i];
				if ( struct.defense_type == player.bot_defending_type && struct.defense_radius == player.bot_defending_radius )
				{
					if ( DistanceSquared( struct.defense_center, player.bot_defending_center ) < 1 )
					{
						struct_for_defense = struct;
						break;
					}
				}
			}
			
			if ( IsDefined(struct_for_defense) )
			{
				if ( struct_for_defense.defense_team != player.team )
				{
					struct_for_defense.cylinder_color = (1,0,1);
				}
				
				struct_for_defense.bots = array_add( struct_for_defense.bots, player );
			}
			else
			{
				new_defense_struct = level.defense_debug_structs[level.cur_num_defense_debug_structs];
				level.cur_num_defense_debug_structs++;
				
				// Create a struct for this defense type
				if ( player.team == "allies" )
				{
					new_defense_struct.cylinder_color = (0,0,1); // allies are blue
				}
				else if ( player.team == "axis" )
				{
					new_defense_struct.cylinder_color = (1,0,0); // axis are red
				}
				
				new_defense_struct.defense_team = player.team;
				new_defense_struct.defense_type = player.bot_defending_type;
				new_defense_struct.defense_radius = player.bot_defending_radius;
				if ( player.bot_defending_type == "capture_zone" )
				{
					new_defense_struct.defense_center = player.bot_defending_center - (0,0,15);
					new_defense_struct.defense_nodes = player.bot_defending_nodes;
				}
				else
				{
					new_defense_struct.defense_center = player.bot_defending_center;
					new_defense_struct.defense_nodes = undefined;
				}
				new_defense_struct.bots = [];
				new_defense_struct.bots = array_add( new_defense_struct.bots, player );
			}
		}
	}
	
	for( i=0; i<level.cur_num_defense_debug_structs; i++ )
	{
		struct = level.defense_debug_structs[i];
		
		if ( IsDefined(struct.defense_nodes) )
		{
			minX = struct.defense_center[0];
			maxX = struct.defense_center[0];
			minY = struct.defense_center[1];
			maxY = struct.defense_center[1];
			minZ = struct.defense_center[2];
			maxZ = struct.defense_center[2];
			
			// Draw box at each node, and calculate bounds
			foreach( node in struct.defense_nodes )
			{
				bot_draw_cylinder(node.origin, 10, 10, 0.05, undefined, struct.cylinder_color, true, 4);
				
				minX = min(minX,node.origin[0]);
				maxX = max(maxX,node.origin[0]);
				
				minY = min(minY,node.origin[1]);
				maxY = max(maxY,node.origin[1]);
				
				minZ = min(minZ,node.origin[2]);
				maxZ = max(maxZ,node.origin[2]);
			}
			
			minX -= 12;
			minY -= 12;
			maxX += 12;
			maxY += 12;
			maxZ += 60;
			
			// Draw a bigger box that encompasses all the nodes (approximate the trigger that the nodes are in)
			
			// vertical lines
			line( (minX,minY,minZ), (minX,minY,maxZ), struct.cylinder_color, 1, true );
			line( (minX,maxY,minZ), (minX,maxY,maxZ), struct.cylinder_color, 1, true );
			line( (maxX,minY,minZ), (maxX,minY,maxZ), struct.cylinder_color, 1, true );
			line( (maxX,maxY,minZ), (maxX,maxY,maxZ), struct.cylinder_color, 1, true );
			
			// lower horz lines
			line( (minX,minY,minZ), (minX,maxY,minZ), struct.cylinder_color, 1, true );
			line( (minX,minY,minZ), (maxX,minY,minZ), struct.cylinder_color, 1, true );
			line( (maxX,maxY,minZ), (minX,maxY,minZ), struct.cylinder_color, 1, true );
			line( (maxX,maxY,minZ), (maxX,minY,minZ), struct.cylinder_color, 1, true );
			
			// upper horz lines
			line( (minX,minY,maxZ), (minX,maxY,maxZ), struct.cylinder_color, 1, true );
			line( (minX,minY,maxZ), (maxX,minY,maxZ), struct.cylinder_color, 1, true );
			line( (maxX,maxY,maxZ), (minX,maxY,maxZ), struct.cylinder_color, 1, true );
			line( (maxX,maxY,maxZ), (maxX,minY,maxZ), struct.cylinder_color, 1, true );
		}
		else
		{
			bot_draw_cylinder(struct.defense_center, struct.defense_radius, 75, 0.05, undefined, struct.cylinder_color, true);
		}
		
		foreach( bot in struct.bots )
		{
			lineStart = struct.defense_center + (0,0,25);
			lineEnd = bot.origin + (0,0,25);
			
			line_color = undefined;
			if ( bot.team == "allies" )
				line_color = (0,0,1);
			else if ( bot.team == "axis" )
				line_color = (1,0,0);
			
			line( lineStart, lineEnd, line_color, 1, true );
		}
	}	
}

bot_debug_draw_watch_nodes()
{
	players = bot_get_all_players_and_agents();
	foreach( player in players )
	{
		if ( player.health > 0 && IsAIGameParticipant( player ) && IsDefined(player.watch_nodes)  )
		{
			node_offset = (0,0,level.bot_eye_height);
			player_stance = player GetStance();
			if ( player_stance == "crouch" )
				node_offset = (0,0,40);
			else if ( player_stance == "prone" )
				node_offset = (0,0,11);
		
			foreach( node in player.watch_nodes )
			{
				// green means "high priority watch"
				// white means "low priority watch"
				// color lerps between the two
				entrance_color = (1 - node.watch_node_chance[player.entity_number], 1, 1 - node.watch_node_chance[player.entity_number]);
				
				line( player.origin + node_offset, node.origin + (0,0,30), entrance_color, 1, true );
				bot_draw_cylinder(node.origin + (0,0,30), 10, 10, 0.05, undefined, entrance_color, true, 4);
			}
		}
	}
}

bot_debug_draw_cached_entrances()
{
	if ( !IsDefined( level.entrance_indices ) || !IsDefined(level.entrance_points) )
		return;
	
	node_offset = (0,0,11);
	standing_offset = (0,0,level.bot_eye_height);
	crouching_offset = (0,0,40);
	prone_offset = (0,0,15);
	color_visible = (0,1,0);
	color_not_visible = (1,0,0);
	node_height = 13;
	for ( i = 0; i < level.entrance_indices.size; i++ )
	{
		entrance_collection = level.entrance_points[level.entrance_indices[i]];
		for ( j = 0; j < entrance_collection.size; j++ )
		{
			bot_draw_cylinder(entrance_collection[j].origin + node_offset, 10, node_height, 0.05, undefined, (0,1,0), true, 4);
			
			// standing
			line( level.entrance_origin_points[i] + standing_offset, entrance_collection[j].origin + node_offset + (0,0,node_height/2), color_visible, 1, true );
			
			// crouching
			color_to_use = color_not_visible;
			if ( entrance_collection[j].crouch_visible_from[level.entrance_indices[i]] )
				color_to_use = color_visible;
			line( level.entrance_origin_points[i] + crouching_offset, entrance_collection[j].origin + node_offset + (0,0,node_height/2), color_to_use, 1, true );
			
			// prone
			color_to_use = color_not_visible;
			if ( entrance_collection[j].prone_visible_from[level.entrance_indices[i]] )
				color_to_use = color_visible;
			line( level.entrance_origin_points[i] + prone_offset, entrance_collection[j].origin + node_offset + (0,0,node_height/2), color_to_use, 1, true );
		}
		
		// Note: this white cylinder is the botTarget, if it exists
		bot_draw_cylinder(level.entrance_origin_points[i], 10, 75, 0.05, undefined, (1,1,1), true, 8);
	}
}

bot_debug_draw_cached_paths()
{
	if ( !IsDefined( level.entrance_indices ) )
		return;
	
	node_colors = [ (1,0,0), (0,1,0), (0,0,1), (1,0,1), (1,1,0), (0,1,1), (1,0.6,0.6), (0.6,1,0.6), (0.6,0.6,1), (0.1,0.1,0.1) ];

	if ( !IsDefined(level.next_path_time) )
	{
		level.bot_debug_cur_node_color = 0;
		level.bot_debug_cur_first_index = 0;
		level.bot_debug_cur_second_index = 1;
		level.next_path_time = GetTime() + (15 * 1000);
	}

	if ( GetTime() > level.next_path_time )
	{
		if ( level.bot_debug_cur_second_index == level.entrance_indices.size - 1 )
		{
			if ( level.bot_debug_cur_first_index == level.entrance_indices.size - 2 )
			{
				level.bot_debug_cur_first_index = 0;
				level.bot_debug_cur_node_color = -1;
			}
			else
			{
				level.bot_debug_cur_first_index++;
			}
			level.bot_debug_cur_second_index = level.bot_debug_cur_first_index + 1;
		}
		else
		{
			level.bot_debug_cur_second_index++;
		}
		
		level.bot_debug_cur_node_color = (level.bot_debug_cur_node_color + 1) % node_colors.size;
		level.next_path_time = GetTime() + (15 * 1000);
	}
	
	// Note: these white cylinders are the botTargets, if they exist
	bot_draw_cylinder(level.entrance_origin_points[level.bot_debug_cur_first_index], 10, 75, 0.05, undefined, (1,1,1), true, 8);
	bot_draw_cylinder(level.entrance_origin_points[level.bot_debug_cur_second_index], 10, 75, 0.05, undefined, (1,1,1), true, 8);
	foreach( node in level.precalculated_paths[level.entrance_indices[level.bot_debug_cur_first_index]][level.entrance_indices[level.bot_debug_cur_second_index]] )
	{
		bot_draw_cylinder(node.origin, 10, 13, 0.05, undefined, node_colors[level.bot_debug_cur_node_color], true, 4);
	}
}
#/

//========================================================
//				bot_player_spawned 
//========================================================
bot_player_spawned()
{
	// if we have spawned with the "callback" class already selected we need to make sure the callbacks are setup for us
	// this happens between rounds of a round based game mode like Search and Destroy
	if ( IsDefined( self.class ) && (self.class == "callback") )
		self maps\mp\bots\_bots_loadout::bot_setup_loadout_callback();
}

watch_players_connecting()
{
	while(1)
	{
		level waittill("connected", player);
		if ( !IsAI( player ) && (level.players.size > 0) )	// If playing a local listen server, ignore this for the first player to join
		{
			level.players_waiting_to_join = array_add(level.players_waiting_to_join, player);
			childthread bots_notify_on_spawn(player);
			childthread bots_notify_on_disconnect(player);
			childthread bots_remove_from_array_on_notify(player);
		}
	}
}

bots_notify_on_spawn(player)
{
	player endon("bots_human_disconnected");
	while( !array_contains(level.players,player) )
	{
		wait(0.05);
	}
	player notify("bots_human_spawned");
}

bots_notify_on_disconnect(player)
{
	player endon("bots_human_spawned");
	player waittill("disconnect");
	player notify("bots_human_disconnected");
}

bots_remove_from_array_on_notify(player)
{
	player waittill_any("bots_human_spawned","bots_human_disconnected");
	level.players_waiting_to_join = array_remove(level.players_waiting_to_join,player);
}

monitor_pause_spawning()
{
	// The purpose of this function (and all the childthreads) is to pause bot spawning while a human player is in the process of joining the game
	// So when a human connects, we add him to the "waiting" array, and he stays in there until he spawns in the game or disconnects
	// As long as there are any humans in the queue, we don't want bots to be spawning and taking up the human players' spots
	
	level.players_waiting_to_join = [];
	childthread watch_players_connecting();
	
	while(1)
	{
		if ( level.players_waiting_to_join.size > 0 )
			level.pausing_bot_connect_monitor = true;
		else
			level.pausing_bot_connect_monitor = false;
		
		wait(0.5);
	}
}

//========================================================
//				bot_connect_monitor 
//========================================================
bot_connect_monitor( num_ally_bots, num_enemy_bots )
{
	self notify( "bot_connect_monitor" );
	self endon( "bot_connect_monitor" );

	level.pausing_bot_connect_monitor = false;
	childthread monitor_pause_spawning();
	
	wait(0.5);
	bot_connect_monitor_update_time = 1.5;
	
	for(;;)
	{
		if ( level.pausing_bot_connect_monitor )
		{
			wait(bot_connect_monitor_update_time);
			continue;
		}
		
		// NOTE: if level.bots_ignore_team_balance is defined, these variables don't control the number of bots per team,
		// but combined they do control the absolute number of bots.  For example if level.bots_ignore_team_balance is defined, and 
		// max_ally_bots_absolute is 2 and max_enemy_bots_absolute is 8, the total number of bots you can have in the match is 10, but the
		// ally team could have all 10 of them.
		max_ally_bots_absolute = 9;		// No matter what, cannot have more this number ally bots
		max_enemy_bots_absolute = 9;	// No matter what, cannot have more this number enemy bots

		/#
		// if test clients have been added via the scr_testclients dvar, dont ever kick/spawn bots for team balance again
		if ( GetDvarInt("bot_DisableAutoConnect") )
			return;

		max_ally_bots_absolute = GetDvarInt("bot_MaxNumAllyBots");
		max_enemy_bots_absolute = GetDvarInt("bot_MaxNumEnemyBots");
		#/
		
		team_ally = "allies";	// team_ally is the team that the human player is on
		team_enemy = "axis";	// team_enemy is the enemy team (opposed to the team the human player is on)
		clientCounts = bot_client_counts();
		
		humanPlayer = get_human_player();
		if ( cat_array_get( clientCounts, "humans" ) > 1 )
		{
			cur_num_allies_players = cat_array_get( clientCounts, "humans_" + "allies");
			cur_num_axis_players = cat_array_get( clientCounts, "humans_" + "axis");
			if ( cur_num_axis_players > cur_num_allies_players )
			{
				// If there are more axis players, consider that to be team_ally (team that human players are on)
				team_ally = "axis";
				team_enemy = "allies";
			}
		}
		else if ( IsDefined( humanPlayer ) && humanPlayer.pers["team"] != "spectator" )
		{
			team_ally = humanPlayer.pers["team"];
			team_enemy = getOtherTeam( humanPlayer.pers["team"] );
		}
		
		// Count the max size of each team (in terms of client limits)
		ally_team_size = bot_get_team_limit();
		enemy_team_size = bot_get_team_limit();
		if ( ally_team_size + enemy_team_size < bot_get_client_limit() )
		{
			// The client limit is odd, so add 1 to a team so we are still at the client limit
			if ( ally_team_size < max_ally_bots_absolute )
				ally_team_size++;
			else if ( enemy_team_size < max_enemy_bots_absolute )
				enemy_team_size++;
		}
		
		// Count current number of humans
		cur_num_ally_humans = cat_array_get( clientCounts, "humans_" + team_ally);
		cur_num_enemy_humans = cat_array_get( clientCounts, "humans_" + team_enemy);
		
		// Count current number of bots
		cur_num_ally_bots = cat_array_get( clientCounts, "bots_" + team_ally);
		cur_num_enemy_bots = cat_array_get( clientCounts, "bots_" + team_enemy);

		// Open bot slots per team is either the number of available spots (team size - number of humans) or the hard limit, whichever is lower
		ally_bot_slots = INT(min(ally_team_size - cur_num_ally_humans,max_ally_bots_absolute));
		enemy_bot_slots = INT(min(enemy_team_size - cur_num_enemy_humans,max_enemy_bots_absolute));
		
		// Number of bots wanted right now is the number of available slots (from above) minus the number of bots currently in the game
		ally_bots_wanted = ally_bot_slots - cur_num_ally_bots;
		enemy_bots_wanted = enemy_bot_slots - cur_num_enemy_bots;

		need_to_spawn_or_drop = true;
		if ( IsDefined(level.bots_ignore_team_balance) )
		{
			// Don't move bots between teams, but maybe spawn or drop them if necessary
			total_team_size = ally_team_size + enemy_team_size;
			max_total_bots_absolute = max_ally_bots_absolute + max_enemy_bots_absolute;
			cur_num_total_humans = cur_num_ally_humans + cur_num_enemy_humans;
			cur_num_total_bots = cur_num_ally_bots + cur_num_enemy_bots;
			total_bot_slots_open = INT(min(total_team_size - cur_num_total_humans,max_total_bots_absolute));
			
			total_num_bots_wanted = total_bot_slots_open - cur_num_total_bots;
			if ( total_num_bots_wanted == 0 )
			{
				// No changes needed
				need_to_spawn_or_drop = false;
			}
			else if ( total_num_bots_wanted > 0 )
			{
				// Need to add bots.  Just even them out between teams (doesn't really matter though)
				ally_bots_wanted = INT(total_num_bots_wanted/2) + (total_num_bots_wanted % 2 );
				enemy_bots_wanted = INT(total_num_bots_wanted/2);
			}
			else if ( total_num_bots_wanted < 0 )
			{
				// Need to remove bots.  First try to remove them from the ally team, then if that doesn't do it, the enemy team as well
				num_of_bots_to_drop = total_num_bots_wanted * -1;
							
				ally_bots_wanted = -1 * INT(min(num_of_bots_to_drop,cur_num_ally_bots));
				enemy_bots_wanted = -1 * (num_of_bots_to_drop + ally_bots_wanted);
			}
		}
		else if ( ally_bots_wanted * enemy_bots_wanted < 0 && gameFlag("prematch_done") && !IsDefined(level.bots_disable_team_switching) )
		{
			// ally_bots_wanted and enemy_bots_wanted are both nonzero and have opposite signs.
			// This means one team needs to gain players and one needs to lose them.  So move bots from one team to the other.
			difference = INT(min(abs(ally_bots_wanted),abs(enemy_bots_wanted)));
			
			if ( ally_bots_wanted > 0 )
				move_bots_from_team_to_team( difference, team_enemy, team_ally );
			else if ( enemy_bots_wanted > 0 )
				move_bots_from_team_to_team( difference, team_ally, team_enemy );
			
			need_to_spawn_or_drop = false;
		}
		
		if ( need_to_spawn_or_drop )
		{
			// Spawn or drop bots for teams that are under / over the limit
			if ( enemy_bots_wanted < 0 )
			{
				drop_bots( enemy_bots_wanted * -1, team_enemy );
			}
			if ( ally_bots_wanted < 0 )
			{
				drop_bots( ally_bots_wanted * -1, team_ally );
			}
			
			if ( enemy_bots_wanted > 0 )
			{
				spawn_bots( enemy_bots_wanted, team_enemy );
			}
			if ( ally_bots_wanted > 0 )
			{
				spawn_bots( ally_bots_wanted, team_ally );
			}
		}
	
		wait(bot_connect_monitor_update_time);
	}
}

bot_get_team_limit()
{
	return INT(bot_get_client_limit()/2);
}

bot_get_client_limit()
{
	// FIXME : this needs to be set via some gametype or UI value
	return 12;
}

bot_client_counts()
{
	clientCounts = [];
	
	foreach ( player in level.players )
	{
		if ( IsDefined(player) )
		{
			clientCounts = cat_array_add( clientCounts, "all" );
			clientCounts = cat_array_add( clientCounts, player.pers["team"] );
			if ( IsBot( player ) )
			{
				clientCounts = cat_array_add( clientCounts, "bots" );
				clientCounts = cat_array_add( clientCounts, "bots_" + player.pers["team"] );
			}
			else
			{
				clientCounts = cat_array_add( clientCounts, "humans" );
				clientCounts = cat_array_add( clientCounts, "humans_" + player.pers["team"] );
			}
		}
	}
	
	return clientCounts;
}

cat_array_add( arrayCounts, category )
{
	if ( !IsDefined( arrayCounts ) )
	{
		arrayCounts = [];
	}
	
	if ( !IsDefined( arrayCounts[ category ] ) )
	{
		arrayCounts[ category ] = 0;
	}

	arrayCounts[ category ] = arrayCounts[ category ] + 1;
	
	return arrayCounts;
}

cat_array_get( arrayCounts, category )
{
	if ( !IsDefined( arrayCounts ) )
	{
		return 0;
	}
	
	if ( !IsDefined( arrayCounts[ category ] ) )
	{
		return 0;
	}

	return arrayCounts[ category ];
}

//========================================================
//				move_bots_from_team_to_team 
//========================================================
move_bots_from_team_to_team( count, teamFrom, teamTo )
{
	foreach ( player in level.players )
	{
		if ( IsDefined( player.connected ) && player.connected && IsBot( player ) && player.pers["team"] == teamFrom )
		{
			player.bot_team = teamTo;
			player [[level.onTeamSelection]]( teamTo );
			player notify( "menuresponse", "changeclass", player.bot_class );
			count--;
			
			if ( count <= 0 )
				break;
			else
				wait(0.1);
		}
	}
}

//========================================================
//				drop_bots 
//========================================================
drop_bots( count, team )
{
	while ( count > 0 )
	{
		foreach ( player in level.players )
		{
			if ( IsDefined( player.connected ) && player.connected && IsBot( player ) && 
			    (!IsDefined( team ) || player.pers["team"] == team) )
			{
				kick( player.entity_number, "EXE_PLAYERKICKED_BOT_BALANCE" );
				wait 0.1;
				break;
			}
		}
		
		count--;
	}	
}

//========================================================
//					spawn_bots 
//========================================================
spawn_bots( num_bots, team, botCallback )
{
	function_start_time = GetTime();
	bots_spawned = 0;
	
	while( bots_spawned < num_bots && GetTime() < function_start_time + 10000 ) // don't want to be stuck in this function forever
 	{
 		wait( 0.25 );
 		bot = AddTestClient();
 
 		if ( !IsDefined( bot ) )
 		{
	 		wait( 1 );	
 			continue;
 		}
 		
 		bots_spawned++;
 		
 		if ( !IsBot( bot ) )
 		{
 			print("Spawned a test client rather than a bot, so not running AI on it");
 			
 			continue;
 		}
 		
        bot.pers["isBot"] = true;
 		bot.equipment_enabled = true;
 		bot.bot_team = team;
 		
 		if( IsDefined(botCallback) )
 		{
 			bot [[botCallback]]();
 		}
 		
 		bot thread [[ level.bot_funcs["think"] ]]();
  	}
}


//========================================================
//					bot_think 
//========================================================
bot_think( )
{
	self notify( "bot_think" );
	self endon( "bot_think" );
	
	self endon( "disconnect" );
	
	while( !IsDefined( self.pers["team"] ) )
	{
		wait( 0.05 );
	}
	
	level.hasbots = true;
	
	team = self.bot_team;

	if ( !IsDefined( team ) )
	{
		team = self.pers["team"];
	}	

	maps\mp\bots\_bots_ks::bot_killstreak_setup();
	
	self.can_use_crate_callback = level.bot_funcs["can_use_crate"];
	
	self.entity_number = self GetEntityNumber();
		
	firstSpawn = false;
	
	if ( !isDefined( self.bot_spawned_before ) )
	{
		firstSpawn = true;
		
		self.bot_spawned_before = true;
		
		self notify( "menuresponse", game["menu_team"], team );
		
		wait( 0.5 );
	}

	while( true )
	{
		// Balance personalities unless we are restricting them based on difficulty
		allowAdvPersonality = bot_get_persistent_value( "advancedPersonality" );
		if ( firstSpawn && IsDefined( allowAdvPersonality ) && allowAdvPersonality != 0 )
	 		self bot_balance_personality();

 		/#
		debug_personality = GetDvar( "bot_debugPersonality", "default" );
	 		
	 	if( debug_personality != "default" )
	 		self bot_set_personality( debug_personality );
	 	#/
	 		
		self bot_assign_personality_functions();

 		if ( firstSpawn )
		{
 			if ( IsDefined( self.personality_class_function ) )
 				self.bot_class = [[ self.personality_class_function ]]();
 			else
 				self.bot_class = [[ level.bot_pers_class["default"] ]](); // class_choose_default()
			self notify( "menuresponse", "changeclass", self.bot_class );
			self waittill( "spawned_player" );
			if ( IsDefined( level.bot_funcs ) && IsDefined( level.bot_funcs["know_enemies_on_start"] ) )
				self thread [[ level.bot_funcs["know_enemies_on_start"] ]]();
			firstSpawn = false;
		}
				
		self bot_restart_think_threads();
		
		wait( 0.10 );
		
		self waittill( "death" );
	}
}

default_can_use_crate()
{
	return false;
}


//========================================================
//					bot_wait_for_player 
//========================================================
bot_wait_for_player( allowSpectator )
{	
	player = get_human_player();
	
	if ( !IsDefined( allowSpectator ) )
		allowSpectator = false;
		
	while( !IsDefined( player ) || 
	       !IsDefined( player.pers[ "team" ] ) || 
	       (!allowSpectator && player.pers[ "team" ] != "allies" && player.pers[ "team" ] != "axis") )
	{
		wait( 0.05 );
		player = get_human_player();
	}

	return player;
}


//========================================================
//					get_human_player 
//========================================================
get_human_player()
{
	result = undefined;
	
	players = getEntArray( "player", "classname" );

	if ( IsDefined( players ) )
	{
		for( index = 0; index < players.size; index++ )
		{
			if( IsDefined( players[index] ) && IsDefined( players[index].connected ) && players[index].connected &&
			    !IsAI( players[index] ) && (!IsDefined( result ) || result.pers[ "team" ] == "spectator") )
			{
				result = players[index];
			}
		}
	}
	
	return result;
}

/#
get_all_humans()
{
	humans = [];
	
	foreach ( player in level.players )
	{
		if ( player.connected && !IsAI( player ) )
			humans = array_add( humans, player );
	}
	
	return humans;
}

spectators_exist()
{
	humans = get_all_humans();
	
	foreach( player in humans )
	{
		if ( player.team == "spectator" )
			return true;
	}
	
	return false;
}
#/

//========================================================
//					bot_damage_callback 
//========================================================
bot_damage_callback( eAttacker, iDamage, sMeansOfDeath, sWeapon, eInflictor, sHitLoc )
{
 	if( !IsDefined( self ) || !IsAlive( self ) )
 	{
 		return;
 	}
 
 	if( sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE" )
 	{
 		return;
 	}
 
 	if( iDamage <= 0 )
 	{
 		return;
 	}
 
 	if ( !IsDefined( eInflictor ) )
 	{
 		if ( !IsDefined( eAttacker ) )
 			return;
 		
 		eInflictor = eAttacker;
 	}
  
 	if ( IsDefined( eInflictor ) )
 	{
 		if ( level.teamBased )
 		{
 			if ( IsDefined( eInflictor.team ) && eInflictor.team == self.team )
 				return;
 			else if ( IsDefined( eAttacker ) && IsDefined( eAttacker.team ) && eAttacker.team == self.team )
 				return;
 		}
 
 		attacker_ent = bot_get_attacker_entity( eAttacker, eInflictor );
 		self BotSetAttacker( attacker_ent );
 	}
}


//========================================================
//					on_bot_killed 
//========================================================
on_bot_killed( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId )
{
	self BotClearScriptEnemy();
	self BotClearScriptGoal();
}


//========================================================
//					bot_should_do_killcam 
//========================================================
bot_should_do_killcam()
{
/#
	if ( GetDvar("scr_game_spectatetype") == "2" )
	{
		if ( spectators_exist() )
		{
			return false;
		}
	}
#/
	
	skip_killcam_chance = 0.0;
	bot_difficulty = self BotGetDifficulty();
	
	if ( bot_difficulty == "recruit" )
	{
		skip_killcam_chance = 0.1;
	}
	else if ( bot_difficulty == "regular" )
	{
		skip_killcam_chance = 0.4;
	}
	else if ( bot_difficulty == "hardened" )
	{
		skip_killcam_chance = 0.7;
	}   
	else if ( bot_difficulty == "veteran" )
	{
		skip_killcam_chance = 1.0;
	}
	
	return (RandomFloat(1.0) < (1.0-skip_killcam_chance));
}


//========================================================
//					bot_should_pickup_weapons 
//========================================================
bot_should_pickup_weapons()
{
	return true;
}


//========================================================
//					bot_is_idle 
//========================================================
bot_is_idle()
{
	if( !IsDefined( self ) )
	{
		return false;
	}

	if( !IsAlive( self ) )
	{
		return false;
	}

	if( IsDefined( self.laststand ) && self.laststand == true )
	{
		return false;
	}

	if( self BotGetScriptGoalType() != "none" )
	{
		return false;
	}

	return true;
}


//========================================================
//					bot_restart_think_threads 
//========================================================
bot_restart_think_threads()
{
	self thread bot_think_watch_enemy();
	self thread bot_think_tactical_goals();
	self thread bot_think_seek_dropped_weapons();
	self thread bot_think_crate();
	self thread bot_think_crate_blocking_path();
	self thread bot_think_player_blocking_path();
	self thread bot_think_revive();
	self thread bot_think_killstreak();
	self thread bot_think_watch_aerial_killstreak();
	self thread bot_think_gametype();
}

//========================================================
//					bot_think_watch_enemy 
//========================================================
bot_think_watch_enemy()
{
	self notify( "bot_think_watch_enemy" );
	self endon(  "bot_think_watch_enemy" );
		
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	// This function is for any logic that needs to be updated each frame regarding the enemy
	self.last_enemy_sight_time = GetTime();
	
	while( true )
	{
		if ( IsDefined( self.enemy ) )
		{
			if ( self BotCanSeeEntity( self.enemy ) )
			{
				self.last_enemy_sight_time = GetTime();
			}
		}
		
		wait(0.05);
	}
}

//========================================================
//					bot_think_dropped_weapons 
//========================================================
bot_think_seek_dropped_weapons()
{
	self notify( "bot_think_seek_dropped_weapons" );
	self endon(  "bot_think_seek_dropped_weapons" );
		
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	while( true )
	{
		still_seeking_weapon = false;
		
		if ( self bot_get_total_gun_ammo() == 0 && self [[level.bot_funcs["should_pickup_weapons"]]]() )
		{
			dropped_weapons = GetEntArray("dropped_weapon","targetname");
			dropped_weapons_sorted = get_array_of_closest(self.origin,dropped_weapons);
			if ( dropped_weapons_sorted.size > 0 )
			{
				dropped_weapon = dropped_weapons_sorted[0];
				
				if ( self bot_has_tactical_goal( "seek_dropped_weapon", dropped_weapon ) == false )
				{
					needs_to_pickup_weapon = true;
					heldweapons = self GetWeaponsListPrimaries();
					foreach ( held_weapon in heldweapons )
					{
						if ( dropped_weapon.model == GetWeaponModel(held_weapon) )
						{
							needs_to_pickup_weapon = false;
						}
					}

					action_thread = undefined;
					if ( needs_to_pickup_weapon )
						action_thread = ::bot_pickup_weapon;
					
					extra_params = SpawnStruct();
					extra_params.object = dropped_weapon;
					extra_params.script_goal_radius = 12;
					extra_params.should_abort = ::should_stop_seeking_weapon;
					extra_params.action_thread = action_thread;
					self bot_new_tactical_goal( "seek_dropped_weapon", dropped_weapon.origin, 100, extra_params );
				}
			}
		}
		
		wait(0.25);
	}
}

bot_pickup_weapon( goal )
{
	self BotPressUseButton(2);
	wait(2);	
}

should_stop_seeking_weapon( goal )
{
	// goal.object is the dropped weapon
	
	if ( self bot_get_total_gun_ammo() > 0 )
		return true;
	
	if ( !IsDefined( goal.object ) )
		return true;
	
	return false;
}

//========================================================
//					bot_think_crate 
//========================================================
bot_think_crate()
{
	self notify( "bot_think_crate" );
	self endon(  "bot_think_crate" );
		
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	while( true )
	{
		wait( randomfloatrange( 2, 4 ) );

		if ( !self bot_is_idle() && !self bot_can_use_crate_when_notidle() )
		{
			continue;
		}

		all_crates = GetEntArray( "care_package", "targetname" );
		
		// Early out if we didn't find any crates
		if ( all_crates.size == 0 )
		{
			continue;
		}
		
		if ( bot_has_tactical_goal( "airdrop_crate" ) )
		{
			continue;
		}
		
		all_valid_crates = [];
		foreach ( crate in all_crates )
		{
			wait(0.05);	// don't do all the traces on the same frame
			
			if ( !IsDefined( crate ) )
			{
				continue;
			}
			
			// Ignore any crate that is still falling
			if ( !IsDefined( crate.droppingToGround ) || crate.droppingToGround )
			{
				continue;
			}
			
			// Ignore any crate that is a trap for the other team
			if ( level.teamBased && IsDefined( crate.bomb ) && IsDefined( crate.team ) && (crate.team == self.team) )
			{
				continue;
			}

			// If I didn't call in this crate...
			if ( !IsDefined( crate.owner ) || (crate.owner != self) )
			{
				// Ignore it if it is greater than 2048 distance away
				if ( DistanceSquared( self.origin, crate.origin ) > 2048 * 2048 )
				{
					continue;
				}
			}
						
			// Ignore any crate that is off the path grid
			nodes_around_crate = GetNodesInRadiusSorted( crate.origin, 256, 0, 50 );
			if ( nodes_around_crate.size == 0 )
			{
				continue;
			}
			
			if ( !BulletTracePassed( crate.origin + (0,0,10), nodes_around_crate[0].origin, false, crate ) )
			{
				continue;
			}
			
			all_valid_crates[all_valid_crates.size] = crate;
		}
		
		// We didn't find any valid crates to take
		if ( all_valid_crates.size == 0 )
			continue;
		
		// Sort the array
		Assert( IsDefined(self) );
		all_valid_crates = array_removeUndefined( all_valid_crates );
		all_valid_crates = get_array_of_closest( self.origin, all_valid_crates );
		
		// First check for the closest crate the bot can see (ignoring current FOV)
		crate_to_take = undefined;
		foreach ( crate in all_valid_crates )
		{
			wait(0.05);	// don't do all the traces on the same frame
			if ( IsDefined(crate) )	// need to check here since it might have gone undefined during the wait
			{
				if ( SightTracePassed( self GetEye(), crate.origin, false, self, crate ) )
				{
					crate_to_take = crate;
					break;
				}
			}
		}

		// Couldn't see any crates, so 50% chance to take the closest one to me that isnt claimed
		if ( !IsDefined( crate_to_take ) && RandomInt(100) < 50 )
		{
			foreach ( crate in all_valid_crates )
			{
				if ( !IsDefined( crate.bots ) || !IsDefined( crate.bots[self.team] ) || crate.bots[self.team] == 0 )
				{
					crate_to_take = crate;
					break;
				}
			}
		}
		
		if ( IsDefined( crate_to_take ) )
		{
			// Claim this crate
			if ( !IsDefined( crate_to_take.bots ) )
			{
				crate_to_take.bots = [];
			}
			crate_to_take.bots[self.team] = 1;
			
			extra_params = SpawnStruct();
			extra_params.object = crate_to_take;
			extra_params.script_goal_radius = 100;
			extra_params.start_thread = ::watch_bot_died_during_crate;
			extra_params.end_thread = ::stop_using_crate;
			extra_params.should_abort = ::crate_picked_up;
			extra_params.action_thread = ::use_crate;
			self bot_new_tactical_goal( "airdrop_crate", crate_to_take.origin + (0,0,24), 30, extra_params );
		}
	}
}

crate_picked_up( goal )
{
	// goal.object is the crate
	
	if ( !IsDefined( goal.object ) )
		return true;

	return false;
}

use_crate( goal )
{
	// goal.object is the crate
	
	// crate.owner doesn't have to exist.  But if it does, and this bot is the owner, use the shorter amount of time
	if ( IsDefined(goal.object.owner) && goal.object.owner == self )
	{
		time = level.crateOwnerUseTime / 1000 + 0.5;
	}
	else
	{
		time = level.crateNonOwnerUseTime / 1000 + 1.0;
	}
	
	self BotPressUseButton( time );
	wait( time );
}

watch_bot_died_during_crate( goal )
{
	// goal.object is the crate
	
	self thread bot_watch_for_death( goal.object );
}

stop_using_crate( goal )
{
	// goal.object is the crate
	
	if ( IsDefined( goal.object ) )
	{
		goal.object.bots[self.team] = 0;
	}
}

bot_can_use_crate_when_notidle()
{
	return self [[self.can_use_crate_callback]]();
}


//========================================================
//				bot_watch_for_death 
//========================================================
bot_watch_for_death( object )
{
	object endon( "death" );
	object endon( "revived" );
	object endon( "disconnect" );

	level endon( "game_ended" );

	prev_team = self.team;
	self waittill_any( "death", "disconnect" );
	if ( IsDefined(object) )
	{
		object.bots[prev_team] = 0;
	}
}


//========================================================
//			bot_think_player_blocking_path 
//========================================================
bot_think_player_blocking_path()
{
	self notify( "bot_think_player_blocking_path" );
	self endon(  "bot_think_player_blocking_path" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( true )
	{
		// Wait for 2 touches of the same ally over 2 frames to consider the other player blocking me
		self waittill( "touch", firstOther );
		firstTime = GetTime();
		self waittill( "touch", other );		
		if ( GetTime() - firstTime < 100 && firstOther == other )
		{
			if ( IsDefined( other ) && IsPlayer( other ) && other.team == self.team )
			{
				// Move away from the ally we just bumped into for a short time
				// Make sure bots make the same decision about which way to move out
				yawMove = VectorToYaw( self.origin - other.origin );
				self.bot_player_block_choice = RandomInt( 2 );
				self.bot_player_block_time = GetTime();
				if ( IsDefined( other.bot_player_block_time ) && ( ( GetTime() - other.bot_player_block_time ) < 100 ) )
				{
					choice = other.bot_player_block_choice;
				}
				else
				{
					choice = self.bot_player_block_choice;
				}
				
				if ( choice == 0 )
				{
					yawMove = yawMove + RandomFloatRange( 25, 45 );
				}
				else
				{
					yawMove = yawMove - RandomFloatRange( 25, 45 );
				}
				
				// Only bots that are stationary should get this forced move, otherwise we just let them resolve it by sliding off of eachother.
				if ( LengthSquared( self GetVelocity() ) < 50 )
				{
					self BotSetScriptMove( yawMove, 0.5 );
				}
			}
		}
		wait 0.05;
	}	
}


//========================================================
//			bot_think_crate_blocking_path 
//========================================================
bot_think_crate_blocking_path()
{
	self notify( "bot_think_crate_blocking_path" );
	self endon(  "bot_think_crate_blocking_path" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	radius = GetDvarFloat( "player_useRadius" );

	// ensure bots don't get stuck on crates
	while( true )
	{
		wait( 3 );

		if( self UseButtonPressed() )
		{
			continue;
		}

		crates = GetEntArray( "care_package", "targetname" );

		for ( i = 0; i < crates.size; i++ )
		{
			crate = crates[i];

			if( DistanceSquared( self.origin, crate.origin ) < radius * radius )
			{
				if ( crate.owner == self )
				{
					self BotPressUseButton( level.crateOwnerUseTime / 1000 + 0.5 );
				}
				else
				{
					self BotPressUseButton( level.crateNonOwnerUseTime / 1000 + 0.5 );
				}
			}
		}
	}
}

//========================================================
//					bot_think_revive 
//========================================================
bot_think_revive()
{
	self notify( "bot_think_revive" );
	self endon(  "bot_think_revive" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	if( !level.teamBased )
	{
		return;
	}

	while( true )
	{
		wait( randomintrange( 3, 5 ) );

		if( !self bot_can_revive() )
		{
			continue;
		}

		revive_triggers = GetEntArray( "revive_trigger", "targetname" );
		for( i = 0; i < revive_triggers.size; i++ )
		{
			revive_trigger = revive_triggers[i];
			player = revive_trigger.owner;

			if( !IsDefined( player) )
			{
				continue;
			}

			if( player == self )
			{
				continue;
			}

			if( !IsAlive( player ) )
			{
				continue;
			}

			if( player.team != self.team )
			{
				continue;
			}

			if( !IsDefined( player.inLastStand ) || !player.inLastStand )
			{
				continue;
			}

			if ( IsDefined( player.bots ) && IsDefined( player.bots[self.team] ) && player.bots[self.team] > 0 )
			{
				continue;
			}
			
			if( DistanceSquared( self.origin, player.origin ) < 2048 * 2048 )
			{
				extra_params = SpawnStruct();
				extra_params.object = player;
				extra_params.script_goal_radius = 100;
				extra_params.start_thread = ::watch_bot_died_during_revive;
				extra_params.end_thread = ::stop_reviving;
				extra_params.should_abort = ::player_revived_or_dead;
				extra_params.action_thread = ::revive_player;
				self bot_new_tactical_goal( "revive", player.origin, 60, extra_params );
				break;
			}
		}
	}
}

watch_bot_died_during_revive( goal )
{
	// goal.object is the player to revive
	
	self thread bot_watch_for_death( goal.object );
}

stop_reviving( goal )
{
	// goal.object is the player to revive
	
	if ( IsDefined( goal.object ) )
	{
		goal.object.bots[self.team] = 0;
	}
}

player_revived_or_dead( goal )
{
	// goal.object is the player to revive
	
	if ( !IsDefined( goal.object ) || goal.object.health <= 0 )
		return true;
	
	if ( !IsDefined( goal.object.inLastStand ) || !goal.object.inLastStand )
		return true;

	return false;
}

revive_player( goal )
{
	// goal.object is the player to revive
	
	prev_team = self.team;
	self BotPressUseButton( level.lastStandUseTime / 1000 + 0.5 );
	wait( level.lastStandUseTime / 1000 + 1.5 );
	
	if ( IsDefined(goal.object) )
		goal.object.bots[prev_team] = 0;
}


//========================================================
//					bot_can_revive 
//========================================================
bot_can_revive()
{
	if( !IsDefined( self ) )
	{
		return false;
	}

	if( !IsAlive( self ) )
	{
		return false;
	}

	if( IsDefined( self.laststand ) && self.laststand == true )
	{
		return false;
	}
	
	if ( self bot_has_tactical_goal( "revive" ) )
	{
		return false;	
	}

	goalType = self BotGetScriptGoalType();
	if( goalType != "none" && goalType != "guard" && goalType != "hunt" )
	{
		return false;
	}

	return true;
}


//========================================================
//				revive_watch_for_finished 
//========================================================
revive_watch_for_finished( player )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "bad_path" );
	self endon( "goal" );

	player waittill_any( "death", "revived" );
	self notify( "bad_path" );
}

//========================================================
//			bot_know_enemies_on_start
//========================================================
bot_know_enemies_on_start()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	// Wait till grace period is over, then let this bot know where enemies are
	// (this is intended for the beginning of a match to get them seeking out enemies based on "knowledge" of the map start spots)
	if ( GetTime() > 15000 ) 
		return;
	
	while ( !gameHasStarted() || !gameFlag( "prematch_done" ) )
	{
		wait 0.05;
	}

	chosenEnemy = undefined;	
	chosenEnemyKnowSelf = undefined;

	for ( enemyIdx = 0; enemyIdx < level.players.size; enemyIdx++ )
	{
		otherPlayer = level.players[enemyIdx];
		if ( IsDefined( otherPlayer ) && IsEnemyTeam( self.team, otherPlayer.team ) )
		{
			if ( !IsDefined( otherPlayer.bot_start_known_by_enemy ) )
				chosenEnemy = otherPlayer;
			
			if ( IsAI( otherPlayer ) && !IsDefined( otherPlayer.bot_start_know_enemy ) )
				chosenEnemyKnowSelf = otherPlayer;
		}
	}
	
	if ( IsDefined( chosenEnemy ) )
	{
		self.bot_start_know_enemy = true;
		chosenEnemy.bot_start_known_by_enemy = true;
		self GetEnemyInfo( chosenEnemy );		
	}
	
	if ( IsDefined( chosenEnemyKnowSelf ) )
	{
		chosenEnemyKnowSelf.bot_start_know_enemy = true;
		self.bot_start_known_by_enemy = true;
		chosenEnemyKnowSelf GetEnemyInfo( self );		
	}
}

//========================================================
//			bot_make_entity_sentient
//========================================================
bot_make_entity_sentient( team )
{
	return self MakeEntitySentient( team );
}

//========================================================
//			bot_think_gametype
//========================================================
bot_think_gametype()
{
	self notify( "bot_think_gametype" );
	self endon(  "bot_think_gametype" );
	
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	gameFlagWait( "prematch_done" );
	
	self thread [[ level.bot_funcs["gametype_think"] ]]();
}

default_gametype_think()
{
	// do nothing
}

//========================================================
//			bot_setup_appearance
//========================================================
bot_setup_appearance( bodyId, headId )
{
	// TEMP: testing what people think of a unique appearance for bots
	self Detach( self.headModel, "" );
	self SetModel( "robot_test_mp" );	
	self Attach( "head_mp_test_robot", "", true );
	self.headModel = "head_mp_test_robot";
}