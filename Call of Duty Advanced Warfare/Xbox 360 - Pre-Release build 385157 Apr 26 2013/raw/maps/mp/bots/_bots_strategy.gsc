// Common strategy functions for bots

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\bots\_bots_util;

/* 
=============
///ScriptDocBegin
"Name: bot_defend_get_random_entrance_point_for_current_area()"
"Summary: Gets a random entrance point for the bot's current defend area, using self.cur_defend_stance"
"Example: entrance_point = self bot_defend_get_random_entrance_point_for_current_area();"
///ScriptDocEnd
============
 */
bot_defend_get_random_entrance_point_for_current_area()
{
	all_cached_entrances = self bot_defend_get_precalc_entrances_for_current_area( self.cur_defend_stance );
	
	if ( IsDefined(all_cached_entrances) && all_cached_entrances.size > 0 )
	{
		return random(all_cached_entrances).origin;
	}
	
	return undefined;
}

/* 
=============
///ScriptDocBegin
"Name: bot_defend_get_precalc_entrances_for_current_area( <stance> )"
"Summary: Gets entrance points for the bot's current defend area, with the given stance"
"MandatoryArg: <stance> : "stand", "crouch", or "prone" "
"Example: all_cached_entrances = self bot_defend_get_precalc_entrances_for_current_area( self.cur_defend_stance );"
///ScriptDocEnd
============
 */
bot_defend_get_precalc_entrances_for_current_area( stance )
{
	if ( IsDefined( self.defend_entrance_index ) )
		return bot_get_entrances_for_stance_and_index(stance,self.defend_entrance_index);
	
	return [];
}

bot_setup_bombzone_bottargets()
{
	bot_setup_bot_targets(level.bombZones);
}

bot_setup_radio_bottargets()
{
	bot_setup_bot_targets(level.radios);
}

bot_setup_bot_targets(array)
{
	foreach ( element in array )
	{
		if ( !IsDefined( element.botTarget ) )
		{
			// Generate a botTarget
			botTarget = SpawnStruct();
			if ( IsDefined(element.curorigin) )
				element_origin = element.curorigin;
			else
				element_origin = element.origin;
			
			nodes = GetNodesInRadiusSorted( element_origin, 256, 32, 100 );

			closest_node_in_front = undefined;
			if ( IsDefined(element.script_gameobjectname) && element.script_gameobjectname == "hq" )
			{
				// HQ objects need a node in front of them (they're usually up against a wall)
				element_dir_forward = AnglesToForward( element.angles );
				element_dir_forward = VectorNormalize(element_dir_forward);
				
				foreach ( node in nodes )
				{
					dir_to_node = (node.origin - element_origin) * (1,1,0);
					dir_to_node = VectorNormalize(dir_to_node);
					
					dot_to_node = VectorDot( element_dir_forward, dir_to_node );
					if ( dot_to_node > 0.1 )
					{
						closest_node_in_front = node;
						break;
					}
				}
			}
			
			dir = (1,0,0);
			dist_to_place_botTarget = 55;
			if ( IsDefined(closest_node_in_front) )
			{
				dir = VectorNormalize( closest_node_in_front.origin - element_origin );
				dist_to_place_botTarget = max( dist_to_place_botTarget, Distance( closest_node_in_front.origin, element_origin ) * 0.6 );
			}
			else if ( nodes.size > 0 )
			{
				dir = VectorNormalize( nodes[0].origin - element_origin );
				dist_to_place_botTarget = max( dist_to_place_botTarget, Distance( nodes[0].origin, element_origin ) * 0.6 );
			}
			
			botTarget.origin = element_origin + (dir * dist_to_place_botTarget);

			botTarget.origin = PhysicsTrace( botTarget.origin + (0,0,50), botTarget.origin + (0,0,-256) );
			botTarget.origin = botTarget.origin + (0, 0, 2);
			botTarget.origin = ( int(botTarget.origin[0]), int(botTarget.origin[1]), int(botTarget.origin[2]) );
			botTarget.angles = VectorToAngles( dir * -1 );
		
			element.botTarget = botTarget;
		}
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_set_optional_ambush_trap(<ambush_entrances>, <ambush_node>, <ambush_yaw>)"
"Summary: Instructs the bot to place some hardware to protect a location"
"CallOn: A bot player"
"MandatoryArg: <ambush_entrances> : The player to protect"
"MandatoryArg: <ambush_node> : The allowable radius around the player"
"OptionalArg: <ambush_yaw> : The direction the bot will be ambushing"
"Example: self bot_set_optional_ambush_trap( self.ambush_entrances, self.node_ambushing_from, self.ambush_yaw );"
///ScriptDocEnd
============
 */
bot_set_optional_ambush_trap( ambush_entrances, ambush_node, ambush_yaw )
{
	// if we have a trap tactical item ( claymore, bouncing betty ), set a trap first, then continue on
	
	trap_item = self bot_get_trap_item_grenade_type();
	
	if ( !isDefined( trap_item ) )
		return;
	
	if ( !isDefined( ambush_node ) )
		return;

	if ( isDefined( ambush_entrances ) && ambush_entrances.size > 0 )
	{		
		choose_set = [];

		fwd = undefined;
		if ( IsDefined( ambush_yaw ) )
			fwd = AnglesToForward( (0, ambush_yaw, 0) );

		foreach( entrance in ambush_entrances )
		{
			// If ambush_yaw is defined only choose entrances that are not right next to ambushing location and optionally not out in front of where we are facing
			if ( !isDefined( fwd ) )
			{
				choose_set[choose_set.size] = entrance;
			}
			else if ( Distance( entrance.origin, ambush_node.origin ) > 300 )			
			{
				if ( VectorDot( fwd, VectorNormalize( entrance.origin - ambush_node.origin ) ) < 0.4 )
				{
					choose_set[choose_set.size] = entrance;
				}
			}
		}

		if ( choose_set.size > 0 )
		{
			chosen_entrance = Random(choose_set);
			trap_choices = GetNodesInRadius( chosen_entrance.origin, 300, 50 );
			
			// Remove any nodes that are an ambush destination
			tempChoices = [];
			foreach( node in trap_choices )
			{
				if ( !IsDefined( node.bot_ambush_end ) )
					tempChoices[tempChoices.size] = node;
			}
			trap_choices = tempChoices;
			
			trap_node = self BotNodePick( trap_choices, min( trap_choices.size, 3 ), "node_trap", ambush_node, chosen_entrance );
			if ( isDefined( trap_node ) )
			{
				placeAngles = VectorToAngles( chosen_entrance.origin - trap_node.origin );
				goal_succeeded = self BotSetScriptGoalNode( trap_node, "guard", placeAngles[1] );
				if ( goal_succeeded )
				{
					result = self bot_waittill_goal_or_fail();
					if ( result == "goal" )
					{
						if ( !IsDefined( self.enemy ) || (false == (self BotCanSeeEntity( self.enemy ))) )
						{
							self BotThrowGrenade( chosen_entrance.origin, trap_item );
							self waittill_any_timeout( 3.0, "grenade_fire" );
							wait RandomFloat(0.25);
						}
					}
				}
			}
		}
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_capture_point( <point>, <radius>, <entrance_points_index>, <goal_type> )"
"Summary: Instructs the bot to capture the point while staying within the radius"
"CallOn: A bot player"
"MandatoryArg: <point> : The point to capture"
"MandatoryArg: <radius> : The allowable radius around the point"
"OptionalArg: <entrance_points_index> : The index into level.entrance_points for the area"
"OptionalArg: <goal_type> : The type of goal to use "guard", "critical", etc."
"OptionalArg: <override_entrances> : An array of nodes to use as entrances to the area"
"Example: self bot_capture_point(flag.origin, 250);"
///ScriptDocEnd
============
 */
bot_capture_point( point, radius, entrance_points_index, goal_type, override_entrances )
{
	optional_params["override_goal_type"] = goal_type;
	optional_params["override_entrances"] = override_entrances;
	self thread bot_defend_think( point, radius, "capture", entrance_points_index, optional_params );
}

/* 
=============
///ScriptDocBegin
"Name: bot_capture_zone( <point>, <nodes>, <entrance_points_index>, <goal_type> )"
"Summary: Instructs the bot to capture an area by sticking to a given set of points"
"CallOn: A bot player"
"MandatoryArg: <point> : The point to capture"
"MandatoryArg: <nodes> : The array of valid nodes to use"
"OptionalArg: <entrance_points_index> : The index into level.entrance_points for the area"
"OptionalArg: <goal_type> : The type of goal to use "guard", "critical", etc."
"OptionalArg: <override_entrances> : An array of nodes to use as entrances to the area"
"Example: self bot_capture_zone(find_current_radio().bot_nodes);"
///ScriptDocEnd
============
 */
bot_capture_zone( point, nodes, entrance_points_index, goal_type, override_entrances )
{
	optional_params["override_goal_type"] = goal_type;
	optional_params["override_entrances"] = override_entrances;
	self thread bot_defend_think( point, nodes, "capture_zone", entrance_points_index, optional_params );
}

/* 
=============
///ScriptDocBegin
"Name: bot_protect_point( <point>, <radius>, <entrance_points_index>, <goal_type> )"
"Summary: Instructs the bot to protect the point while staying within the radius"
"CallOn: A bot player"
"MandatoryArg: <point> : The point to protect"
"MandatoryArg: <radius> : The allowable radius around the point"
"OptionalArg: <entrance_points_index> : The index into level.entrance_points for the area"
"OptionalArg: <goal_type> : The type of goal to use "guard", "critical", etc."
"OptionalArg: <override_entrances> : An array of nodes to use as entrances to the area"
"Example: self bot_protect_point(flag.origin, 250);"
///ScriptDocEnd
============
 */
bot_protect_point( point, radius, entrance_points_index, goal_type, override_entrances )
{
	optional_params["override_goal_type"] = goal_type;
	optional_params["override_entrances"] = override_entrances;
	optional_params["min_goal_time"] = 12;
	optional_params["max_goal_time"] = 18;
	
	self thread bot_defend_think( point, radius, "protect", entrance_points_index, optional_params );
}

/* 
=============
///ScriptDocBegin
"Name: bot_guard_player( <player>, <radius> )"
"Summary: Instructs the bot to guard the player while staying within the radius"
"CallOn: A bot player"
"MandatoryArg: <player> : The player to guard"
"MandatoryArg: <radius> : The allowable radius around the player"
"Example: self bot_guard_player( level.bomb_carrier, 400 );"
///ScriptDocEnd
============
 */
bot_guard_player( player, radius )
{
	self thread bot_defend_think( player, radius, "bodyguard", undefined, undefined );
}

// Don't call this function directly, use the above accessor functions
bot_defend_think( defendCenter, defendRadius, defense_type, entrance_points_index, optional_params )
{
	self notify( "started_bot_defend_think" );
	self endon(  "started_bot_defend_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	self endon( "defend_stop" );
	
	self thread defense_death_monitor();

	if ( IsDefined(self.bot_defending) || self BotGetScriptGoalType() == "camp" )
	{
		// If we are already defending something, or we are currently camping, we should clear our current script goal
		self BotClearScriptGoal();
	}
	
	self.bot_defending = true;
	self.bot_defending_type = defense_type;

	if ( defense_type == "capture_zone" )
	{
		self.bot_defending_radius = undefined;
		self.bot_defending_nodes = defendRadius;
	}
	else
	{
		self.bot_defending_radius = defendRadius;
		self.bot_defending_nodes = undefined;
	}
	
	if ( IsPlayer(defendCenter) )
	{
		self.bot_defend_player_guarding = defendCenter;
		self childthread monitor_defend_player();
	}
	else
	{
		self.bot_defend_player_guarding = undefined;
		self.bot_defending_center = defendCenter;
	}
	
	self BotSetStance("none");
	self.defend_entrance_index = entrance_points_index;
	
	goal_type = undefined;
	min_goal_time = 6;
	max_goal_time = 10;
	if ( IsDefined(optional_params) )
	{
		if ( IsDefined(optional_params["override_goal_type"]) )
			goal_type = optional_params["override_goal_type"];
		
		if ( IsDefined(optional_params["min_goal_time"]) )
			min_goal_time = optional_params["min_goal_time"];
		
		if ( IsDefined(optional_params["max_goal_time"]) )
			max_goal_time = optional_params["max_goal_time"];
		
		if ( IsDefined(optional_params["override_entrances"]) && optional_params["override_entrances"].size > 0 )
		{
			self.defense_override_entrances = optional_params["override_entrances"];
			
			// Create a unique index for this bot's defense at this time, so that the visibility checks below will be unique to this defense
			self.defend_entrance_index = self.name + " " + GetTime();
			
			// need to calculate crouch and prone visibility
			foreach( entrance in self.defense_override_entrances )
			{
				entrance.prone_visible_from[self.defend_entrance_index] = entrance_visible_from( entrance.origin, self.bot_defending_center, "prone" );
				wait(0.05);
				entrance.crouch_visible_from[self.defend_entrance_index] = entrance_visible_from( entrance.origin, self.bot_defending_center, "crouch" );
				wait(0.05);
			}
		}
	}
	
	find_node_function = undefined;
	if ( defense_type == "capture" )
		find_node_function = ::find_defend_node_capture;
	else if ( defense_type == "capture_zone" )
		find_node_function = ::find_defend_node_capture_zone;
	else if ( defense_type == "protect" )
		find_node_function = ::find_defend_node_protect;
	else if ( defense_type == "bodyguard" )
		find_node_function = ::find_defend_node_bodyguard;
	
	if ( !IsDefined(goal_type) )
	{
		if ( defense_type == "capture" )
			goal_type = "objective";
		else if ( defense_type == "capture_zone" )
			goal_type = "objective";
		else if ( defense_type == "protect" )
			goal_type = "guard";
		else if ( defense_type == "bodyguard" )
			goal_type = "guard";
	}
	
	random_stance_at_pathnode_dest = ( defense_type == "capture" || defense_type == "capture_zone" );
	
	if ( defense_type == "protect" )
	{
		self childthread protect_watch_allies();
	}
	
	if ( defense_type == "bodyguard" )
	{
		self childthread bodyguard_watch_entrances();
	}

	for(;;)
	{
		self.prev_defend_node = self.cur_defend_node;
		self.cur_defend_node = undefined;
		self.cur_defend_angle_override = undefined;
		self.cur_defend_point_override = undefined;
				
		self.cur_defend_stance = calculate_defend_stance( random_stance_at_pathnode_dest );
		
		current_goal_type = self BotGetScriptGoalType();
		can_override_goal = bot_goal_can_override( goal_type, current_goal_type );
		if ( !can_override_goal )
		{
			// Don't allow defense to interrupt a critical move
			wait(0.25);
			continue;
		}
		
		cur_min_goal_time = min_goal_time;
		cur_max_goal_time = max_goal_time;
		can_plant_trap = true;
		
		if ( IsDefined( self.defense_investigate_specific_point ) )
		{
			self.cur_defend_point_override = self.defense_investigate_specific_point;
			self.defense_investigate_specific_point = undefined;
			can_plant_trap = false;
			cur_min_goal_time = 1.0;
			cur_max_goal_time = 2.0;
		}
		else
		{
			self [[find_node_function]]();
		}
		
		self BotClearScriptGoal();
		
		result = "";
		if ( IsDefined( self.cur_defend_node ) || IsDefined( self.cur_defend_point_override ) )
		{
			// If applicable, plant a trap to help defend the area first
			if ( can_plant_trap && (defense_type == "protect") && !IsPlayer( defendCenter ) && IsDefined( self.defend_entrance_index ) )
			{
				nearestNodes = GetNodesInRadiusSorted( defendCenter, 256, 0, 100 );
				if ( IsDefined( nearestNodes ) && nearestNodes.size > 0 )
				{
					entrances = self bot_get_entrances_for_stance_and_index( undefined, self.defend_entrance_index );
					self bot_set_optional_ambush_trap( entrances, nearestNodes[0] );
				}
			}

			if ( IsDefined( self.cur_defend_point_override ) )
		    {
				// If we have an override point (we couldn't find a node destination)
				yaw = undefined;
				if ( IsDefined(self.cur_defend_angle_override) )
					yaw = self.cur_defend_angle_override[1];
				
		    	self BotSetScriptGoal(self.cur_defend_point_override, 0, goal_type, yaw);
		    }
			else if ( !IsDefined( self.cur_defend_angle_override ) )
			{
				// If we have a node destination and we want to use the node's angles
				self BotSetScriptGoalNode( self.cur_defend_node, goal_type );
			}
			else
			{
				// If we have a node destination and we want to force the bot to face a different direction than the node's angles
				self BotSetScriptGoalNode(self.cur_defend_node, goal_type, self.cur_defend_angle_override[1]);
			}
			
			if ( random_stance_at_pathnode_dest )
			{
				if ( !IsDefined(self.prev_defend_node) || !IsDefined(self.cur_defend_node) || (self.prev_defend_node != self.cur_defend_node) )
				{
					// If we go prone at our destination, and we're not staying at the same location,
					// then we need to clear our stance (stand up) before we move
					self BotSetStance("none");
				}
			}
			
			previous_goal = self BotGetScriptGoal();
			self notify("new_defend_goal");
			if ( defense_type != "bodyguard" )
			{
				self.watch_nodes = undefined;
			}
			
			if ( goal_type == "objective" )
			{
				self defense_cautious_approach();	// intentionally not threaded - behavior needs to take over
				self BotSetAwareness( 1.0 );		// Reset to 1.0 when cautiousness finishes (regardless of how it finished)
				self BotSetFlag("cautious", false);
			}
			
			if ( self BotHasScriptGoal() )
			{
				current_goal = self BotGetScriptGoal();
				if ( DistanceSquared( current_goal, previous_goal ) < 1 )
				{
					// If the goal changed since we set it (like during a cautious approach) then we don't want to wait
					result = self bot_waittill_goal_or_fail( 20, "defend_force_node_recalculation" );
				}
			}
			
			if ( result == "goal" )
			{
				if ( random_stance_at_pathnode_dest )
				{
					self BotSetStance(self.cur_defend_stance);
				}
				
				self childthread defense_watch_entrances_at_goal();
			}
		}
		
		if ( result != "goal" )
		{
			wait 0.25;
		}
		else
		{
			result = self waittill_any_timeout( RandomFloatRange( cur_min_goal_time, cur_max_goal_time ), "node_relinquished", "goal_changed", "defend_force_node_recalculation" );
			if ( (result == "node_relinquished" || result == "goal_changed") && (self.cur_defend_stance == "crouch" || self.cur_defend_stance == "prone") )
			{
				// If we were just kicked out of our spot, and we were crouching / going prone, then need to stand up
				self BotSetStance("none");
			}
		}
	}
}

calculate_defend_stance( random_stance_at_pathnode_dest )
{
	stance = "stand";
	if ( random_stance_at_pathnode_dest )
	{
		// Default values (for dumb bots)
		chance_to_stand = 100;
		chance_to_crouch = 0;
		chance_to_prone = 0;
		
		strategy_level = self bot_get_persistent_value("strategyLevel");
		if ( strategy_level == 1 )
		{
			chance_to_stand = 20;
			chance_to_crouch = 25;
			chance_to_prone = 55;
		}
		else if ( strategy_level == 2 )
		{
			chance_to_stand = 10;
			chance_to_crouch = 20;
			chance_to_prone = 70;
		}
		
		choice = RandomInt(100);
		if ( choice < chance_to_crouch )
		{
			stance = "crouch";
		}
		else if ( choice < chance_to_crouch + chance_to_prone )
		{
			stance = "prone";
		}
		
		if ( stance == "prone" )
		{
			// Check number of prone entrances to this zone
			entrances_to_this_zone_for_prone = self bot_defend_get_precalc_entrances_for_current_area( "prone" );
			
			// Check number of bots already wanting to be prone in this zone
			bots_prone_at_this_zone = self defend_get_ally_bots_at_zone_for_stance( "prone" );
			
			if ( bots_prone_at_this_zone.size >= entrances_to_this_zone_for_prone.size )
				stance = "crouch";
		}
		
		if ( stance == "crouch" )
		{
			// Check number of crouch entrances to this zone
			entrances_to_this_zone_for_crouch = self bot_defend_get_precalc_entrances_for_current_area( "crouch" );
			
			// Check number of bots already wanting to be crouched in this zone
			bots_crouched_at_this_zone = self defend_get_ally_bots_at_zone_for_stance( "crouch" );
			
			if ( bots_crouched_at_this_zone.size >= entrances_to_this_zone_for_crouch.size )
				stance = "stand";
		}
	}
	
	return stance;
}

SCR_CONST_frames_needed_visible = 18;

should_start_cautious_approach_default( firstCheck )
{
	distance_start_cautiousness = 1250;
	distance_start_cautiousness_sq = distance_start_cautiousness * distance_start_cautiousness;
	
	// If firstCheck is true, this is called to determine if the bot should even attempt to do a cautious approach
	// If firstCheck is false, this is called to determine if the bot should start his cautious approach, or keep waiting
	
	if ( firstCheck )
	{
		// Don't perform this behavior if we are starting within the radius
		return ( DistanceSquared(self.origin, self.bot_defending_center) > distance_start_cautiousness_sq * 0.75 * 0.75 );
	}
	else
	{
		// Wait until we are within the radius and are pathing toward our goal (vs chasing down enemies)
		if ( self BotPursuingScriptGoal() && DistanceSquared(self.origin, self.bot_defending_center) < distance_start_cautiousness * distance_start_cautiousness )
	    {
			return ( GetPathDist(self.origin, self.bot_defending_center, distance_start_cautiousness) <= distance_start_cautiousness );
		}
		else
		{
			return false;
		}
	}
}

defense_cautious_approach()
{
	self notify( "defense_cautious_approach" );
	self endon(  "defense_cautious_approach" );
	
	level endon( "game_ended" );
	self endon( "defend_force_node_recalculation" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "defend_stop" );
	self endon( "started_bot_defend_think" );
	
	if ( ![[ level.bot_funcs["should_start_cautious_approach"] ]] ( true ) )
		return;

	original_script_goal = self BotGetScriptGoal();
	should_continue_waiting = true;
	time_since_last_dist_check = 0.2;
	while( should_continue_waiting )
	{
		wait(0.05);
		
		if ( !self BotHasScriptGoal() )
		{
			// Lost our script goal, so bail
			return;
		}
		
		current_script_goal = self BotGetScriptGoal();
		if ( DistanceSquared( original_script_goal, current_script_goal ) > 1 )
		{
			// Script goal has changed, so bail
			return;
		}
		
		time_since_last_dist_check += 0.05;
		if ( time_since_last_dist_check >= 0.5 )
		{
			// Debounce this since it can do an A* pathing search
			time_since_last_dist_check = 0.0;
			if ( [[ level.bot_funcs["should_start_cautious_approach"] ]] ( false ) )
				should_continue_waiting = false;
		}
	}
	
	self BotSetAwareness( 1.8 );
	self BotSetFlag("cautious", true);
	
	// **************************************************
	// * Step 1: Build list of locations to investigate *
	// **************************************************

	self.locations_to_investigate = [];
	
	radius_around_point = 1000;
	if ( IsDefined(level.protect_radius) )
		radius_around_point = level.protect_radius;
	
	radius_around_point_sq = radius_around_point * radius_around_point;
	nodes_around_defend_center = GetNodesInRadius( self.bot_defending_center, radius_around_point, 0, 500 );
	if ( nodes_around_defend_center.size <= 0 )
		return;
	
	// Locations enemy might be hiding at while defending the point
	num_to_pick = INT(min(7, nodes_around_defend_center.size ));
	possible_enemy_locations = self BotNodePickMultiple( nodes_around_defend_center, 15, num_to_pick, "node_protect", self.bot_defending_center, "ignore_occupancy" );
	foreach ( node in possible_enemy_locations )
	{
		new_location = SpawnStruct();
		new_location.origin = node.origin;
		new_location.node = node;
		new_location.frames_visible = 0;
		self.locations_to_investigate = array_add( self.locations_to_investigate, new_location );
	}
	
	// Locations this bot was recently killed from
	killer_locations = BotGetMemoryEvents( 0, GetTime() - 60000, 1, "death", 0, self );
	foreach ( location in killer_locations )
	{
		if ( DistanceSquared( location, self.bot_defending_center ) < radius_around_point_sq )
		{
			new_location = SpawnStruct();
			new_location.origin = location;
			nodes = GetNodesInRadiusSorted( location, 256, 0, 500 );
			new_location.node = nodes[0];
			new_location.frames_visible = 0;
			self.locations_to_investigate = array_add( self.locations_to_investigate, new_location );
		}
	}
	
	if ( IsDefined(self.defend_entrance_index) )
	{
		entrances_to_watch = bot_get_entrances_for_stance_and_index("stand",self.defend_entrance_index);
		foreach( entrance in entrances_to_watch )
		{
			new_location = SpawnStruct();
			new_location.origin = entrance.origin;
			new_location.node = entrance;
			new_location.frames_visible = 0;
			self.locations_to_investigate = array_add( self.locations_to_investigate, new_location );
		}
	}
	
	if ( self.locations_to_investigate.size == 0 )
		return;
	
	// Watch those locations for when they come into view
	self childthread monitor_cautious_approach_dangerous_locations();

	// Get the current path, we'll be using this to find nodes along the way to hide at
	current_path_to_goal = self BotGetNodesOnPath();
	if ( !IsDefined(current_path_to_goal) || current_path_to_goal.size <= 2 )
		return;
	
	goal_node = self BotGetScriptGoalNode();
	goal_type = self BotGetScriptGoalType();
	final_goal_radius = self BotGetScriptGoalRadius();
	final_goal_yaw = self BotGetScriptGoalYaw();
	
	/* Keeping this here for debug purposes, in case I need it in the future
	println("***********************************************************");
	println( "Bot " + self.name + " starting cautious approach at time " + GetTime() );
	if ( IsDefined( goal_node ) )
		println( "goal_node = " + goal_node GetNodeNumber() );
	else
		println( "goal_node = undefined" );
	if ( IsDefined( self.cur_defend_point_override ) )
		println( "self.cur_defend_point_override = " + self.cur_defend_point_override[0] + " " + self.cur_defend_point_override[1] + " " + self.cur_defend_point_override[2] );
	else
		println( "self.cur_defend_point_override = undefined" );
	println("Bot has script goal = " + self BotHasScriptGoal() );
	println("***********************************************************");
	*/
	
	for( current_path_section = 1; current_path_section < current_path_to_goal.size - 2; current_path_section++ )
	{
		// *******************************************************
		// * Step 2: Build list of possible locations to hide at *
		// *******************************************************
		
		self bot_waittill_out_of_combat_or_time();

		// Step 2a: Find all nodes linked to the current path node
		potential_hide_nodes = GetNodeLinkedNodes( current_path_to_goal[current_path_section] );
		
		if ( potential_hide_nodes.size == 0 )
			continue;
		
		// Step 2b: Sort through these potential nodes and add any that have any visibility to a location to investigate
		potential_hide_nodes_with_visibility = [];
		for ( i = 0; i < potential_hide_nodes.size; i++ )
		{
			// Ignore nodes that are already claimed
			if ( !self bot_can_hide_at_node( potential_hide_nodes[i] ) )
				continue;
			
			// Ignore nodes behind the bot
			if ( !within_fov( self.origin, self.angles, potential_hide_nodes[i].origin, 0 ) )
				continue;
			
			for ( j = 0; j < self.locations_to_investigate.size; j++ )
			{
				location = self.locations_to_investigate[j];
				if ( NodesVisible( location.node, potential_hide_nodes[i], true ) )
				{
					potential_hide_nodes_with_visibility = array_add( potential_hide_nodes_with_visibility, potential_hide_nodes[i] );
					j = self.locations_to_investigate.size;	// force inner loop to end
				}
			}
		}
		
		if ( potential_hide_nodes_with_visibility.size == 0 )
			continue;
		
		hide_node = self BotNodePick( potential_hide_nodes_with_visibility, 1 + (potential_hide_nodes_with_visibility.size * 0.15), "node_hide" );
		
		// ************************************************************************************
		// * Step 3: Path to the hide node and wait at the node, looking at visible locations *
		// ************************************************************************************

		if ( IsDefined( hide_node ) )
		{
			// Now we have a node to hide at, and we know that hide_node has some visibility to a location (from above)
			visible_locations_from_hide = [];
			foreach( location in self.locations_to_investigate )
			{
				if ( NodesVisible( location.node, hide_node, true ) )
					visible_locations_from_hide = array_add( visible_locations_from_hide, location );
			}
		
			// Path to the hide node
			self BotClearScriptGoal();
			self BotSetScriptGoal( hide_node.origin, 16, "critical" );
			self childthread monitor_cautious_approach_early_out();
			result = self bot_waittill_goal_or_fail( undefined, "cautious_approach_early_out" );
	
			if ( result == "cautious_approach_early_out" )
			{
				break;
			}
			if ( result == "goal" )
			{
				// Look at each visible node until it has been seen for long enough
				foreach ( visible_location in visible_locations_from_hide )
				{
					total_time_waited = 0;
					while( visible_location.frames_visible < SCR_CONST_frames_needed_visible && total_time_waited < (SCR_CONST_frames_needed_visible * 4 / 20) )
					{
						self BotLookAtPoint( visible_location.origin + (0,0,level.bot_eye_height), 0.25, "script_search" );
						wait(0.25);
						total_time_waited += 0.25;
					}
				}
			}
		}
		
		wait(0.05);
	}
	
	self notify( "stop_location_monitoring" );
	self BotClearScriptGoal();
	if ( IsDefined(goal_node) )
		self BotSetScriptGoalNode( goal_node, goal_type, final_goal_yaw );
	else
		self BotSetScriptGoal( self.cur_defend_point_override, final_goal_radius, goal_type, final_goal_yaw );
}

bot_can_hide_at_node(node)
{
	if ( node.type == "Begin" || node.type == "End" )
		return false;
	
	if ( !self BotNodeAvailable(node) )
		return false;
	
	if ( self bot_check_team_is_using_position( node.origin, false, false, true ) )
		return false;
	
	return true;
}

monitor_cautious_approach_early_out()
{
	self endon("goal");
	self endon("bad_path");
	self endon("cautious_approach_early_out");

	capture_radius_SQ = undefined;
	if ( IsDefined( self.bot_defending_radius ) )
		capture_radius_SQ = self.bot_defending_radius * self.bot_defending_radius;
	else if ( IsDefined( self.bot_defending_nodes ) )
	{
		zone_furthest_distance = self bot_capture_zone_get_furthest_distance();
		capture_radius_SQ = zone_furthest_distance * zone_furthest_distance;
	}
	
	while(1)
	{
		if ( DistanceSquared(self.origin,self.bot_defending_center) < capture_radius_SQ )
		{
			self notify("cautious_approach_early_out");
		}
		wait(0.05);
	}
}

monitor_cautious_approach_dangerous_locations()
{
	self endon( "stop_location_monitoring" );
	
	while(1)
	{
		closest_node_to_bot = self BotGetNearestNode();
		bot_fov = self BotGetFovDot();
		for ( i = 0; i < self.locations_to_investigate.size; i++ )
		{
			//line( self.origin + (0,0,20), self.locations_to_investigate[i].origin, (1,0,0), 1.0, true, 1 );
			//bot_draw_cylinder(self.locations_to_investigate[i].origin, 10, 40, 0.05, undefined, (1,0,0), true, 4);
			AssertEx( IsDefined(self.locations_to_investigate[i].node), "Stored location " + self.locations_to_investigate[i].origin + " has no node" );
			if ( NodesVisible( closest_node_to_bot, self.locations_to_investigate[i].node, true ) )
			{
				node_within_fov = within_fov( self.origin, self.angles, self.locations_to_investigate[i].origin, bot_fov );
				if ( DistanceSquared( self.origin, self.locations_to_investigate[i].origin ) < 100 * 100 )
				{
					// Automatically "see" any close nodes immediately
					node_within_fov = true;
					self.locations_to_investigate[i].frames_visible = SCR_CONST_frames_needed_visible;
				}

				if ( node_within_fov )
				{
					self.locations_to_investigate[i].frames_visible++;
					if ( self.locations_to_investigate[i].frames_visible >= SCR_CONST_frames_needed_visible )
					{
						self.locations_to_investigate[i] = self.locations_to_investigate[self.locations_to_investigate.size-1];
						self.locations_to_investigate[self.locations_to_investigate.size-1] = undefined;
						i--;
					}
				}
			}
		}
		
		wait(0.05);
	}
}

protect_watch_allies()
{
	self notify( "protect_watch_allies" );
	self endon(  "protect_watch_allies" );
	
	next_time_check_this_ally = [];
	minimap_radius = 1050; // rough estimate
	
	while(1)
	{
		radius_around_point = 900;
		if ( IsDefined(level.protect_radius) )
			radius_around_point = level.protect_radius;

		// Get all teammates in the radius around our defense point
		teammates_defending_this_point = self bot_get_teammates_in_radius( self.bot_defending_center, radius_around_point );
		foreach( teammate in teammates_defending_this_point )
		{
			teammate.entity_number = teammate GetEntityNumber();
			if ( !IsDefined( next_time_check_this_ally[teammate.entity_number] ) )
				next_time_check_this_ally[teammate.entity_number] = GetTime() - 1;
			
			if ( teammate.health == 0 && IsDefined(teammate.deathTime) && GetTime() - teammate.deathTime < 5000 &&
			     (isDefined( teammate.lastAttacker ) && teammate.lastAttacker.team == get_enemy_team(self.team)) )
			{
				// See if we are allowed to check on this ally
				if ( GetTime() > next_time_check_this_ally[teammate.entity_number] )
				{
					// We know that this teammate died protecting the same point that this bot is protecting
					// So finally, we need to check if this bot could have seen him on his minimap
					if ( DistanceSquared( teammate.origin, self.origin ) < minimap_radius * minimap_radius )
					{
						// Inform the bot that there might be an enemy here
						self BotGetImperfectEnemyInfo( teammate.lastAttacker, teammate.origin );
						
						// Force the bot to move to that location.  Once he gets close enough, the Enemy Search should take over
						self.defense_investigate_specific_point = teammate.origin;
						self notify("defend_force_node_recalculation");
	
						// Clear out the variable, so every bot doesn't react to it (only one)
						teammate.last_killer_while_protecting = undefined;
					}
					
					// Regardless of whether we chose to check this out or not, don't take any more actions regarding this guy for 10 seconds
					next_time_check_this_ally[teammate.entity_number] = GetTime() + 10000;
				}
			}
		}
		
		wait( RandomInt(5) * 0.05 );
	}
}

bodyguard_watch_entrances()
{
	self notify( "bodyguard_watch_entrances" );
	self endon(  "bodyguard_watch_entrances" );
	
	self.bodyguard_last_entrance_pos = (0,0,0);
	
	// Wait till bot gets within the defending radius
	while( DistanceSquared( self.bot_defending_center, self.origin ) > self.bot_defending_radius * self.bot_defending_radius )
	{
		wait(0.5);
	}
	
	while(1)
	{
		if ( self BotHasScriptGoal() )
		{
			script_goal = self BotGetScriptGoal();
			script_goal_radius = self BotGetScriptGoalRadius();
			
			moved_far_enough = DistanceSquared( self.bodyguard_last_entrance_pos, self.origin ) > 150*150;
			at_script_goal = DistanceSquared( script_goal, self.origin ) < script_goal_radius * script_goal_radius;
			calculated_entrances_for_goal = DistanceSquared( script_goal, self.bodyguard_last_entrance_pos ) < script_goal_radius * script_goal_radius;
			if ( moved_far_enough || (at_script_goal && !calculated_entrances_for_goal) )
			{
				entrances_to_watch = FindEntrances( self.origin );
				nodes = GetNodesInRadius( self.bot_defending_center, 128, 0, 128 );
				if ( IsDefined(nodes) && nodes.size > 0 )
				{
					entrances_to_watch = array_add(entrances_to_watch, nodes[0]);
				}
				
				self childthread bot_watch_nodes( entrances_to_watch );
				self childthread bot_monitor_watch_entrances_bodyguard();
				
				self.bodyguard_last_entrance_pos = self.origin;
			}
		}
		
		wait(0.5);
	}
}

defense_get_initial_entrances( defense_type )
{
	if ( IsDefined(self.defense_override_entrances) )
	{
		return self.defense_override_entrances;
	}
	else if ( defense_type == "capture" || defense_type == "capture_zone" )
	{
		// If capturing a point or zone, use the pre-calculated entrances for the point
		return self bot_defend_get_precalc_entrances_for_current_area( self.cur_defend_stance );
	}
	else if ( defense_type == "protect" )
	{
		// If protecting a point, use entrances from the current position
		return FindEntrances( self.origin );
	}
}

defense_watch_entrances_at_goal()
{
	self notify( "defense_watch_entrances_at_goal" );
	self endon(  "defense_watch_entrances_at_goal" );
	self endon("new_defend_goal");
	
	entrances_to_watch = undefined;
	if ( self.bot_defending_type == "capture" || self.bot_defending_type == "capture_zone" )
	{
		precalculated_entrances = self defense_get_initial_entrances( self.bot_defending_type );
		
		// Extra check to make sure the precalculated entrances are valid for the location this bot is currently at
		entrances_to_watch = [];
		node_nearest_bot = self BotGetNearestNode();
		foreach( entrance in precalculated_entrances )
		{
			if ( NodesVisible( node_nearest_bot, entrance, true ) )
				entrances_to_watch = array_add(entrances_to_watch, entrance );
		}
	}
	else if ( self.bot_defending_type == "protect" )
	{
		entrances_to_watch = self defense_get_initial_entrances( self.bot_defending_type );
		
		// Add in node closest to the center (we should be watching that too)
		nodes = GetNodesInRadius( self.bot_defending_center, 50, 0, 128 );
		
		if ( !IsDefined(nodes) || nodes.size == 0 )
			nodes = GetNodesInRadius( self.bot_defending_center, 100, 0, 128 );
		
		if ( !IsDefined(nodes) || nodes.size == 0 )
			nodes = GetNodesInRadius( self.bot_defending_center, 200, 0, 128 );
		
		nodes = get_array_of_closest( self.bot_defending_center, nodes );

		self.node_closest_to_defend_center = nodes[0];
		entrances_to_watch = array_add(entrances_to_watch, nodes[0]);
	}
	
	if ( IsDefined( entrances_to_watch ) )
	{
		self childthread bot_watch_nodes( entrances_to_watch );
		self childthread bot_monitor_watch_entrances_at_goal();
	}
}

bot_monitor_watch_entrances_at_goal()
{
	while(1)
	{
		foreach( node in self.watch_nodes )
		{
			node.watch_node_chance[self.entity_number] = 1.0;
			
			if ( IsDefined(self.node_closest_to_defend_center) && (node == self.node_closest_to_defend_center) )
				node.watch_node_chance[self.entity_number] = 0.8;	// Node closest to the center starts out slightly lower priority
			
			if ( IsDefined( level.bot_funcs["get_watch_node_chance"] ) )
			{
				gametype_scalar = self [[level.bot_funcs["get_watch_node_chance"]]]( node );
				node.watch_node_chance[self.entity_number] *= gametype_scalar;
			}
			else
			{
				// If the gametype didn't want to do anything with this node chance, then generally ignore areas
				// that the bot predicts his allies are controlling
				if ( !self entrance_to_enemy_zone( node ) )
					node.watch_node_chance[self.entity_number] *= 0.5;
			}
			
			if ( self entrance_watched_by_ally( node ) )
				node.watch_node_chance[self.entity_number] *= 0.5;
		}

		wait(RandomFloatRange(0.4,0.6));
	}
}

bot_monitor_watch_entrances_bodyguard()
{
	while(1)
	{
		dir_to_next_path_node = undefined;
		if ( self BotHasScriptGoal() )
		{
			script_goal = self BotGetScriptGoal();
			script_goal_radius = self BotGetScriptGoalRadius();
			if ( DistanceSquared( script_goal, self.origin ) > script_goal_radius * script_goal_radius )
			{
				path = self BotGetNodesOnPath();
				if ( IsDefined(path) && path.size > 1 )
				{
					dir_to_next_path_node = VectorNormalize( (path[1].origin - self.origin) * (1,1,0) );
				}
			}
		}
		
		player_guarding_forward = AnglesToForward(self.bot_defend_player_guarding.angles) * (1,1,0);
		player_guarding_forward = VectorNormalize(player_guarding_forward);
		
		foreach( node in self.watch_nodes )
		{
			node.watch_node_chance[self.entity_number] = 1.0;
			
			// Don't look at nodes that would cause the bot to walk backwards toward his script goal
			if ( IsDefined(dir_to_next_path_node) )
			{
				self_to_this_node = VectorNormalize( (node.origin - self.origin) * (1,1,0) );
				dot_path_node_to_watch_node = VectorDot( dir_to_next_path_node, self_to_this_node );
				if ( dot_path_node_to_watch_node < 0 )
					node.watch_node_chance[self.entity_number] = 0;
			}
			
			// Tend to not look at nodes that are visible to the player this bot is guarding
			player_to_node = node.origin - self.bot_defend_player_guarding.origin;
			player_to_node = VectorNormalize(player_to_node);
			
			player_dot_facing_to_node = VectorDot( player_guarding_forward, player_to_node );
			if ( player_dot_facing_to_node > 0.6 )
				node.watch_node_chance[self.entity_number] *= 0.33;	// node is in player's view
			else if ( player_dot_facing_to_node > 0 )
				node.watch_node_chance[self.entity_number] *= 0.66;	// node is not behind player
			
			if ( !self entrance_to_enemy_zone( node ) )
				node.watch_node_chance[self.entity_number] *= 0.5;
		}

		wait(RandomFloatRange(0.4,0.6));
	}	
}

entrance_to_enemy_zone( entrance )
{
	entrance_zone_index = GetNodeZone( entrance );
	bot_to_entrance = VectorNormalize( entrance.origin - self.origin );
	
	for ( z = 0; z < GetZoneCount(); z++ )
	{
		if ( BotZoneGetCount( z, self.team, "enemy_predict" ) > 0 )
		{
			// We know that the zone has enemies
			if ( z == entrance_zone_index )
			{
				// and the entrance node is in this zone, then return true
				return true;
			}
			else
			{
				// and the entrance node is not in this zone, then compare the direction from the entrance zone to the entrance,
				// and the direction from the entrance zone to this zone.  If they are in the same direction, then consider
				// this entrance to be an entrance to an enemy zone
				bot_to_this_zone_origin = VectorNormalize( GetZoneOrigin(z) - self.origin );
				dot = VectorDot( bot_to_entrance, bot_to_this_zone_origin );
				if ( dot > 0.2 )
					return true;
			}
		}
	}
	
	return false;
}

entrance_watched_by_ally( entrance )
{
	teammates_defending_this_point = self bot_get_teammates_currently_defending_point( self.bot_defending_center );	
	foreach ( teammate in teammates_defending_this_point )
	{
		if ( entrance_watched_by_player( teammate, entrance ) )
			return true;
	}
	
	return false;
}

entrance_watched_by_player( player, entrance )
{
	player_forward = AnglesToForward(player.angles) * (1,1,0);
	player_forward = VectorNormalize(player_forward);
	player_to_node = entrance.origin - player.origin;
	player_to_node = VectorNormalize(player_to_node);
	
	player_dot_facing_to_node = VectorDot( player_forward, player_to_node );
	if ( player_dot_facing_to_node > 0.6 )
		return true;
	
	return false;
}

bot_get_teammates_currently_defending_point( point, radius_around_point )
{
	// A human player is considered defending this point if they are within the radius
	// A bot player is considered defending this point if they are within the radius, and have the location set as their defend target
	
	if ( !IsDefined(radius_around_point) )
	{
		// If no radius is defined, use 900 or the level.protect_radius
		if ( IsDefined(level.protect_radius) )
			radius_around_point = level.protect_radius;
		else
			radius_around_point = 900;
	}
	
	teammates_defending_point = [];
	teammates_in_radius = bot_get_teammates_in_radius( point, radius_around_point );
	foreach( teammate in teammates_in_radius )
	{
		if ( !IsAI( teammate ) || teammate bot_is_defending_point( point ) )
		{
			teammates_defending_point = array_add(teammates_defending_point, teammate);
		}
	}
	
	return teammates_defending_point;
}

bot_get_teammates_in_radius( point, radius_around_point )
{
	teammates_in_radius = [];
	players = bot_get_all_players_and_agents();
	foreach( other_player in players )
	{
		if ( (other_player != self) && (other_player.team == self.team) && IsTeamParticipant(other_player) )
		{
			// other_player is on my team and is counted as a team participant
			if ( DistanceSquared( point, other_player.origin ) < radius_around_point * radius_around_point )
				teammates_in_radius = array_add(teammates_in_radius, other_player);
		}
	}
	
	return teammates_in_radius;
}

defense_death_monitor()
{
	level endon( "game_ended" );
	self endon( "started_bot_defend_think" );
	self endon( "defend_stop" );
	
	self waittill("death");
	if ( IsDefined(self) )
	{
		self thread bot_defend_stop();
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_defend_stop()"
"Summary: Stops any scripted defense the bot might be doing"
"CallOn: A bot player"
"Example: self bot_defend_stop();"
///ScriptDocEnd
============
 */
bot_defend_stop( )
{
	self notify( "defend_stop" );
	self.bot_defending = undefined;
	self.bot_defending_center = undefined;
	self.bot_defending_radius = undefined;
	self.bot_defending_nodes = undefined;
	self.bot_defending_type = undefined;
	self.bot_defend_player_guarding = undefined;
	
	self.prev_defend_node = undefined;
	self.cur_defend_node = undefined;
	self.cur_defend_angle_override = undefined;
	self.cur_defend_point_override = undefined;
		
	self.defend_entrance_index = undefined;
	self.defense_override_entrances = undefined;
	self BotClearScriptGoal();
	self BotSetStance("none");
}

defend_get_ally_bots_at_zone_for_stance( stance )
{
	other_players_with_same_stance = [];
	
	players = bot_get_all_players_and_agents();
	foreach( other_player in players )
	{
		if ( other_player.team == self.team && other_player != self && IsAIGameParticipant(other_player) && other_player bot_is_defending() && other_player.cur_defend_stance == stance )
		{
			if ( other_player.bot_defending_type == self.bot_defending_type && self bot_is_defending_point( other_player.bot_defending_center ) )
			{
				other_players_with_same_stance = array_add(other_players_with_same_stance, other_player);
			}
		}
	}
	
	return other_players_with_same_stance;
}

monitor_defend_player()
{
	while(1)
	{
		if ( !IsDefined(self.bot_defend_player_guarding) )
		{
			self thread bot_defend_stop();
		}
		
		self.bot_defending_center = self.bot_defend_player_guarding.origin;
		
		if ( self BotGetScriptGoalType() != "none" )
		{
			script_goal = self BotGetScriptGoal();
			
			player_guarding_velocity = self.bot_defend_player_guarding GetVelocity();
			normalized_velocity = VectorNormalize(player_guarding_velocity);
			if ( LengthSquared(player_guarding_velocity) > 100 )
			{
				// If player is moving, check that the node destination is still in front of the player
				
				player_to_script_goal = VectorNormalize( script_goal - self.bot_defend_player_guarding.origin );
				if ( VectorDot( player_to_script_goal, normalized_velocity ) < 0.1 )
				{
					self notify("defend_force_node_recalculation");	// force bot to pick a new spot
				}
			}
			else
			{
				// If player is not moving, check that the node destination lies in the defending radius
				
				distSQ = DistanceSquared(script_goal, self.bot_defending_center);
				if ( distSQ > self.bot_defending_radius * self.bot_defending_radius )
				{
					self notify("defend_force_node_recalculation");	// force bot to pick a new spot
				}
			}
		}
		
		wait(0.1);
	}
}

find_defend_node_capture()
{
	entrance_point = self bot_defend_get_random_entrance_point_for_current_area();
	
	node = self bot_find_node_to_capture_point( self.bot_defending_center, self.bot_defending_radius, entrance_point, ::bot_can_use_node_in_defend );
	
	if ( IsDefined(node) )
    {
		if ( IsDefined(entrance_point) )
	    {
    		node_to_entrance = VectorNormalize(entrance_point - node.origin);
			self.cur_defend_angle_override = VectorToAngles(node_to_entrance);
		}
		else
		{
 			center_to_node = VectorNormalize(node.origin - self.bot_defending_center);
			self.cur_defend_angle_override = VectorToAngles(center_to_node);
		}
		self.cur_defend_node = node;
    }
	else
	{
		if ( IsDefined(entrance_point) )
		{
			self bot_handle_no_valid_defense_node(entrance_point, undefined);
		}
		else
		{
			self bot_handle_no_valid_defense_node(undefined, self.bot_defending_center);
		}
	}
}

find_defend_node_capture_zone()
{
	entrance_point = self bot_defend_get_random_entrance_point_for_current_area();
	
	node = self bot_find_node_to_capture_zone( self.bot_defending_nodes, self.bot_defending_center, entrance_point, ::bot_can_use_node_in_defend );
	
	if ( IsDefined(node) )
    {
		if ( IsDefined(entrance_point) )
	    {
	    	node_to_entrance = VectorNormalize(entrance_point - node.origin);
			self.cur_defend_angle_override = VectorToAngles(node_to_entrance);
		}
		else
		{
 			center_to_node = VectorNormalize(node.origin - self.bot_defending_center);
			self.cur_defend_angle_override = VectorToAngles(center_to_node);
		}
		self.cur_defend_node = node;
    }
}

find_defend_node_protect()
{
	node = self bot_find_node_that_protects_point( self.bot_defending_center, self.bot_defending_radius, ::bot_can_use_node_in_defend );

	if ( IsDefined( node ) ) 
	{
		node_to_center = VectorNormalize(self.bot_defending_center - node.origin);
		self.cur_defend_angle_override = VectorToAngles(node_to_center);
		self.cur_defend_node = node;
	}
	else
	{
		self bot_handle_no_valid_defense_node(self.bot_defending_center, undefined);
	}
}

find_defend_node_bodyguard()
{
	node = self bot_find_node_to_guard_player( self.bot_defending_center, self.bot_defending_radius, ::bot_can_use_node_in_defend );
	
	if ( IsDefined(node) )
    {
		self.cur_defend_node = node;
    }
	else
	{
		self bot_handle_no_valid_defense_node(undefined, self.bot_defending_center);
	}
}

bot_handle_no_valid_defense_node(face_towards_point, face_away_from_point)
{
	assert( (!IsDefined(face_towards_point) && IsDefined(face_away_from_point)) || (IsDefined(face_towards_point) && !IsDefined(face_away_from_point)) );
	
	self.cur_defend_point_override = self bot_pick_random_point_in_radius(self.bot_defending_center, self.bot_defending_radius, ::bot_can_use_point_in_defend, 0.15, 0.9);
		
	// face towards / away from a point
	if ( IsDefined(face_towards_point) )
	{
		angle_dir = VectorNormalize(face_towards_point - self.cur_defend_point_override);
		self.cur_defend_angle_override = VectorToAngles(angle_dir);
	}
	else if ( IsDefined(face_away_from_point) )
	{
		angle_dir = VectorNormalize(self.cur_defend_point_override - face_away_from_point);
		self.cur_defend_angle_override = VectorToAngles(angle_dir);
	}
}

bot_can_use_node_in_defend(node)
{
	if ( !IsDefined(node) )
		return false;
	
	if ( node.type == "Begin" || node.type == "End" )
		return false;
	
	if ( !self BotNodeAvailable(node) )
		return false;
	
	// check if a human player is standing near this node
	if ( self bot_check_team_is_using_position( node.origin, true, false, false ) )
		return false;
	
	return true;
}

bot_can_use_point_in_defend(point)
{
	if ( self bot_check_team_is_using_position( point, true, true, true ) )
		return false;
	
	return true;
}

SCR_CONST_player_close_dist = 21;

bot_check_team_is_using_position( position, check_human_player_near, check_bot_player_near, check_bot_destination_near )
{
	players = bot_get_all_players_and_agents();
	foreach( other_player in players )
	{
		if ( other_player.team == self.team && other_player != self )
		{
			if ( IsAI( other_player ) )
			{
				if ( check_bot_player_near )
				{
					// Check if a bot player is standing near this node
					if ( DistanceSquared(position,other_player.origin) < SCR_CONST_player_close_dist * SCR_CONST_player_close_dist )
					{
						return true;
					}
				}
				
				if ( check_bot_destination_near && other_player BotHasScriptGoal() )
				{
					// Check if bot player has a goal near this point
					bot_goal = other_player BotGetScriptGoal();
					if ( DistanceSquared(position,bot_goal) <  SCR_CONST_player_close_dist * SCR_CONST_player_close_dist )
					{
						return true;
					}
				}
			}
			else
			{
				if ( check_human_player_near )
				{
					// Check if a human player is standing near this node
					if ( DistanceSquared(position,other_player.origin) <  SCR_CONST_player_close_dist * SCR_CONST_player_close_dist )
					{
						return true;
					}
				}
			}
		}
	}
	
	return false;
}

bot_capture_zone_get_furthest_distance()
{
	furthest_dist = 0;
	if ( IsDefined(self.bot_defending_nodes) )
	{
		foreach( node in self.bot_defending_nodes )
		{
			dist_to_node = Distance(self.bot_defending_center,node.origin);
			furthest_dist = max(dist_to_node,furthest_dist);
		}
	}
		
	return furthest_dist;
}

// Tactical Goal Explanation
// =========================
// Mandatory args
// tactical_goal.type				The type of goal.  Used with bot_has_tactical_goal so different goals can check if they already exist in the list before trying to add a new one
// tactical_goal.goal_position		The position of the goal
// tactical_goal.priority			The priority of this goal.  0 to 100, with 100 being highest priority

// Optional Args
// tactical_goal.object				The object we are going after
// tactical_goal.goal_type			Type of goal pathing to use - "tactical", "critical", "guard", etc."
// tactical_goal.goal_yaw			The yaw of the goal
// tactical_goal.goal_radius		The radius of the goal
// tactical_goal.objective_radius	Radius to use when setting an objective goal (using the goal_type above)
// tactical_goal.start_thread		This function is called when the goal starts
// tactical_goal.end_thread			This function is called when the goal ends, regardless of it it was successful or not.
// tactical_goal.should_abort		This function is called every frame while the goal is active.  If it ever returns true, the goal is aborted.
// tactical_goal.action_thread		This function is called when the goal is reached.  It contains some action for the bot to perform.

				
bot_think_tactical_goals()
{
	self notify( "bot_think_tactical_goals" );
	self endon(  "bot_think_tactical_goals" );
		
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	self.tactical_goals = [];
	while(1)
	{
		if ( IsDefined(self.tactical_goals[0]) )
		{
			new_goal = self.tactical_goals[0];
			
			if ( !IsDefined( new_goal.abort ) )
			{			
				self notify( "start_tactical_goal" );
				
				if ( IsDefined(new_goal.start_thread) )
				{
					self [[new_goal.start_thread]](new_goal);
				}
				
				self childthread watch_goal_aborted( new_goal );
				
				goal_type = "tactical";
				if ( IsDefined(new_goal.goal_type) )
				    goal_type = new_goal.goal_type;
				
				//PrintLn("*** Bot " + self.name + " starting tactical goal of '" + new_goal.type + "' and goal_type of '" + goal_type + "'\n");
				self BotSetScriptGoal( new_goal.goal_position, new_goal.goal_radius, goal_type, new_goal.goal_yaw, new_goal.objective_radius);
				
				result = self bot_waittill_goal_or_fail( undefined, "stop_tactical_goal" );
				if ( result == "goal" )
				{
					//PrintLn("*** Bot " + self.name + " reached tactical goal of '" + new_goal.type + "' and goal_type of '" + goal_type + "'\n");
					
					if ( IsDefined(new_goal.action_thread) )
						self [[new_goal.action_thread]](new_goal);
				}
				
				if ( result != "goal_changed" )
				{
					self BotClearScriptGoal();
				}
				
				if ( IsDefined(new_goal.end_thread) )
				{
					self [[new_goal.end_thread]](new_goal);
				}
			}
			
			self.tactical_goals = array_remove(self.tactical_goals, new_goal);
		}
		
		wait(0.05);
	}
}

watch_goal_aborted( goal )
{
	self endon("stop_tactical_goal");
	self endon("goal");
	self endon("bad_path");
	
	wait(0.05);	// allow time for execution to reach the "waittill_any_return" line before calling this for the first time
	
	while(1)
	{
		if ( IsDefined( goal.abort ) || (IsDefined(goal.should_abort) && self [[goal.should_abort]](goal)) )
			self notify("stop_tactical_goal");
		
		wait(0.05);
	}
}

/* 
=============
///ScriptDocBegin
"Name: bot_new_tactical_goal( <type>, <goal_position>, <priority>, <extra_params> )"
"Summary: Adds a new tactical goal for this bot"
"CallOn: A bot player"
"MandatoryArg: <type> : Type of tactical goal this is ("seek_dropped_weapon", etc.)"
"MandatoryArg: <goal_position> : Position of the goal"
"MandatoryArg: <priority> : The priority of this goal, from 0 to 100. 100 is the highest priority"
"OptionalArg: <extra_params> : A struct with optional parameters.  Listed below"
"Example: self bot_new_tactical_goal( "kill_tag", self.tag_getting.curorigin, 0, undefined, undefined, 25, self.tag_getting, undefined, ::tag_end, ::goal_tag_picked_up, undefined );"
"NoteLine: All of the "threads" listed below are actually function calls - they are not threaded"
"NoteLine: <extra_params.object> : The object of the tactical goal.  Used with bot_has_tactical_goal, to determine duplicate goals"
"NoteLine: <extra_params.script_goal_type> : Type of goal pathing to use - "tactical", "critical", "guard", etc."
"NoteLine: <extra_params.script_goal_yaw> : Goal yaw to use when pathing to this goal"
"NoteLine: <extra_params.script_goal_radius> : Goal radius to use when pathing to this goal"
"NoteLine: <extra_params.start_thread> : A function to execute when this tactical goal starts
"NoteLine: <extra_params.end_thread> : A function to execute when this tactical goals ends, regardless of it was successful or not"
"NoteLine: <extra_params.should_abort> : A function that is called to determine if the tactical goal should end early.  Should return true in that case"
"NoteLine: <extra_params.action_thread> : A function to execute if the bot reaches his tactical goal"
"NoteLine: <extra_params.objective_radius> : Radius to use when setting an objective goal"
///ScriptDocEnd
============
 */
bot_new_tactical_goal( type, goal_position, priority, extra_params )
{
	new_goal = SpawnStruct();
	new_goal.type = type;
	new_goal.goal_position = goal_position;
	
	if ( IsDefined(self.disable_tactical_goals) && self.disable_tactical_goals )
		return;

	assert( priority >= 0 && priority <= 100 );
	new_goal.priority = priority;
	
	new_goal.object = extra_params.object;
	
	new_goal.goal_type = extra_params.script_goal_type;
	new_goal.goal_yaw = extra_params.script_goal_yaw;
	new_goal.goal_radius = 0;
	if ( IsDefined( extra_params.script_goal_radius ) )
		new_goal.goal_radius = extra_params.script_goal_radius;
	
	new_goal.start_thread = extra_params.start_thread;
	new_goal.end_thread = extra_params.end_thread;
	new_goal.should_abort = extra_params.should_abort;
	new_goal.action_thread = extra_params.action_thread;
	new_goal.objective_radius = extra_params.objective_radius;
	
	// iterate through self.tactical_goals and place this goal in the correct priority
	for ( position_to_add=0; position_to_add<self.tactical_goals.size; position_to_add++ )
	{
		if ( new_goal.priority > self.tactical_goals[position_to_add].priority )
			break;
	}
	
	// insert tactical goal at self.tactical_goals[position_to_add], pushing everything (including the element already in position_to_add) back one element
	for ( i=self.tactical_goals.size-1; i>=position_to_add; i-- )
	{
		self.tactical_goals[i+1] = self.tactical_goals[i];
	}
	
	self.tactical_goals[position_to_add] = new_goal;
}

/* 
=============
///ScriptDocBegin
"Name: bot_has_tactical_goal( <goal_type>, <object> )"
"Summary: Checks if a bot already has a tactical goal of this type"
"CallOn: A bot player"
"OptionalArg: <type> : Type of tactical goal to check"
"OptionalArg: <object> : The object of the tactical goal.  Used to differentiate two different goals of the same type"
"Example: if ( self bot_has_tactical_goal( "seek_dropped_weapon", dropped_weapon ) == false )"
///ScriptDocEnd
============
 */
bot_has_tactical_goal( goal_type, object )
{
	if ( !IsDefined( self.tactical_goals ) )
		return false;
	
	if ( IsDefined( goal_type ) )
	{
		foreach( goal in self.tactical_goals )
		{
			if ( goal.type == goal_type )
			{
				if ( IsDefined(object) && IsDefined(goal.object) )
				{
					return (goal.object == object);
				}
				else
				{
					return true;
				}
			}
		}
		
		return false;
	}
	else
	{
		return (self.tactical_goals.size > 0);
	}
}


/* 
=============
///ScriptDocBegin
"Name: bot_abort_tactical_goal( <goal_type>, <object> )"
"Summary: Aborts any active tactical goal matching the type (and optionally specific object)"
"CallOn: A bot player"
"MandatoryArg: <type> : Type of tactical goal to check"
"OptionalArg: <object> : The object of the tactical goal.  Used to differentiate two different goals of the same type"
"Example: self bot_abort_tactical_goal( "seek_dropped_weapon" )"
///ScriptDocEnd
============
 */
bot_abort_tactical_goal( goal_type, object )
{
	assert( IsDefined( goal_type ) );

	if ( !IsDefined( self.tactical_goals ) )
		return;
		
	foreach( goal in self.tactical_goals )
	{
		if ( goal.type == goal_type )
		{
			if ( IsDefined(object) )
			{
				if ( IsDefined(goal.object) && (goal.object == object) )
					goal.abort = true;
			}
			else
			{
				goal.abort = true;
			}
		}
	}
}


/* 
=============
///ScriptDocBegin
"Name: bot_disable_tactical_goals()"
"Summary: Disables tactical goals for this bot, and clears out any current ones"
"CallOn: A bot player"
"Example: self bot_disable_tactical_goals())"
///ScriptDocEnd
============
 */
bot_disable_tactical_goals()
{
	self.disable_tactical_goals = true;
	self.tactical_goals = [];
}

/* 
=============
///ScriptDocBegin
"Name: bot_enable_tactical_goals()"
"Summary: Enables tactical goals for this bot.  Note: Only needs to be called if bot_disable_tactical_goals was previously called on this bot."
"CallOn: A bot player"
"Example: self bot_enable_tactical_goals())"
///ScriptDocEnd
============
 */
bot_enable_tactical_goals()
{
	self.disable_tactical_goals = undefined;
}