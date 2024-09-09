// Helper functions for bots

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\bots\_bots_personality;
#include maps\mp\bots\_bots_strategy;

/*
=============
///ScriptDocBegin
"Name: bot_get_nodes_in_cone( <max_dist> , <vector_dot> , <only_visible_nodes> )"
"Summary: Gets all nodes in the cone in front of the bot, up to max dist and obeying vector_dot"
"CallOn: A bot player"
"MandatoryArg: <max_dist>: Max dist of cone"
"MandatoryArg: <vector_dot>: Nodes within this vector dot of the bot's direction will be in cluded"
"MandatoryArg: <only_visible_nodes>: Only return nodes visible to the bot"
"Example: "
///ScriptDocEnd
=============
*/
bot_get_nodes_in_cone( max_dist, vector_dot, only_visible_nodes )
{
	nodes_around_bot = GetNodesInRadius( self.origin, max_dist, 0 );
	nodes_in_cone = [];
	
	nearest_node_to_bot = self BotGetNearestNode();
	bot_dir = AnglesToForward( self GetPlayerAngles() );
	bot_dir_norm = VectorNormalize( bot_dir * (1,1,0) );
	
	foreach( node in nodes_around_bot )
	{
		bot_to_node_norm = VectorNormalize( (node.origin - self.origin) * (1,1,0) );
		dot = VectorDot( bot_to_node_norm, bot_dir_norm );
		if ( dot > vector_dot )
		{
			if ( !only_visible_nodes || NodesVisible( node, nearest_node_to_bot, true ) )
			    nodes_in_cone = array_add( nodes_in_cone, node );
		}
	}
	
	return nodes_in_cone;
}

/* 
=============
///ScriptDocBegin
"Name: bot_goal_can_override( <goal_type_1>, <goal_type_2> )"
"Summary: Returns true if goal_type_1 can override goal_type_2"
"CallOn: A bot player"
"MandatoryArg: <goal_type_1> : The goal to test"
"MandatoryArg: <goal_type_2> : The goal to test against"
"Example: can_override_goal = bot_goal_can_override( goal_type, current_goal_type );"
///ScriptDocEnd
============
 */
bot_goal_can_override( goal_type_1, goal_type_2 )
{
	if ( goal_type_1 == "none" )
	{
		// "none" can only override "none"
		return (goal_type_2 == "none");
	}
	else if ( goal_type_1 == "hunt" )
	{
		// "hunt" can override "hunt" or "none"
		return (goal_type_2 == "hunt" || goal_type_2 == "none");
	}
	else if ( goal_type_1 == "guard" )
	{
		// "guard" can override "guard", "hunt", or "none"
		return (goal_type_2 == "guard" || goal_type_2 == "hunt" || goal_type_2 == "none");
	}
	else if ( goal_type_1 == "objective" )
	{
		// "objective" can override "objective", "guard", "hunt", or "none"
		return (goal_type_2 == "objective" || goal_type_2 == "guard" || goal_type_2 == "hunt" || goal_type_2 == "none");
	}
	else if ( goal_type_1 == "critical" )
	{
		// "critical" can override "critical", "objective", "guard", "hunt", or "none"
		return (goal_type_2 == "critical" || goal_type_2 == "objective" || goal_type_2 == "guard" || goal_type_2 == "hunt" || goal_type_2 == "none");
	}
	else if ( goal_type_1 == "tactical" )
	{
		// "tactical" can override everything
		return true;
	}
	
	AssertEx( false, "Unsupported parameter <goal_type_1> passed in to bot_goal_can_override()" );
}

/* 
=============
///ScriptDocBegin
"Name: bot_set_personality()"
"Summary: Sets the personality for this bot.  Necessary because script needs to re-assign function pointers, etc."
"CallOn: A bot player"
"Example: self bot_set_personality("camper")"
///ScriptDocEnd
============
 */
bot_set_personality(personality)
{
	self BotSetPersonality( personality );
	self bot_assign_personality_functions();
}

/* 
=============
///ScriptDocBegin
"Name: bot_is_defending()"
"Summary: Checks if this bot is defending"
"CallOn: A bot player"
"Example: if ( self bot_is_defending() )"
///ScriptDocEnd
============
 */
bot_is_defending()
{
	return ( IsDefined( self.bot_defending ) );
}

/* 
=============
///ScriptDocBegin
"Name: bot_is_defending_point( <point> )"
"Summary: Checks if this bot is defending a specific point"
"CallOn: A bot player"
"MandatoryArg: <point> : The point to check"
"Example: if ( !self bot_is_defending_point(level.sdBombModel.origin) )"
///ScriptDocEnd
============
 */
bot_is_defending_point(point)
{
	if ( self bot_is_defending() )
	{
		if ( DistanceSquared(self.bot_defending_center,point) < 10 )
		{
			return true;
		}
	}
	
	return false;
}

/* 
=============
///ScriptDocBegin
"Name: bot_is_guarding_player( <player> )"
"Summary: Checks if this bot is guarding a specific player"
"CallOn: A bot player"
"MandatoryArg: <player> : The player to check"
"Example: if ( !self bot_is_guarding_player( self.owner ) )"
///ScriptDocEnd
============
 */
bot_is_guarding_player( player )
{
	if ( self bot_is_defending() )
	{
		if ( self.bot_defending_type == "bodyguard" && self.bot_defend_player_guarding == player )
		{
			return true;
		}
	}
	
	return false;
}

/* 
=============
///ScriptDocBegin
"Name: bot_get_all_players_and_agents()"
"Summary: Returns all players and active game participant agents"
"Example: players = bot_get_all_players_and_agents();"
///ScriptDocEnd
============
 */
bot_get_all_players_and_agents()
{
	agents = [];
	if ( isDefined( level.agentArray ) )
    {
		foreach( agent in level.agentArray )
		{			
			if ( agent.isActive && IsGameParticipant( agent ) )
				agents = array_add( agents, agent );
		}
    }
	
	return array_combine( agents, level.players );
}

/* 
=============
///ScriptDocBegin
"Name: bot_notify_on_lost_enemy( <event_to_trigger> )"
"Summary: Waits for the bot to have an enemy, and then to have no enemy for any reason then triggers the event name provided"
"CallOn: A bot player"
"MandatoryArg: <event_to_trigger> : The event name to notify"
"Example: self thread bot_notify_on_lost_enemy( "lost_enemy" );"
///ScriptDocEnd
============
 */
bot_notify_on_lost_enemy( eventTrigger )
{
	// only one of these can be active at once
	self notify( "bot_notify_on_lost_enemy" );
	self endon( "bot_notify_on_lost_enemy" );
	
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	for(;;)
	{
		// First wait till we HAVE an enemy
		if ( !IsDefined( self.enemy ) )
			self waittill( "enemy" );
		if ( IsDefined( self.enemy ) )
			break;
	}
	
	for(;;)
	{
		// Then wait till we lose it
		self waittill( "enemy" );
		if ( !IsDefined( self.enemy ) )
		{
			self notify( eventTrigger );
			return;
		}
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_cache_entrances_to_bombzones()"
"Summary: Caches entrance points using the level.bombZones array"
"Example: bot_cache_entrances_to_bombzones();"
///ScriptDocEnd
============
 */
bot_cache_entrances_to_bombzones()
{
	assert( IsDefined(level.bombZones) );

	entrance_origin_points = [];
	entrance_labels = [];
	
	index = 0;
	foreach( zone in level.bombZones )
	{
		entrance_origin_points[index] = zone.botTarget.origin;
		entrance_labels[index] = "zone" + zone.label;
		index++;
	}
	
	bot_cache_entrances( entrance_origin_points, entrance_labels );	
}

/* 
=============
///ScriptDocBegin
"Name: bot_cache_entrances_to_flags_or_radios()"
"Summary: Caches entrance points using the flags or radios array (or any array accessed with .origin and .script_label)"
"MandatoryArg: <array> : An array of objects.  They must have member variables .origin and .script_label"
"MandatoryArg: <label_prefix> : Prefix to use for indices in the level.entrance_points array"
"Example: bot_cache_entrances_to_flags_or_radios( level.flags, "flag" );"
///ScriptDocEnd
============
 */
bot_cache_entrances_to_flags_or_radios( array, label_prefix )
{
	assert( IsDefined(array) );
	
	entrance_origin_points = [];
	entrance_labels = [];
	
	for ( i = 0; i < array.size; i++ )
	{
		if ( IsDefined(array[i].botTarget) )
		{
			entrance_origin_points[i] = array[i].botTarget.origin;
		}
		else
		{
			closest_nodes = GetNodesInRadiusSorted( array[i].origin, 128, 0 );
			if ( IsDefined(closest_nodes) && closest_nodes.size > 0 )
				entrance_origin_points[i] = closest_nodes[0].origin;
			else
				entrance_origin_points[i] = array[i].origin;
		}
		entrance_labels[i] = label_prefix + array[i].script_label;
	}
	
	bot_cache_entrances( entrance_origin_points, entrance_labels );
}

/* 
=============
///ScriptDocBegin
"Name: entrance_visible_from( <entrance_origin>, <from_origin>, <stance> )"
"Summary: Checks if the specified <entrance_origin> is visible from the <from_origin> with the given <stance>"
"MandatoryArg: <entrance_origin> : Origin of the entrance node"
"MandatoryArg: <from_origin> : Origin to check visibility from"
"MandatoryArg: <stance> : The stance at the <from_origin> to check"
"Example: entrance.prone_visible_from[index] = entrance_visible_from( entrance.origin, origin_array[i], "prone" );"
///ScriptDocEnd
============
 */
entrance_visible_from( entrance_origin, from_origin, stance )
{
	assert( (stance == "stand") || (stance == "crouch") || stance == ("prone") );
	
	prone_offset = (0,0,11);
	crouch_offset = (0,0,40);
	
	offset = undefined;
	if ( stance == "stand" )
		return true;
	else if ( stance == "crouch" )
		offset = crouch_offset;
	else if ( stance == "prone" )
		offset = prone_offset;
	
	return SightTracePassed( from_origin+offset, entrance_origin+offset, false, undefined );
}

/* 
=============
///ScriptDocBegin
"Name: bot_cache_entrances( <origin_array>, <label_array> )"
"Summary: Uses the origin and label array to fill out level.entrance_points"
"MandatoryArg: <origin_array> : An array of origins (the points to find entrances for)"
"MandatoryArg: <label_array> : An array of labels (to use for indices into the entrances array)"
"Example: bot_cache_entrances( entrance_origin_points, entrance_labels );"
///ScriptDocEnd
============
 */
bot_cache_entrances( origin_array, label_array )
{
	assert( IsDefined(origin_array) );
	assert( IsDefined(label_array) );
	assert( origin_array.size > 0 );
	assert( label_array.size > 0 );
	assert( origin_array.size == label_array.size );
	
	wait(0.1);
	
	entrance_points = [];
	
	for ( i = 0; i < origin_array.size; i++ )
	{
		index = label_array[i];
		entrance_points[index] = FindEntrances( origin_array[i] );
		AssertEx( entrance_points[index].size > 0, "Entrance points for " + index + " at location " + origin_array[i] + " could not be calculated.  Check pathgrid around that area" );
		wait(0.05);
		
		for ( j = 0; j < entrance_points[index].size; j++ )
		{
			entrance = entrance_points[index][j];
			
			// Mark entrance as precalculated (to save checks in other places)
			entrance.is_precalculated_entrance = true;
			
			// Trace the entrance to determine prone visibility
			entrance.prone_visible_from[index] = entrance_visible_from( entrance.origin, origin_array[i], "prone" );
			wait(0.05);
			
			// Trace the entrance to determine crouch visibility
			entrance.crouch_visible_from[index] = entrance_visible_from( entrance.origin, origin_array[i], "crouch" );
			wait(0.05);
			
			// Initialize "on_path_from" arrays (so we can check them later without having to first check IsDefined)
			for ( k = 0; k < label_array.size; k++ )
			{
				for( l = k+1; l < label_array.size; l++ )
				{
					entrance.on_path_from[label_array[k]][label_array[l]] = 0;
					entrance.on_path_from[label_array[l]][label_array[k]] = 0;
				}
			}
		}
	}
	
	precalculated_paths = [];
	for ( i = 0; i < origin_array.size; i++ )
	{
		for ( j = i+1; j < origin_array.size; j++ )
		{
			// Find path from origin_array[i] to origin_array[j]
			path = get_extended_path( origin_array[i], origin_array[j] );
			AssertEx( IsDefined(path), "Error calculating path from " + label_array[i] + " " + origin_array[i] + " to " + label_array[j] + " " + origin_array[j] + ". Check pathgrid around those areas" );
			
			precalculated_paths[label_array[i]][label_array[j]] = path;
			precalculated_paths[label_array[j]][label_array[i]] = path;
			foreach( node in path )
			{
				node.on_path_from[label_array[i]][label_array[j]] = true;
				node.on_path_from[label_array[j]][label_array[i]] = true;
			}
		}
	}
	
	// Set the arrays here, so we don't get bots trying to access a partially-defined array while we're still filling it out
	level.precalculated_paths = precalculated_paths;
	level.entrance_origin_points = origin_array;
	level.entrance_indices = label_array;
	level.entrance_points = entrance_points;
	
	level.entrance_points_finished_caching = true;	// This line should be the last line in the function
}

/* 
=============
///ScriptDocBegin
"Name: node_is_on_path_from_origins( <start>, <end> )"
"Summary: Checks if the node contained in the path from the start to the end locations"
"MandatoryArg: <start> : The start location"
"MandatoryArg: <end> : The end location"
"Example: if ( node node_is_on_path_from_origins( origin_array[i], origin_array[j] ) )"
///ScriptDocEnd
============
 */
node_is_on_path_from_origins( start, end )
{
	path = get_extended_path( start, end );
	if ( IsDefined( path ) )
	{
		return ( array_contains( path, self ) );
	}
	
	return false;
}

/* 
=============
///ScriptDocBegin
"Name: get_extended_path( <start>, <end> )"
"Summary: Gets a "wider" path from start to end.  Includes all the nodes in the direct path, plus any nodes that are linked along the way"
"MandatoryArg: <start> : The start location"
"MandatoryArg: <end> : The end location"
"Example: path = get_extended_path( start, end );"
///ScriptDocEnd
============
 */
get_extended_path( start, end )
{
	path = GetNodesOnPath( start, end );
	if ( IsDefined( path ) )
	{
		path = remove_ends_from_path( path );
		path = get_all_connected_nodes( path );
	}
	
	return path;
}

/* 
=============
///ScriptDocBegin
"Name: node_is_on_path_from_labels( <label1>, <label2> )"
"Summary: Checks if the node is contained in the path from label1 to label2"
"Summary: The labels correspond to elements in the level.entrance_indices, which match up with origins in level.entrance_origin_points"
"MandatoryArg: <label1> :  The first label"
"MandatoryArg: <label2> :  The second label"
"Example: if ( node node_is_on_path_from_labels(self.current_flag, flag_complete_label) )"
///ScriptDocEnd
============
 */
node_is_on_path_from_labels( label1, label2 )
{
	if ( !IsDefined( self.on_path_from ) || !IsDefined( self.on_path_from[label1] ) || !IsDefined( self.on_path_from[label1][label2] ) )
	{
		point1_index = -1;
		point2_index = -1;
		for ( i = 0; i < level.entrance_indices.size; i++ )
		{
			if ( level.entrance_indices[i] == label1 )
				point1_index = i;
			
			if ( level.entrance_indices[i] == label2 )
				point2_index = i;
		}
		
		Assert( point1_index >= 0 && point2_index >= 0 );
		
		node_on_path = self node_is_on_path_from_origins( level.entrance_origin_points[point1_index], level.entrance_origin_points[point2_index] );
		self.on_path_from[label1][label2] = node_on_path;
		self.on_path_from[label2][label1] = node_on_path;
	}
	
	return self.on_path_from[label1][label2];	
}

/* 
=============
///ScriptDocBegin
"Name: get_all_connected_nodes( <nodes> )"
"Summary: Returns the array nodes and all nodes connected to them"
"MandatoryArg: <nodes> : The array of nodes"
"Example: all_nodes = get_all_connected_nodes(path);"
///ScriptDocEnd
============
 */
get_all_connected_nodes( nodes )
{
	all_nodes = nodes;
	
	for ( i = 0; i < nodes.size; i++ )
	{
		//bot_draw_cylinder(nodes[i].origin, 10, 20, 20, undefined, (0,0,1), true, 4);

		linked_nodes = GetNodeLinkedNodes( nodes[i] );
		for ( j = 0; j < linked_nodes.size; j++ )
		{
			if ( !array_contains( all_nodes, linked_nodes[j] ) )
			{
				all_nodes = array_add( all_nodes, linked_nodes[j] );
				
				//line( nodes[i].origin, linked_nodes[j].origin, (0,1,0), 1.0, true, 20*20 );
				//bot_draw_cylinder(linked_nodes[j].origin, 10, 10, 20, undefined, (0,1,0), true, 4);
			}
		}
	}
	
	return all_nodes;
}

/* 
=============
///ScriptDocBegin
"Name: get_visible_nodes_array( <nodes>, <node_from> )"
"Summary: Returns all nodes in the <nodes> array that are visible from <node_from> using node visibility"
"MandatoryArg: <nodes> : The array of nodes"
"MandatoryArg: <node_from> : The node we're looking from"
"Example: visible_nodes = get_visible_nodes_array( nodes, current_nearest_node );"
///ScriptDocEnd
============
 */
get_visible_nodes_array( nodes, node_from )
{
	visible_nodes = [];
	
	foreach( node in nodes )
	{
		if ( NodesVisible( node, node_from, true ) )
			visible_nodes = array_add( visible_nodes, node );
	}
	
	return visible_nodes;
}

/* 
=============
///ScriptDocBegin
"Name: remove_ends_from_path( <path> )"
"Summary: Removes the first and last node from the path and returns the resulting array"
"MandatoryArg: <path> : The array of nodes in the path"
"Example: path = remove_ends_from_path(path);"
///ScriptDocEnd
============
 */
remove_ends_from_path( path )
{
	path[path.size-1] = undefined;
	path[0] = undefined;

	return array_removeUndefined( path );
}

/* 
=============
///ScriptDocBegin
"Name: bot_waittill_bots_enabled()"
"Summary: Waits until bots are enabled (until bot_AutoConnectDefault is 1 or bots are added via the devgui)"
"Example: bot_waittill_bots_enabled();"
///ScriptDocEnd
============
 */
bot_waittill_bots_enabled()
{
	keep_looping = true;
	while(keep_looping)
	{
		if ( bot_bots_enabled_or_added() )
			keep_looping = false;
		
		wait(0.5);
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_bots_enabled_or_added()"
"Summary: Return true if bots are enabled (bot_AutoConnectDefault is 1 or bots have been added via the devgui)"
"Example: if ( bot_bots_enabled_or_added() )"
///ScriptDocEnd
============
 */
bot_bots_enabled_or_added()
{
	if ( BotAutoConnectEnabled() == 1 )
		return true;
	
	if ( bots_exist() )
		return true;
	
	return false;
}

/* 
=============
///ScriptDocBegin
"Name: bot_waittill_out_of_combat_or_time( <time> )"
"Summary: Waits until this bot is out of combat (or the time limit is reached), then returns"
"OptionalArg: <time> : The time (in ms) before we return"
"Example: self bot_waittill_out_of_combat_or_time();"
///ScriptDocEnd
============
 */
bot_waittill_out_of_combat_or_time( time )
{
	start_time = GetTime();
	
	while( 1 )
	{
		if ( IsDefined( time ) )
		{
			if ( GetTime() > start_time + time )
				return;
		}
		
		if ( !IsDefined(self.enemy) )
		{
			return;
		}
		else
		{
			if ( !self bot_in_combat() )
				return;
		}
		
		wait(0.05);
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_in_combat()"
"Summary: Checks if this bot is in combat (has seen an enemy recently)"
"Example: if ( self bot_in_combat() )"
///ScriptDocEnd
============
 */
bot_in_combat()
{
	time_since_last_saw_enemy = GetTime() - self.last_enemy_sight_time;
	return ( time_since_last_saw_enemy < level.bot_out_of_combat_time );
}

/* 
=============
///ScriptDocBegin
"Name: bot_waittill_goal_or_fail( <optional_time>, <optional_param_1>, <optional_param_2> )"
"Summary: Waits until this bot reaches his goal or is interrupted, and returns the result"
"Summary: By default this waits for "goal", "bad_path", "node_relinquished", and "goal_changed""
"OptionalArg: <optional_time> : The time (in seconds) before returning"
"OptionalArg: <optional_param_1> : An extra parameter to wait on"
"OptionalArg: <optional_param_2> : An extra parameter to wait on"
"Example: pathResult = self bot_waittill_goal_or_fail();"
///ScriptDocEnd
============
 */
bot_waittill_goal_or_fail( optional_time, optional_param_1, optional_param_2 )
{
	if ( !IsDefined(optional_param_1) && IsDefined(optional_param_2) )
	{
		AssertEx( false, "Error: Calling bot_waittill_goal_or_fail needs to define param 1 if using param 2" );
	}
	
	if ( IsDefined( optional_time ) )
	{
		result = self waittill_any_timeout( optional_time, "goal", "bad_path", "node_relinquished", "goal_changed", optional_param_1, optional_param_2 );
	}
	else
	{
		result = self waittill_any_return( "goal", "bad_path", "node_relinquished", "goal_changed", optional_param_1, optional_param_2 );
	}
	
	return result;
}

/* 
=============
///ScriptDocBegin
"Name: bot_usebutton_wait( <time>, <level_notify> )"
"Summary: Waits until this bot releases the use button, or the time expires, or the level is notified"
"OptionalArg: <time> : The time (in ms) before we return"
"OptionalArg: <level_notify> : Return if this is notified on the level"
"Example: self bot_usebutton_wait( time * 1000, "bomb_planted" );"
///ScriptDocEnd
============
 */
bot_usebutton_wait( time, level_notify )
{
	if ( IsDefined( level_notify ) )
		level endon(level_notify);
	
	time_to_end = undefined;
	if ( IsDefined(time) )
	{
		time_started = GetTime();
		time_to_end = time_started + time;
	}

	keep_looping = true;
	while( keep_looping )
	{
		wait(0.05);
		
		if ( !self UseButtonPressed() )
			keep_looping = false;
		
		if ( IsDefined(time_to_end) && GetTime() >= time_to_end )
			keep_looping = false;
	}
}

/* 
=============
///ScriptDocBegin
"Name: bots_exist()"
"Summary: Checks if bots exist in the level"
"Example: if ( bots_exist() )"
///ScriptDocEnd
============
 */
bots_exist()
{
	players = bot_get_all_players_and_agents();
	foreach(player in players)
	{
		if ( IsAIGameParticipant( player ) )
			return true;
	}
	
	return false;
}

/* 
=============
///ScriptDocBegin
"Name: bot_get_entrances_for_stance_and_index( <stance>, <index> )"
"Summary: Gets entrance points for the given stance and index.  Returns an array of nodes"
"OptionalArg: <stance> : "stand", "crouch", or "prone" "
"MandatoryArg: <index> : Index into level.entrance_points: "flag_a", "zone_1", etc."
"Example: return bot_get_entrances_for_stance_and_index(self.cur_defend_stance,self.defend_entrance_index);"
///ScriptDocEnd
============
 */
bot_get_entrances_for_stance_and_index( stance, index )
{
	assert( !IsDefined(stance) || (stance == "stand") || (stance == "crouch") || stance == ("prone") );
	
	if ( !IsDefined(level.entrance_points_finished_caching) && !IsDefined( self.defense_override_entrances ) )
		return undefined;
	
	assert( IsDefined(index) );
	assert( (IsDefined(level.entrance_points) && IsDefined(level.entrance_points[index])) || IsDefined(self.defense_override_entrances) );
	
	entrances = [];
	if ( IsDefined( self.defense_override_entrances ) )
		entrances = self.defense_override_entrances;
	else
		entrances = level.entrance_points[index];
	
	if ( !IsDefined( stance ) || (stance == "stand") )
	{
		return entrances;
	}
	else if ( stance == "crouch" )
	{
		acceptable_nodes = [];
		foreach( node in entrances )
		{
			if ( node.crouch_visible_from[index] )
				acceptable_nodes = array_add(acceptable_nodes, node );
		}
		
		return acceptable_nodes;
	}
	else if ( stance == "prone" )
	{
		acceptable_nodes = [];
		foreach( node in entrances )
		{
			if ( node.prone_visible_from[index] )
				acceptable_nodes = array_add(acceptable_nodes, node );
		}
		
		return acceptable_nodes;	
	}
	
	return undefined;
}

/* 
=============
///ScriptDocBegin
"Name: bot_cull_node_array( <all_nodes>, <node_test_func> )"
"Summary: Looks through the array and removes all nodes that don't pass the node_test_func"
"CallOn: A bot player"
"MandatoryArg: <all_nodes> : The nodes to search through"
"OptionalArg: <node_test_func> : The function to run on the nodes"
"Example: nodes_modified = bot_cull_node_array( all_nodes, node_test_func );"
///ScriptDocEnd
============
 */
bot_cull_node_array( all_nodes, node_test_func )
{
	nodes_modified = [];
	
	foreach( node in all_nodes )
	{
		if ( !IsDefined(node_test_func) || self [[node_test_func]](node) )
		{
			nodes_modified = array_add(nodes_modified, node);
		}
	}
	
	return nodes_modified;
}

/* 
=============
///ScriptDocBegin
"Name: bot_find_node_to_guard_player( <center_of_search>, <radius>, <node_test_func> )"
"Summary: Looks through the nodes in the radius and finds node that would be good to use to defend a player"
"CallOn: A bot player"
"MandatoryArg: <center_of_search> : The center point for the node search"
"MandatoryArg: <radius> : The radius of the node search"
"OptionalArg: <node_test_func> : Optional test function to disquality nodes"
"Example: node = self bot_find_node_to_guard_player( self.bot_defending_center, self.bot_defending_radius, ::bot_can_use_node_in_defend );"
///ScriptDocEnd
============
 */
bot_find_node_to_guard_player( center_of_search, radius, node_test_func )
{
	result = undefined;
	
	player_guarding_velocity = self.bot_defend_player_guarding GetVelocity();
	if ( LengthSquared( player_guarding_velocity ) > 100 )
	{
		// Player we're guarding is moving, so widen radius
		all_nodes_raw = GetNodesInRadius( center_of_search, radius * 1.75, radius * 0.5, 500 );
		
		// Cull nodes that aren't in the direction the player is moving
		all_nodes = [];
		normalized_velocity = VectorNormalize(player_guarding_velocity);
		foreach( node in all_nodes_raw )
		{
			player_to_node = VectorNormalize( node.origin - self.bot_defend_player_guarding.origin );
			if ( VectorDot( player_to_node, normalized_velocity ) > 0.1 )
				all_nodes = array_add( all_nodes, node );
		}
	}
	else
	{
		all_nodes = GetNodesInRadius( center_of_search, radius, 0, 500 );
	}
	nodes_modified = bot_cull_node_array( all_nodes, node_test_func );
	
	// Remove any nodes that are really close to the center
	nodes_modified_removed_close = [];
	for ( i = 0; i < nodes_modified.size; i++ )
	{
		if ( DistanceSquared(nodes_modified[i].origin,center_of_search) > 100 * 100 )
		{
			nodes_modified_removed_close = array_add(nodes_modified_removed_close, nodes_modified[i]);
		}
	}

	if ( nodes_modified_removed_close.size > 0 )
		result = self BotNodePick( nodes_modified_removed_close, nodes_modified_removed_close.size * 0.15, "node_capture", center_of_search, undefined );
	
	return result;
}

/* 
=============
///ScriptDocBegin
"Name: bot_find_node_to_capture_point( <center_of_search>, <radius>, <point_to_face>, <node_test_func> )"
"Summary: Looks through the nodes in the radius and finds node that would be good to use to capture the point"
"CallOn: A bot player"
"MandatoryArg: <center_of_search> : The center point for the node search"
"MandatoryArg: <radius> : The radius of the node search"
"OptionalArg: <point_to_face> : The point that the node needs to face"
"OptionalArg: <node_test_func> : Optional test function to disquality nodes"
"Example: node = self bot_find_node_to_capture_point( self.bot_defending_center, max_node_dist, entrance_point, ::bot_can_use_node_in_defend);"
///ScriptDocEnd
============
 */
bot_find_node_to_capture_point( center_of_search, radius, point_to_face, node_test_func )
{
	result = undefined;
	
	all_nodes = GetNodesInRadius( center_of_search, radius, 0, 500 );
	nodes_modified = bot_cull_node_array( all_nodes, node_test_func );

	if ( nodes_modified.size > 0 )
		result = self BotNodePick( nodes_modified, nodes_modified.size * 0.15, "node_capture", center_of_search, point_to_face );
	
	return result;
}

/* 
=============
///ScriptDocBegin
"Name: bot_find_node_to_capture_zone( <nodes>, <center_of_zone>, <point_to_face>, <node_test_func> )"
"Summary: Looks through the nodes in the zone and finds node that would be good to use to capture the zone"
"CallOn: A bot player"
"MandatoryArg: <nodes> : An array of nodes in the zone"
"OptionalArg: <center_of_zone> : The center of the zone.  Only used if point_to_face is undefined"
"OptionalArg: <point_to_face> : The point that the node needs to face"
"OptionalArg: <node_test_func> : Optional test function to disquality nodes"
"Example: node = self bot_find_node_to_capture_zone( nodes, undefined, entrance_point, ::bot_can_use_node_in_defend);"
///ScriptDocEnd
============
 */
bot_find_node_to_capture_zone( nodes, center_of_zone, point_to_face, node_test_func )
{
	result = undefined;
	center = undefined;
	
	if ( !IsDefined( point_to_face ) )
	{
		center = center_of_zone;
	}
	
	nodes_modified = bot_cull_node_array( nodes, node_test_func );
	
	if ( nodes_modified.size > 0 )
		result = self BotNodePick( nodes_modified, nodes_modified.size * 0.15, "node_capture", center, point_to_face );
	
	return result;
}

/* 
=============
///ScriptDocBegin
"Name: bot_find_node_that_protects_point( <center_of_search>, <radius>, <node_test_func> )"
"Summary: Looks through the nodes in the radius and finds node that would be good to use to protect the point"
"CallOn: A bot player"
"MandatoryArg: <center_of_search> : The center point for the node search"
"MandatoryArg: <radius> : The radius of the node search"
"OptionalArg: <node_test_func> : Optional test function to disquality nodes"
"Example: node = self bot_find_node_that_protects_point( self.bot_defending_center, max_node_dist, ::bot_can_use_node_in_defend);"
///ScriptDocEnd
============
 */
bot_find_node_that_protects_point( center_of_search, radius, node_test_func )
{
	result = undefined;
	
	all_nodes = GetNodesInRadius( center_of_search, radius, 0, 500 );
	nodes_modified = bot_cull_node_array( all_nodes, node_test_func );

	if ( nodes_modified.size > 0 )
		result = self BotNodePick( nodes_modified, nodes_modified.size * 0.15, "node_protect", center_of_search );
	
	return result;
}

/* 
=============
///ScriptDocBegin
"Name: bot_pick_random_point_in_radius(<center_point>, <radius>, <point_test_func>, <close_dist>, <far_dist>)"
"Summary: Finds a random point in the radius around center_point.  First tries to find a point halfway between valid nodes.  If that fails, finds a completely random point"
"CallOn: A bot player"
"MandatoryArg: <center_point> : The center point for the search"
"MandatoryArg: <radius> : The radius of the search"
"OptionalArg: <point_test_func> : Optional test function, to disqualify points that other bots might be using"
"OptionalArg: <close_dist> : When doing random search, don't find nodes closer than close_dist * radius"
"OptionalArg: <far_dist> : When doing random search, don't find nodes farther than far_dist * radius"
"Example: self.cur_defend_point_override = self bot_pick_random_point_in_radius(self.bot_defending_center,self.bot_defending_radius,::bot_can_use_point_in_defend,0.15,0.9);"
///ScriptDocEnd
============
 */
bot_pick_random_point_in_radius(center_point, node_radius, point_test_func, close_dist, far_dist)
{
	point_picked = undefined;
	
	// try picking two random nodes in the radius and finding the midpoint of them
	nodes = GetNodesInRadius( center_point, node_radius, 0, 500 );
	if ( IsDefined( nodes ) && nodes.size >= 2 )
	{
		rand1 = RandomInt( nodes.size );
		rand2 = rand1;
		while(rand2 == rand1)
		{
			rand2 = RandomInt( nodes.size );
		}
		
		node1 = nodes[rand1];
		node2 = nodes[rand2];
		
		if ( BulletTracePassed(node1.origin,node2.origin,false,self) )
		{
			point_picked = ((node1.origin[0] + node2.origin[0])*0.5,(node1.origin[1] + node2.origin[1])*0.5,(node1.origin[2] + node2.origin[2])*0.5);
			
			if ( IsDefined(point_test_func) )
			{
				if ( self [[point_test_func]](point_picked) == false )
				{
					// point didn't pass our test
					point_picked = undefined;
				}
			}
		}
	}
	
	if ( !IsDefined(point_picked) )
	{
		if ( !IsDefined(close_dist) )
		{
			close_dist = 0;
		}
		if ( !IsDefined(far_dist) )
		{
			far_dist = 1;
		}
		
		// Pick a node completely at random
		rand_dist = RandomFloatRange(self.bot_defending_radius*close_dist, self.bot_defending_radius*far_dist);
		rand_dir = AnglesToForward((0,RandomInt(360),0));
		point_picked = center_point + rand_dir*rand_dist;
	}
	
	return point_picked;
}


/* 
=============
///ScriptDocBegin
"Name: bot_allowed_to_use_killstreaks()"
"Summary: Checks if a bot is allowed to use killstreaks"
"CallOn: A bot player"
"Example: self bot_allowed_to_use_killstreaks()"
///ScriptDocEnd
============
 */
bot_allowed_to_use_killstreaks()
{
	if ( !IsAlive( self ) )
	{
		return false;
	}
	
	if ( !IsDefined( self.enemy ) )
	{
		return true;
	}
	
	if ( self.enemy.health <= 0 )
	{
		return true;
	}
	
	if ( !within_fov( self.origin, self.angles, self.enemy.origin, 25 ) )
	{
		return true;
	}
	
	if ( !self BotCanSeeEntity( self.enemy ) )
	{
		return true;
	}
	
	return false;
}


/* 
=============
///ScriptDocBegin
"Name: bot_recent_point_of_interest()"
"Summary: Checks if there is a location this bot should investigate based on persistant memory"
"CallOn: A bot player"
"Example: goalPos = self bot_recent_point_of_interest()"
///ScriptDocEnd
============
 */
bot_recent_point_of_interest()
{
	result = undefined;
	
	deathExcludeFlags = BotMemoryFlags( "investigated", "killer_died" );
	killExcludeFlags = BotMemoryFlags( "investigated" );
	
	// Kill/Death position is always the killer position
	memoryHotSpot = random(BotGetMemoryEvents( 0, GetTime() - 10000, 1, "death", deathExcludeFlags, self ));
	if ( IsDefined(memoryHotSpot) )
	{
		// We were just killed, seek out that killer
		result = memoryHotSpot;
		self.bot_memory_goal_time = 10000;
	}
	else
	{
		// Randomly seek out a relatively recent kill or death location
		curScriptGoal = undefined;
		
		if ( self BotGetScriptGoalType() != "none" )
		{
			curScriptGoal = self BotGetScriptGoal();
		}
		
		bot_killed_someone_from = BotGetMemoryEvents( 0, GetTime() - 45000, 1, "kill", killExcludeFlags, self );
		bot_was_killed_from = BotGetMemoryEvents( 0, GetTime() - 45000, 1, "death", deathExcludeFlags, self );
		memoryHotSpot = random(array_combine(bot_killed_someone_from,bot_was_killed_from));
		if ( IsDefined(memoryHotSpot) > 0 && ( !IsDefined( curScriptGoal ) || DistanceSquared( curScriptGoal, memoryHotSpot ) > ( 1000 * 1000 ) ) )
		{
			result = memoryHotSpot;
			self.bot_memory_goal_time = 45000;
		}
	}
	
	if ( IsDefined( result ) )
	{
		hotSpotZone = GetZoneNearest( result );
		myZone = GetZoneNearest( self.origin );
		if ( IsDefined( hotSpotZone ) && IsDefined( myZone ) && myZone != hotSpotZone )
		{
			// Dont seek it out if there are multiple other allies already there or headed by/near there
			activity = BotZoneGetCount( hotSpotZone, self.team, "ally" ) + BotZoneGetCount( hotSpotZone, self.team, "path_ally" );
			if ( activity > 1 )
				result = undefined;
		}
	}

	if ( IsDefined( result ) )
		self.bot_memory_goal = result;
	
	return result;
}

bot_draw_cylinder( pos, rad, height, duration, stop_notify, color, depthTest, sides )
{
/#
	if ( !IsDefined( duration ) )
	{
		duration = 0;
	}
	
	level thread bot_draw_cylinder_think( pos, rad, height, duration, stop_notify, color, depthTest, sides );
#/
}

bot_draw_cylinder_think( pos, rad, height, seconds, stop_notify, color, depthTest, sides )
{
/#
	if ( IsDefined( stop_notify ) )
	{
		level endon( stop_notify );
	}
	
	if ( !IsDefined(color) )
	{
		color = (1,1,1);
	}
	
	if ( !IsDefined(depthTest) )
	{
		depthTest = false;	
	}
	
	if ( !IsDefined(sides) )
	{
		sides = 20;
	}

	stop_time = GetTime() + ( seconds * 1000 );

	currad = rad; 
	curheight = height; 

	for ( ;; )
	{
		if ( seconds > 0 && stop_time <= GetTime() )
		{
			return;
		}

		for( r = 0; r < sides; r++ )
		{
			theta = r / sides * 360; 
			theta2 = ( r + 1 ) / sides * 360; 

			line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, 0 ), color, 1.0, depthTest ); 
			line( pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, curheight ), color, 1.0, depthTest ); 
			line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ), color, 1.0, depthTest ); 
		}

		wait( 0.05 );
	}
#/
}

bot_draw_circle( center, radius, color, depthTest, segments )
{
/#
	if ( !isDefined( segments ) )
		segments = 16;
		
	angleFrac = 360/segments;
	circlepoints = [];
	
	for( i = 0; i < segments; i++ )
	{
		angle = (angleFrac * i);
		xAdd = cos(angle) * radius;
		yAdd = sin(angle) * radius;
		x = center[0] + xAdd;
		y = center[1] + yAdd;
		z = center[2];
		circlepoints[circlepoints.size] = ( x, y, z );
	}
	
	for( i = 0; i < circlepoints.size; i++ )
	{
		start = circlepoints[i];
		if (i + 1 >= circlepoints.size)
			end = circlepoints[0];
		else
			end = circlepoints[i + 1];
		
		line( start, end, color, 1.0, depthTest );
	}
#/
}

/* 
=============
///ScriptDocBegin
"Name: bot_get_total_gun_ammo()"
"Summary: Returns the total amount of ammo this bot has"
"Example: if ( self bot_get_total_gun_ammo() == 0 )"
///ScriptDocEnd
============
 */
bot_get_total_gun_ammo()
{
	total_ammo = 0;
	heldweapons = self GetWeaponsListPrimaries();
	foreach ( weapon in heldweapons )
	{
		total_ammo += self GetWeaponAmmoClip( weapon );
		total_ammo += self GetWeaponAmmoStock( weapon );
	}
	
	return total_ammo;
}


/* 
=============
///ScriptDocBegin
"Name: bot_get_grenade_ammo()"
"Summary: Returns the amount of grenade ammo this bot has"
"Example: if ( self bot_get_grenade_ammo() > 0 )"
///ScriptDocEnd
============
 */
bot_get_grenade_ammo()
{
	total_grenades = 0;
	
	offhand_list = self GetWeaponsListOffhands();
	
	foreach( weapon in offhand_list )
	{
		total_grenades += self GetWeaponAmmoStock(weapon);
	}
	
	return total_grenades;
}

/* 
=============
///ScriptDocBegin
"Name: bot_get_trap_item_grenade_type()"
"Summary: Gets the grenade type of a useable trap item or undefined if nothing in inventory applicable"
"CallOn: A bot player"
"Example: grenadeType = self bot_get_trap_item_grenade_type();"
///ScriptDocEnd
============
 */
bot_get_trap_item_grenade_type( )
{
	if ( self bot_get_persistent_value("allowGrenades") == 1 )
	{
		weapon_list = self GetWeaponsListOffhands();
		foreach ( weapon in weapon_list )
		{
			if ( self GetAmmoCount( weapon ) > 0 )
			{
				if ( ("claymore_mp" == weapon) || ("bouncingbetty_mp" == weapon) )
					return "lethal";
			}
		}
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_watch_nodes(<nodes>, <yaw>, <end_time>, <end1>, <end2>, <end3> )"
"Summary: Bot will look at nodes and make sure to keep an eye on ones that have been out of sight the longest
"CallOn: A bot player"
"MandatoryArg: <nodes> : The array of nodes"
"OptionalArg: <yaw> : If provided, limits to nodes within yawCos arc of world yaw from bot"
"OptionalArg: <yaw_fov> : cosine of the FOV angle from yaw to include in watch list"
"OptionalArg: <end_time> : If provided, ends the thread when GetTime() >= end_time"
"OptionalArg: <end1-4> : If provided, ends the thread on any of the events named"
"Example: self thread bot_watch_nodes(entrances, threatDirYaw, Cos(45), 10, "node_relinquished", "enemy");"
"NoteLine: Nothing is done to test actual visibility to the nodes, only a within_fov() check is done"
"NoteLine: If you want to ensure the nodes are physically visible, exclude blocked nodes prior to calling this thread"
///ScriptDocEnd
============
 */
bot_watch_nodes( nodes, yaw, yaw_fov, end_time, end1, end2, end3, end4 )
{
	self notify( "bot_watch_entrances" );
	self endon( "bot_watch_entrances" );
	self endon( "disconnect" );
	self endon( "death" );
	
	if ( IsDefined(nodes) )
		self.watch_nodes = nodes;
	
	if ( !IsDefined(self.watch_nodes) )
		return;
	
	if ( IsDefined( end1 ) )
		self endon( end1 );
	if ( IsDefined( end2 ) )
		self endon( end2 );
	if ( IsDefined( end3 ) )
		self endon( end3 );
	if ( IsDefined( end4 ) )
		self endon( end4 );

	// Randomize the array to avoid doing the same thing in the same order each time
	self.watch_nodes = array_randomize( self.watch_nodes );
	
	foreach( node in self.watch_nodes )
		node.watch_node_chance[self.entity_number] = 1.0;
	
	startTime = GetTime();
	nextLookTime = startTime;
	node_vis_times = [];

	yawAngles = undefined;	
	if ( IsDefined( yaw ) )
		yawAngles = ( 0, yaw, 0 );
	
	lookingAtNode = undefined;

	for(;;)
	{
		now = GetTime();
		bot_fov = self BotGetFovDot();
		
		if ( isDefined(end_time) && (now >= end_time) )
			return;
		
		if ( self bot_has_tactical_goal() )
		{
			// Not allowed to watch nodes when bot has a tactical goal
			self BotLookAtPoint( undefined );
			wait(0.2);
			continue;
		}
		
		if ( IsDefined(lookingAtNode) && lookingAtNode.watch_node_chance[self.entity_number] == 0.0 )
		{
			// If the node we're looking at is no longer valid, then make sure to pick a new target
			nextLookTime = now;
		}
		
		if ( self.watch_nodes.size > 0 )
		{
			watch_nodes_oldest_to_newest = [];
			for ( i = 0; i < self.watch_nodes.size; i++ )
			{
				node = self.watch_nodes[i];
				node_num = node GetNodeNumber();
				
				if ( IsDefined(yawAngles) && IsDefined(yaw_fov) && !within_fov( self.origin, yawAngles, node.origin, yaw_fov ) )
				{
					// Only pay attention to nodes within the yaw arc, if defined
					continue;
				}
				
				if ( !IsDefined(node_vis_times[node_num]) )
					node_vis_times[node_num] = 0;
				
				// Mark the last time each node was visible by the bot
				if ( within_fov( self.origin, self.angles, node.origin, bot_fov ) )
					node_vis_times[node_num] = now;
				
				if ( now >= nextLookTime )
				{
					// If its time to pick a new point, then fill out an array of oldest to newest seen nodes
					index = 0;
					for( ; index<watch_nodes_oldest_to_newest.size; index++ )
					{
						if ( node_vis_times[watch_nodes_oldest_to_newest[index] GetNodeNumber()] > node_vis_times[node_num] )
							break;
					}
					
					watch_nodes_oldest_to_newest = array_insert( watch_nodes_oldest_to_newest, node, index );
				}
			}
			
			if ( now >= nextLookTime )
			{
				lookingAtNode = undefined;
				for( i=0; i<watch_nodes_oldest_to_newest.size; i++ )
				{
					if ( RandomFloat(1) > watch_nodes_oldest_to_newest[i].watch_node_chance[self.entity_number] )
						continue;
					
					lookingAtNode = watch_nodes_oldest_to_newest[i];
					nextLookTime = now + RandomIntRange( 3000, 5000 );
					break;
				}
			}
			
			if ( isDefined( lookingAtNode ) )
			{
				node_offset = (0,0,level.bot_eye_height);
				self_stance = self GetStance();
				if ( self_stance == "crouch" )
					node_offset = (0,0,40);
				else if ( self_stance == "prone" )
					node_offset = (0,0,11);
				
				self BotLookAtPoint( lookingAtNode.origin + node_offset, 0.4, "script_search" );
			}
		}
		
		wait(0.2);
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_leader_dialog( <dialog>, <location> )"
"Summary: Bot handler for playLeaderDialogOnPlayer()
"CallOn: A bot player"
"MandatoryArg: <dialog> : The dialog type string"
"OptionalArg: <location> : If provided, the location the event happened"
///ScriptDocEnd
============
 */
bot_leader_dialog( dialog, location )
{
	// Game events notified to players come in through here such as flags being captured or killstreak hardware destroyed
	
	// Are we being notified that something happened at a specific location?
	if ( IsDefined( location ) && (location != (0, 0, 0)) )
	{
		// If we are not currently looking at that spot but can potentially see it, look there for a few seconds to see whats going on
		if ( !within_fov( self.origin, self.angles, location, self BotGetFovDot() ) )
		{
			lookAtLoc = self BotPredictSeePoint( location );
			if ( IsDefined( lookAtLoc ) )
				self BotLookAtPoint( lookAtLoc + (0,0,40), 1.0, "script_seek" );
		}

		// Mark it in the bot's memory as well
		self BotMemoryEvent( "known_enemy", undefined, location );
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_get_persistent_value()"
"Summary: Returns the persistent value (from the bot difficulty table) for a specific value"
"MandatoryArg: <value_name> : The name of the variable we are looking up"
"Example: if ( self bot_get_persistent_value("allowGrenades") == 1 )"
///ScriptDocEnd
============
 */
bot_get_persistent_value( value_name )
{
	bot_difficulty = self BotGetDifficulty();
	
	column = -1;
	if ( bot_difficulty == "recruit" )
		column = 0;
	else if ( bot_difficulty == "regular" )
		column = 1;
	else if ( bot_difficulty == "hardened" )
		column = 2;
	else if ( bot_difficulty == "veteran" )
		column = 3;
		
	return level.bot_persistent_values[value_name][column];
}

/* 
=============
///ScriptDocBegin
"Name: bot_get_attacker_entity()"
"Summary: Returns the true attacker - either the inflictor (if it exists) or the attacker"
"Example: attacker_ent = bot_get_attacker_entity( eAttacker, eInflictor );"
///ScriptDocEnd
============
 */
bot_get_attacker_entity( attacker, inflictor )
{
	if ( IsDefined( inflictor ) && inflictor.classname != "rocket" )
		return inflictor;
	else if ( IsDefined( attacker ) )
		return attacker;
	
	return undefined;
}
