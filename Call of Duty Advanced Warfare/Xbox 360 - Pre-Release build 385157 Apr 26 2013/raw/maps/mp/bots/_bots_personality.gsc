// Personality functions for bots

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_loadout;
#include maps\mp\bots\_bots_strategy;

//=======================================================
//			setup_personalities
//=======================================================
setup_personalities()
{
	level.bot_personality = [];
	level.bot_personality[0] = "default";
	level.bot_personality[1] = "run_and_gun";
	level.bot_personality[2] = "camper";
	
	level.bot_personality_index = [];
	foreach( pers in level.bot_personality )
		level.bot_personality_index[pers] = level.bot_personality_index.size;

	level.bot_pers_init = [];
	level.bot_pers_init["default"] = ::init_personality_default;
	level.bot_pers_init["camper"] = ::init_personality_camper;
	
	level.bot_pers_class["default"] = ::class_choose_default;
	level.bot_pers_class["camper"] = ::class_choose_camper;
	level.bot_pers_class["run_and_gun"] = ::class_choose_run_and_gun;

	level.bot_pers_update["default"] = ::update_personality_default;
	level.bot_pers_update["camper"] = ::update_personality_camper;
	// For now run_and_gun behaves exactly the same as default
	// level.bot_pers_class["run_and_gun"] = ::update_personality_run_and_gun;
}

//=======================================================
//			assign_personality_functions
//=======================================================
bot_assign_personality_functions()
{
	self.personality = self BotGetPersonality();
	
	self.personality_init_function = level.bot_pers_init[self.personality];
	if ( !IsDefined(self.personality_init_function) )
	{
		self.personality_init_function = level.bot_pers_init["default"];
	}
	
	// Call the init function now
	self [[ self.personality_init_function ]]();
	
	self.personality_update_function = level.bot_pers_update[self.personality];
	if ( !IsDefined(self.personality_update_function) )
	{
		self.personality_update_function = level.bot_pers_update["default"];
	}

	self.personality_class_function = level.bot_pers_class[self.personality];
	if ( !IsDefined(self.personality_class_function) )
	{
		self.personality_class_function = level.bot_pers_class["default"];
	}
}

//=======================================================
//				bot_balance_personality
//=======================================================
bot_balance_personality()
{
	if( IsDefined(self.personalityManuallySet) && self.personalityManuallySet )
	{
		return;
	}
	
	persCounts = [];
	teamCount = 0;
	foreach( bot in level.players )
	{
		if ( IsBot( bot ) && (bot.team == self.team) && (bot != self) )
		{
			teamCount++;
			personality = bot BotGetPersonality();
			if ( !IsDefined( persCounts[personality] ) )
				persCounts[personality] = 1;
			else
				persCounts[personality] = persCounts[personality] + 1;
		}
	}

	myPersonality = self BotGetPersonality();
	start = myPersonality;
	persLimit = int((teamCount / level.bot_personality.size) + 1);
	
	while ( IsDefined( persCounts[myPersonality] ) && persCounts[myPersonality] >= persLimit )
	{
		newIndex = level.bot_personality_index[myPersonality] + 1;
		if ( !IsDefined( level.bot_personality[newIndex] ) )
			newIndex = 0;
		myPersonality = level.bot_personality[newIndex];
		if ( myPersonality == start )
			break;
	}
	
	if ( myPersonality != start )
		self BotSetPersonality( myPersonality );
}
	
//=======================================================
//				init_camper_data
//=======================================================
init_personality_camper()
{
	clear_camper_data();
}

//=======================================================
//				init_personality_default
//=======================================================
init_personality_default()
{
	
}

//=======================================================
//				update_personality_camper
//=======================================================
update_personality_camper()
{
	if ( should_select_new_ambush_point() && !self bot_is_defending() )
	{	
		// If we took a detour to "hunt" then wait till that goal gets cleared before camping again
		goalType = self BotGetScriptGoalType();
		foundCampNode = false;
		if ( goalType != "hunt" )
			foundCampNode = self find_camp_node();
				
		if ( foundCampNode )
		{
			self.ambush_entrances = self bot_find_ambush_entrances( self.node_ambushing_from.origin );

			// If applicable, plant a trap to cover our rear first		
			trapTime = GetTime();
			self bot_set_optional_ambush_trap( self.ambush_entrances, self.node_ambushing_from, self.ambush_yaw );
			trapTime = GetTime() - trapTime;
			if ( trapTime > 0 && IsDefined( self.ambush_end ) && IsDefined( self.node_ambushing_from ) )
			{
				self.ambush_end += trapTime;
				self.node_ambushing_from.bot_ambush_end = self.ambush_end + 10000;
			}

			if ( !(self bot_has_tactical_goal()) && !self bot_is_defending() )
			{	
				// Go to the ambush point
				self BotSetScriptGoalNode( self.node_ambushing_from, "camp", self.ambush_yaw );			
				self thread clear_script_goal_on( "bad_path", "node_relinquished" );
			
				// When we get there add in the travel time to our camping timer
				self thread bot_add_ambush_time_delayed( "clear_camper_data", "goal" );
				
				// When we get there look toward each of the entrances periodically
				self thread bot_watch_entrances_delayed( "clear_camper_data", "bot_add_ambush_time_delayed", self.ambush_entrances, self.ambush_yaw );
			}
		}
		else
		{
			// Hunt until we can find a reasonable camping spot to use
			if ( goalType == "camp" )
				self BotClearScriptGoal();
			update_personality_default();
		}
	}
}

//=======================================================
//			update_personality_default
//=======================================================
update_personality_default()
{
	script_goal = undefined;
	if ( self BotHasScriptGoal() )
	{
		script_goal = self BotGetScriptGoal();
	}
	
	if ( !(self bot_has_tactical_goal()) )
	{	
		distSq = undefined;
		goalRadius = undefined;
		
		if ( IsDefined(script_goal) ) 
		{
			distSq = DistanceSquared(self.origin,script_goal);
			goalRadius = self BotGetScriptGoalRadius();
			goalRadiusDbl = goalRadius * 2;
			
			if ( IsDefined( self.bot_memory_goal ) && distSq < squared(goalRadiusDbl) )
			{
				flagInvestigated = BotMemoryFlags( "investigated" );
				BotFlagMemoryEvents( 0, GetTime() - self.bot_memory_goal_time, 1, self.bot_memory_goal, goalRadiusDbl, "kill", flagInvestigated, self );
				BotFlagMemoryEvents( 0, GetTime() - self.bot_memory_goal_time, 1, self.bot_memory_goal, goalRadiusDbl, "death", flagInvestigated, self );
				self.bot_memory_goal = undefined;
				self.bot_memory_goal_time = undefined;
			}
		}
		
		if ( !IsDefined(script_goal) || (distSq < squared(goalRadius)) )
		{
			set_random_path = self bot_random_path();
			if ( set_random_path )
			{
				self thread bot_notify_on_lost_enemy( "lost_enemy" );
				self thread clear_script_goal_on( "lost_enemy", "bad_path", "goal", "node_relinquished", "search_end" );
			}
		}
	}
}

//=======================================================
//			clear_script_goal_on
//=======================================================
clear_script_goal_on( event1, event2, event3, event4, event5 )
{
	self notify("clear_script_goal_on");
	self endon ("clear_script_goal_on");
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_tactical_goal" );
	
	self waittill_any( event1, event2, event3, event4, event5 );
	
	self BotClearScriptGoal();
}

//=======================================================
//			bot_add_ambush_time_delayed
//=======================================================
bot_add_ambush_time_delayed( endEvent, waitFor )
{
	self notify( "bot_add_ambush_time_delayed" );
	self endon( "bot_add_ambush_time_delayed" );
	self endon( "death" );
	self endon( "disconnect" );

	if ( IsDefined( endEvent ) )
		self endon( endEvent );
	self endon( "node_relinquished" );
	self endon( "bad_path" );
	
	// Add in how long we waited to the self.ambush_end time
	startTime = GetTime();
	
	if ( IsDefined( waitFor ) )
		self waittill( waitFor );
	
	if ( IsDefined( self.ambush_end ) && IsDefined( self.node_ambushing_from ) )
	{
		self.ambush_end += GetTime() - startTime;
		self.node_ambushing_from.bot_ambush_end = self.ambush_end + 10000;
	}
	self notify( "bot_add_ambush_time_delayed" );
}

//=======================================================
//			bot_watch_entrances_delayed
//=======================================================
bot_watch_entrances_delayed( endEvent, waitFor, entrances, yaw )
{
	self notify( "bot_watch_entrances_delayed" );
	
	if ( entrances.size > 0 )
	{
		self endon( "bot_watch_entrances_delayed" );
		self endon( "death" );
		self endon( "disconnect" );
	
		self endon( endEvent );
		self endon( "node_relinquished" );
		self endon( "bad_path" );
		
		if ( IsDefined( waitFor ) ) 
			self waittill( waitFor );
		
		self endon("path_enemy");
		self childthread bot_watch_nodes( entrances, yaw, 0, self.ambush_end );
		self childthread bot_monitor_watch_entrances_camp();
	}
}

bot_monitor_watch_entrances_camp()
{
	while(1)
	{
		foreach( node in self.watch_nodes )
		{
			node.watch_node_chance[self.entity_number] = 1.0;
			
			if ( !self entrance_to_enemy_zone( node ) )
				node.watch_node_chance[self.entity_number] *= 0.5;
		}

		wait(RandomFloatRange(0.4,0.6));
	}
}

//=======================================================
//			bot_find_ambush_entrances
//=======================================================
bot_find_ambush_entrances( ambush_point )
{
	// Get entrances and filter out any nodes that are too close
	entrances = FindEntrances( ambush_point );
	useEntrances = [];
	foreach ( node in entrances )
	{
		if ( DistanceSquared( self.origin, node.origin ) > 300 * 300 )
			useEntrances[useEntrances.size] = node;
	}
	return useEntrances;
}

//=======================================================
//			bot_filter_ambush_inuse
//=======================================================
bot_filter_ambush_inuse( nodes )
{
	resultNodes = [];
	
	now = GetTime();
	
	foreach( node in nodes )
	{
		if ( !IsDefined( node.bot_ambush_end ) || (now > node.bot_ambush_end) )
			resultNodes[resultNodes.size] = node;
	}
	
	return resultNodes;
}
	
//=======================================================
//			bot_filter_ambush_vicinity
//=======================================================
bot_filter_ambush_vicinity( nodes, bot, radius )
{
	resultNodes = [];
	
	radiusSq = (radius * radius);
	
	foreach( node in nodes )
	{
		tooClose = false;

		players = bot_get_all_players_and_agents();
		foreach( player in players )
		{
			if ( !tooClose && IsGameParticipant(player) && (player.team == bot.team) && (player != bot) )
			{
				if ( IsDefined( player.node_ambushing_from ) )
				{
					distSq = DistanceSquared( player.node_ambushing_from.origin, node.origin );
					tooClose = ( distSq < radiusSq );
				}
			}			
		}
		
		if ( !tooClose )
			resultNodes[resultNodes.size] = node;	
	}
	
	return resultNodes;
}

//=======================================================
//			clear_camper_data
//=======================================================
clear_camper_data()
{
	self notify( "clear_camper_data" );
	
	if ( IsDefined( self.node_ambushing_from ) && IsDefined( self.node_ambushing_from.bot_ambush_end ) )
		self.node_ambushing_from.bot_ambush_end = undefined;
	
	self.node_ambushing_from 	= undefined;
	self.point_to_ambush		= undefined;
	self.ambush_yaw				= undefined;
	self.ambush_entrances		= undefined;
	self.ambush_duration 		= RandomIntRange( 20000, 30000 );
	self.ambush_end				= -1;	
}

//=======================================================
//			should_select_new_ambush_point
//======================================================
should_select_new_ambush_point()
{
	if ( self bot_has_tactical_goal() )
		return false;

	if ( GetTime() > self.ambush_end )
		return true;
	
	if ( !self BotHasScriptGoal() )
		return true;
	
	return false;
}


//=======================================================
//					find_camp_node
//=======================================================
find_camp_node( )
{
	self clear_camper_data();
	
	wait 0.05;

	if ( GetZoneCount() <= 0 )
		return false;

	myZone = GetZoneNearest( self.origin );
	targetZone = undefined;
	nextZone = undefined;
	faceAngles = self.angles;
	
	if ( IsDefined( myZone ) )
	{
		// Get nearest zone with predicted enemies but no allies
		zoneEnemies = BotZoneNearestCount( myZone, self.team, -1, "enemy_predict", ">", 0, "ally", "<", 1 );

		// Fallback to just nearest zone with enemies if that came back empty
		if ( !IsDefined( zoneEnemies ) )
			zoneEnemies = BotZoneNearestCount( myZone, self.team, -1, "enemy_predict", ">", 0 );

		// If we have no idea where enemies are then pick the zone furthest from me
		if ( !IsDefined( zoneEnemies ) )
		{
			furthestDist = 0;
			furthestZone = -1;
			for ( z = 0; z < GetZoneCount(); z++ )
			{
				dist = Distance2D( GetZoneOrigin( z ), self.origin );
				if ( dist > furthestDist )
				{
					furthestDist = dist;
					furthestZone = z;
				}
			}
			zoneEnemies = furthestZone;
		}

		if ( IsDefined( zoneEnemies ) )
		{
			zonePath = GetZonePath( myZone, zoneEnemies );
			if ( IsDefined( zonePath ) && (zonePath.size > 0) )
			{
				index = 0;
				
				// Pick a point along the path adjacent to predicted enemies but no further than the midpoint
				while ( index <= int(zonePath.size / 2) )
				{
					targetZone = zonePath[index];
					nextZone = zonePath[int(min(index+1, zonePath.size - 1))];

					if ( BotZoneGetCount( nextZone, self.team, "enemy_predict" ) != 0 )
						break;
					
					index++;
				}

				if ( IsDefined( targetZone ) && IsDefined( nextZone ) && targetZone != nextZone )
				{
					faceAngles = GetZoneOrigin( nextZone ) - GetZoneOrigin( targetZone );
					faceAngles = VectorToAngles( faceAngles );
				}
			}
		}
	}
		
	node_to_camp = undefined;
	
	if ( IsDefined( targetZone ) )
	{
		// get set of nodes in the region we want to camp
		vicinity_radius = 800;
		nodes_to_select_from = GetZoneNodes( targetZone, 1 );
		if ( nodes_to_select_from.size > 1024 )
			nodes_to_select_from = GetZoneNodes( targetZone, 0 );
		nodes_to_select_from = bot_filter_ambush_inuse( nodes_to_select_from );
		nodes_to_select_from = bot_filter_ambush_vicinity( nodes_to_select_from, self, vicinity_radius );
		
		// get direction we want to face in that region
		randomRoll = RandomInt( 100 );
		if ( randomRoll < 66 && randomRoll >= 33 )
			faceAngles = (faceAngles[0], faceAngles[1] + 45, 0);
		else if ( randomRoll < 33 )
			faceAngles = (faceAngles[0], faceAngles[1] - 45, 0);	
				
		// Choose from only the BEST camp spots from within those nodes facing that direction
		if ( nodes_to_select_from.size > 0 )
		{
			selectCount = min( nodes_to_select_from.size * 0.15, 5 );
			node_to_camp = self BotNodePick( nodes_to_select_from, selectCount, "node_camp", AnglesToForward( faceAngles ) );
		}
	}
		
	if ( !IsDefined( node_to_camp ) || !self BotNodeAvailable( node_to_camp ) )
		return false;
	
	self.node_ambushing_from = node_to_camp;
	self.ambush_end = GetTime() + self.ambush_duration;
	self.node_ambushing_from.bot_ambush_end = self.ambush_end;
	self.ambush_yaw = faceAngles[1];
		
	return true;
}


//=======================================================
//					find_ambush_node
//=======================================================
find_ambush_node( optional_point_to_ambush )
{
	self clear_camper_data();
	
	if ( IsDefined(optional_point_to_ambush) )
	{
		self.point_to_ambush = optional_point_to_ambush;
	}
	else
	{
		// get all the high traffic nodes near the bot
		node_to_ambush = undefined;
		nodes_around_bot = GetNodesInRadius( self.origin, 5000, 0, 2000 );
		if ( nodes_around_bot.size > 0 )
		{
			node_to_ambush = self BotNodePick( nodes_around_bot, nodes_around_bot.size * 0.25, "node_traffic" );
		}
		
		if ( IsDefined( node_to_ambush ) )
		{
			self.point_to_ambush = node_to_ambush.origin;
		}
		else
		{
			return false;
		}
	}
	
	nodes_around_ambush_point = GetNodesInRadius( self.point_to_ambush, 2000, 0, 1000 );
	nodes_around_ambush_point = bot_filter_ambush_inuse( nodes_around_ambush_point );
	ambush_node_trying = undefined;
	if ( nodes_around_ambush_point.size > 0 )
	{
		ambush_node_trying = self BotNodePick( nodes_around_ambush_point, nodes_around_ambush_point.size * 0.15, "node_ambush", self.point_to_ambush );
	}
	
	if( !IsDefined( ambush_node_trying ) || !self BotNodeAvailable( ambush_node_trying )  )
		return false;
	
	self.node_ambushing_from = ambush_node_trying;
	self.ambush_end = GetTime() + self.ambush_duration;
	self.node_ambushing_from.bot_ambush_end = self.ambush_end;
	
	node_to_ambush_point = VectorNormalize( self.point_to_ambush - self.node_ambushing_from.origin );
	node_to_ambush_point_angles = VectorToAngles (node_to_ambush_point );

	self.ambush_yaw = node_to_ambush_point_angles[1];
	
	return true;
}


//=======================================================
//					bot_random_path
//=======================================================
bot_random_path()
{
	result = false;
	
	chance_to_seek_out_killer = 50;
	if ( self.personality == "camper" )
	{
		chance_to_seek_out_killer = 0;
	}
	
	goalPos = undefined;
	if ( RandomInt(100) < chance_to_seek_out_killer )
	{
		goalPos = bot_recent_point_of_interest();
	}
	
	if ( !IsDefined( goalPos ) )
	{
		// Find a random place to go
		randomNode = self BotFindNodeRandom();
		if ( IsDefined( randomNode ) )
		{
			goalPos = randomNode.origin;
		}
	}
	
	if ( IsDefined( goalPos ) )
	{
		result = self BotSetScriptGoal( goalPos, 128, "hunt" );
	}
	
	return result;
}

//=======================================================
//					class_choose functions
//=======================================================
class_choose_default()
{
	if ( self bot_setup_loadout_callback() )
		return "callback";
		
	// Randomly choose any class
	return "class" + randomInt( 5 );
}

class_choose_camper()
{
	if ( self bot_setup_loadout_callback() )
		return "callback";

	if ( RandomInt( 100 ) > 50 )
		return "class0"; // Rifleman (1 out of 2 times)
	else
		return "class3"; // Sniper (1 out of 2 times)
}

class_choose_run_and_gun()
{
	if ( self bot_setup_loadout_callback() )
		return "callback";

	randRoll = RandomInt( 60 );
	if ( randRoll < 10 )
		return "class4"; // Shotgunner (~1 out of 6 times)
	else if ( randRoll < 30 )
		return "class0"; // Rifleman (~2 out of 6 times)
	else
		return "class1"; // SMG (~3 out of 6 times)
}
