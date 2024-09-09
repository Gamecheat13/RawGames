#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

SCR_DEBUG_CAPTURE_ALL = false;		// For debugging purposes.  If true, bots will always try to capture every flag (even after they own it)
SCR_DEBUG_PROTECT_ALL = false;		// For debugging purposes.  If true, bots will always try to protect every flag (even if they don't own it)

main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
	setup_bot_greed();
}

setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_greed_think;
	level.bot_funcs["leader_dialog"] = ::bot_greed_leader_dialog;
	level.bot_funcs["get_watch_node_chance"]	= ::bot_greed_get_node_chance;
}

can_use_crate()
{
	return ( (self bot_is_defending()) && (self.bot_defending_type == "protect") );
}

setup_bot_greed()
{
	bot_waittill_bots_enabled();
	
	bot_cache_entrances_to_flags_or_radios( level.flags, "flag" );
	
	level.bot_gametype_precaching_done = true;
}

bot_greed_think()
{
	self notify( "bot_greed_think" );
	self endon(  "bot_greed_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !IsDefined(level.bot_gametype_precaching_done) )
		wait(0.05);

	self.force_new_goal = false;
	self.new_goal_time = 0;
	self BotSetFlag("separation",0);	// don't slow down when we get close to other bots

	for( ;; )
	{
		if ( self.force_new_goal )
		{
			self.new_goal_time = GetTime() - 1;
		}
		
		if ( GetTime() > self.new_goal_time )
		{
			if ( self should_delay_flag_decision() )
			{
				self.new_goal_time += 5000;
			}
			else
			{
				self.force_new_goal = false;
			self bot_choose_flag();
		}
		}
		
		wait 1;
	}
}

should_delay_flag_decision()
{
	if ( self.force_new_goal )
		return false;
	
	if ( !self bot_is_defending() )
		return false;
	
	if ( self.bot_defending_type != "capture" )
		return false;
	
	if ( self.current_flag maps\mp\gametypes\greed::getFlagTeam() == self.team )
		return false;
	
	// We are trying to capture a flag that doesn't belong to our team.  Delay the decision if we are within double the capture radius of the flag
	flag_capture_radius = get_flag_capture_radius();
	if ( DistanceSquared(self.origin, self.current_flag.origin) < (flag_capture_radius * 2) * (flag_capture_radius * 2) )
		return true;
	
	return false;
}

bot_choose_flag()
{
	flag = undefined;
	flags_to_take = [];
	flags_to_defend = [];
	neutral_flags = 0;
	for ( i = 0; i < level.flags.size; i++ )
	{
		team = level.flags[i] maps\mp\gametypes\greed::getFlagTeam();
		if ( team != self.team )
		{	
			flags_to_take[flags_to_take.size] = level.flags[i];
			
			if ( team == "neutral" )
			{
				neutral_flags++;
			}
		}
		else
		{
			flags_to_defend[flags_to_defend.size] = level.flags[i];
		}
	}
	assert( flags_to_take.size + flags_to_defend.size == 3 );	// If a greed game has more (or less) than 3 flags, we need to redo this logic
	
	// Figure out if this bot is going to attack or defend

	if ( flags_to_take.size == 3 )
	{
		// 3 flags to take, so always attack
		attacking = true;
	}
	else if ( flags_to_take.size == 2 )
	{
		// 2 flags to take (so my team has 1 flag).  Decide to attack or defend
		if ( !self bot_should_defend_flag(flags_to_defend[0], 1) )
		{
			// No need to defend, all the flags we control are fully defended already
			attacking = true;
		}
		else
		{
			// We have 1 flag that needs defending.  34% chance to defend that flag (66% chance to attack)
			// So sometimes the bots will leave this flag undefended (like human players do)
			attacking = self bot_should_attack(66);
		}
	}
	else if ( flags_to_take.size == 1 )
	{
		// 1 flag to take (so my team has 2 flags).  Decide to attack or defend
		if ( self bot_allowed_to_3_cap() )
		{
			if ( self bot_get_persistent_value("strategyLevel") == 0 )
				attacking = bot_should_attack(66);		// Dumb bots can always 3 cap.  66% chance to attack.
			else
				attacking = bot_should_attack(50);		// Smarter bots only 3-cap when they can't win with 2 flags.  50% chance to attack.
		}
		else
		{
				attacking = false;
		}
	}
	else
	{
		// 0 flags to take (so my team has 3 flags), so always defend
		attacking = false;
	}
	
	// Attack based on calculations above
	if ( attacking )
	{
		// attack a flag
		
		// sort flags into closest -> furthest
		flags_to_take_sorted = get_array_of_closest(self.origin,flags_to_take);
		
		// If the game just started, just pick a flag at random (to spread the team out a bit)
		if ( neutral_flags == 3 )
		{
			// First check who is capturing the closest flag
			allies_capturing_closest = self get_num_allies_capturing_flag(flags_to_take_sorted[0], true);
			if ( allies_capturing_closest < 2 )
			{
				flag_num = 0;
			}
			else
			{
				chance_to_take_closest = 20;
				chance_to_take_middle = 65;
				chance_to_take_farthest = 15;
				
				if ( self bot_get_persistent_value("strategyLevel") == 0 )
				{
					// Dumb bots have a higher chance to swarm the initial flag and a lower chance to be strategic and attack the middle flag
					chance_to_take_closest = 50;
					chance_to_take_middle = 25;
					chance_to_take_farthest = 25;
				}
				
				// 20% chance to assist on closest flag
				// 65% chance to attack middle flag
				// 15% chance to attack farthest flag
				random_roll = RandomInt(100);
				if ( random_roll < chance_to_take_closest )
					flag_num = 0;
				else if ( random_roll < chance_to_take_closest + chance_to_take_middle )
					flag_num = 1;
				else
					flag_num = 2;
			
			}
			
			// Use "critical" type when capturing the closest flag at the start of a match (so they capture it and don't get distracted and run off)
			goal_type = undefined;
			if ( flag_num == 0 )
				goal_type = "critical";
			
			self capture_flag(flags_to_take_sorted[flag_num], goal_type);
			return;
		}
		
		if ( flags_to_take_sorted.size == 1 )
		{
			// If there's only one flag to take (and this bot was told to attack) then no other decision necessary
			flag = flags_to_take_sorted[0];
		}
		else
		{
			// If closest flag is within 320 units (twice the capture radius) force bot to capture it
			if ( DistanceSquared(flags_to_take_sorted[0].origin,self.origin) < 320*320 )
			{
				flag = flags_to_take_sorted[0];
			}
			else
			{
				Assert( flags_to_take_sorted.size >= 2 && flags_to_take_sorted.size <= 3 );
				
				flag_combined_dist = [];
				for ( i = 0; i < flags_to_take_sorted.size; i++ )
					flag_combined_dist[i] = Distance(flags_to_take_sorted[i].origin,self.origin);
				
				if ( flags_to_defend.size == 1 )
				{
					// If our team controls one flag, add in the (weighted) distance from our flag to the flag we're testing
					weight_close_to_flag = 1.5;
					for ( i = 0; i < flag_combined_dist.size; i++ )
						flag_combined_dist[i] += (Distance(flags_to_take_sorted[i].origin,flags_to_defend[0].origin) * weight_close_to_flag);
				}
		
				if ( self bot_get_persistent_value("strategyLevel") == 0 )
				{
					// Dumb bots will be less strategic about which flag to attack.  Just pick at random with a high chance to pick the closest flag.
					random_roll = RandomInt(100);
					if ( random_roll < 50 )
					{
						flag = flags_to_take_sorted[0];
					}
					else
					{
						if ( random_roll < 50 + (50 / (flags_to_take_sorted.size - 1)) )
							flag = flags_to_take_sorted[1];
						else
							flag = flags_to_take_sorted[2];
					}
				}
				else if ( flag_combined_dist.size == 2 )
				{
					chance_to_take_flag[0] = 50;
					chance_to_take_flag[1] = 50;
		
					for ( i = 0; i < flags_to_take_sorted.size; i++ )
		{
						if ( flag_combined_dist[i] < flag_combined_dist[1-i] )
			{
							chance_to_take_flag[i]			+= 20;
							chance_to_take_flag[1-i]		-= 20;
			}
						
						if ( DistanceSquared(flags_to_take_sorted[i].origin,self.origin) < 640*640 )
						{
							chance_to_take_flag[i]			+= 15;
							chance_to_take_flag[1-i]		-= 15;
		}
		
						if ( neutral_flags > 0 )
						{
							if ( flags_to_take_sorted[i] maps\mp\gametypes\greed::getFlagTeam() == "neutral" )
		{
								chance_to_take_flag[i]		+= 15;
								chance_to_take_flag[1-i]	-= 15;
							}
						}
					}
										
					random_roll = RandomInt(100);
					if ( random_roll < chance_to_take_flag[0] )
			flag = flags_to_take_sorted[0];
					else
						flag = flags_to_take_sorted[1];
		}
				else if ( flag_combined_dist.size == 3 )
				{
					chance_to_take_flag[0] = 34;
					chance_to_take_flag[1] = 33;
					chance_to_take_flag[2] = 33;
					
					for ( i = 0; i < flags_to_take_sorted.size; i++ )
					{
						other_index_1 = (i+1) % 3;
						other_index_2 = (i+2) % 3;
						if ( flag_combined_dist[i] < flag_combined_dist[other_index_1] && flag_combined_dist[i] < flag_combined_dist[other_index_2] )
						{
							chance_to_take_flag[i]				+= 36;
							chance_to_take_flag[other_index_1]	-= 18;
							chance_to_take_flag[other_index_2]	-= 18;
						}
						
						if ( DistanceSquared(flags_to_take_sorted[i].origin,self.origin) < 640*640 )
						{
							chance_to_take_flag[i]				+= 15;
							chance_to_take_flag[other_index_1]	-= 7;
							chance_to_take_flag[other_index_2]	-= 8;
						}
						
						if ( neutral_flags > 0 )
						{
							if ( flags_to_take_sorted[i] maps\mp\gametypes\greed::getFlagTeam() == "neutral" )
							{
								chance_to_take_flag[i]				+= 15;
								chance_to_take_flag[other_index_1]	-= 7;
								chance_to_take_flag[other_index_2]	-= 8;
							}
						}
					}
					
					random_roll = RandomInt(100);
					if ( random_roll < chance_to_take_flag[0] )
						flag = flags_to_take_sorted[0];
					else if ( random_roll < chance_to_take_flag[0] + chance_to_take_flag[1] )
						flag = flags_to_take_sorted[1];
		else
						flag = flags_to_take_sorted[2];
				}
			}
		}
	}
	else
	{
		// defend a flag
		
		// sort flags into closest -> furthest
		flags_to_defend_sorted = get_array_of_closest(self.origin,flags_to_defend);
		
		// test all flags, in order from closest to furthest, to try to find one to defend
		foreach( test_flag in flags_to_defend_sorted )
		{
			if ( self bot_should_defend_flag(test_flag,flags_to_defend.size) )
			{
				flag = test_flag;
				break;
			}
		}
		
		// if we couldn't pick one (for example if all of them are well-defended)...
		if ( !IsDefined(flag) )
		{
			if ( self bot_get_persistent_value("strategyLevel") == 0 )
			{
				// Dumb bots will just defend the closest one to them
				flag = flags_to_defend[0];
			}
			else if ( flags_to_defend_sorted.size == 2 )
			{
				// Our team has 2 flags.  Check which one is closest to the enemy's flag
				flags_to_defend_sorted_to_enemy_flag = get_array_of_closest( flags_to_take[0].origin, flags_to_defend_sorted );
				
				// 70% chance to defend the flag closest to enemy flag (i.e. the flag most likely to be attacked)
				random_roll = RandomInt(100);
				if ( random_roll < 70 )
					flag = flags_to_defend_sorted_to_enemy_flag[0];
				else
					flag = flags_to_defend_sorted_to_enemy_flag[1];
			}
			else
			{
				// Our team has either 1 or 3 flags, regardless, just defend the closest one
			flag = flags_to_defend_sorted[0];
		}
	}
	}
	
	if ( attacking )
	{
		self capture_flag(flag);
	}
	else
	{
		self defend_flag(flag);
	}
}

bot_allowed_to_3_cap()
{
	// Dumb bots are always allowed to 3-cap
	if ( self bot_get_persistent_value("strategyLevel") == 0 )
		return true;
	
	enemy_score = maps\mp\gametypes\_gamescore::_getteamscore(get_enemy_team(self.team));
	my_score = maps\mp\gametypes\_gamescore::_getteamscore(self.team);
		
	enemy_team_score_needed_to_win = 200 - enemy_score;
	my_team_score_needed_to_win = 200 - my_score;
	
	need_three_flags_to_win = ( my_team_score_needed_to_win * 0.5 > enemy_team_score_needed_to_win );
	return need_three_flags_to_win;
}

bot_should_attack( chance )
{
	// Decide to attack or defend.  First test personality
	if ( self.personality == "camper" )
		return false;
	else if ( self.personality == "run_and_gun" )
		return true;
	else
		return (RandomInt(100) < chance);
}

capture_flag(flag, override_goal_type)
{
	if ( SCR_DEBUG_PROTECT_ALL )
	{
		self bot_protect_point( flag.origin, get_flag_protect_radius(), "flag" + flag.script_label );
	}
	else
	{
		self bot_capture_point( flag.origin, get_flag_capture_radius(), "flag" + flag.script_label, override_goal_type );
	}
	self.new_goal_time = GetTime() + RandomIntRange(30000, 45000);	// this doesn't matter much, as soon as the flag is captured the bot will recalculate
	self.current_flag = flag;
	self thread monitor_flag_status(flag);
}

defend_flag(flag)
{
	if ( SCR_DEBUG_CAPTURE_ALL )
	{
		self bot_capture_point( flag.origin, get_flag_capture_radius(), "flag" + flag.script_label, undefined );
	}
	else
	{
	self bot_protect_point( flag.origin, get_flag_protect_radius(), "flag" + flag.script_label );
	}
	self.new_goal_time = GetTime() + RandomIntRange(30000, 45000);
	self.current_flag = flag;
	self thread monitor_flag_status(flag);
}

get_flag_capture_radius()
{
	if ( !IsDefined(level.capture_radius) )
	{
		level.capture_radius = 158;
	}
	
	return level.capture_radius;
}

get_flag_protect_radius()
{
	if ( !IsDefined(level.protect_radius) )
	{
	// Radius for a flag "protect" will be the minimum of 1000 or (average world size / 3.5)
	worldBounds = self BotGetWorldSize();
	average_side = (worldBounds[0] + worldBounds[1]) / 2;
		level.protect_radius = min(1000,average_side/3.5);
	}
		
	return level.protect_radius;
}

bot_greed_leader_dialog( dialog, location )
{
	// Game events notified to players come in through here such as flags being captured or killstreak hardware destroyed
	
	if ( IsSubStr( dialog, "losing" ) )
	{
		// Find the flag that we are losing
		flag_script_label = GetSubStr( dialog, dialog.size - 2 );
		flag_losing = undefined;
		for ( i = 0; i < level.flags.size; i++ )
		{
			if ( flag_script_label == level.flags[i].script_label )
			{
				flag_losing = level.flags[i];
			}
		}
		
		if ( IsDefined( flag_losing ) )
		{
			// Mark it in the bot's memory
			self BotMemoryEvent( "known_enemy", undefined, flag_losing.origin );

			// Check if we're allowed to react to it
			if ( !IsDefined( self.last_losing_flag_react ) || ((GetTime() - self.last_losing_flag_react) > 10000) )
			{
				// If we are currently protecting a flag
				if ( self bot_is_defending() && self.bot_defending_type == "protect" )
				{
					// And we're close to the flag that we're losing
					if ( DistanceSquared( self.origin, flag_losing.origin ) < 700 * 700 )
					{
						// Send the bot close to that flag to secure it
						self capture_flag( flag_losing );
						self.last_losing_flag_react = GetTime();
					}
				}
			}
		}
	}
	
	// do default logic
	bot_leader_dialog( dialog, location );
}

monitor_flag_status(flag)
{
	self notify( "monitor_flag_status" );
	self endon(  "monitor_flag_status" );
	
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	prev_num_ally_flags = get_num_ally_flags(self.team);
	capture_radius_SQ = get_flag_capture_radius() * get_flag_capture_radius();
	triple_capture_radius_SQ = (get_flag_capture_radius() * 3) * (get_flag_capture_radius() * 3);
	
	keep_monitoring = true;
	while(keep_monitoring)
	{
		needs_new_goal = false;
		current_flag_team = flag maps\mp\gametypes\greed::getFlagTeam();
		cur_num_ally_flags = get_num_ally_flags(self.team);
		enemy_flags = get_enemy_flags(self.team);
		
		if ( self.bot_defending_type == "capture" )
		{
			// If we were supposed to capture a flag...
			
			if ( current_flag_team == self.team && flag.useobj.claimteam == "none")
			{
				// ...but it's already been captured (and the enemy isn't currently trying to retake it)
				if ( SCR_DEBUG_CAPTURE_ALL == false )
				needs_new_goal = true;
			}
			
			if ( cur_num_ally_flags == 2 && current_flag_team != self.team && !self bot_allowed_to_3_cap() )
			{
				// ...but my team now has two flags, and I was on the way to take the third (and I am not allowed to take a third)
				if ( DistanceSquared(self.origin, flag.origin) > capture_radius_SQ )
				{
					// if I was within the capture radius of this flag, allow me to continue capturing it (even though it will bring our team to 3 flags if I succeed)
					needs_new_goal = true;
				}
			}
			
			foreach ( enemy_flag in enemy_flags)
			{
				if ( enemy_flag != flag )
				{
					if ( DistanceSquared(self.origin, enemy_flag.origin) < triple_capture_radius_SQ )
					{
						// ... but I am pretty close to another flag, capture that one instead
				needs_new_goal = true;
			}
		}
			}
		}
		
		if ( self.bot_defending_type == "protect" )
		{
			// If if we were supposed to protect a flag...
			
			if ( current_flag_team != self.team )
			{
				// ...but our team has lost it
				if ( SCR_DEBUG_PROTECT_ALL == false )
				needs_new_goal = true;
			}
			else
			{
				if ( cur_num_ally_flags == 1 && prev_num_ally_flags > 1 )
				{
					// ...and we still hold it, but our team now only holds 1 flag (we used to have more)
					needs_new_goal = true;
				}
			}
		}
		
		prev_num_ally_flags = cur_num_ally_flags;
		
		if ( needs_new_goal )
		{
			self.force_new_goal = true;
			keep_monitoring = false;
		}
		else
		{
			wait( 1 + RandomFloatRange(0,2) );
		}
	}
}

bot_greed_get_node_chance( node )
{
	node_on_safe_path = false;
	
	self_current_flag_label = "flag" + self.current_flag.script_label;
	ally_flags = get_ally_flags( self.team );
	foreach( ally_flag in ally_flags )
	{
		if ( ally_flag != self.current_flag )
		{
			// This flag belongs to my team but it is not the one I am currently at
			// So check if this watch node is on the path from my flag to this flag

			node_on_safe_path = node node_is_on_path_from_labels(self_current_flag_label, "flag" + ally_flag.script_label);
			if ( node_on_safe_path )
			{
				// If this node is on the path from self flag to this flag, don't consider it safe if it is
				// also on the path from self flag to OTHER flag (since we'd need it still enabled in that case)
				
				third_flag = get_other_flag( self.current_flag, ally_flag );
				third_flag_team = third_flag maps\mp\gametypes\greed::getFlagTeam();
				if ( third_flag_team != self.team )
				{
					if ( node node_is_on_path_from_labels(self_current_flag_label, "flag" + third_flag.script_label) )
						node_on_safe_path = false;
				}
			}
		}
	}
	
	// Node closest to defend center always has a priority of 1.0
	if ( !IsDefined(node.node_closest_to_defend_center) && node_on_safe_path )
	{
		return 0.2;
	}
	
	return 1.0;
}

get_other_flag( flag1, flag2 )
{
	for ( i = 0; i < level.flags.size; i++ )
	{
		if ( level.flags[i] != flag1 && level.flags[i] != flag2 )
			return level.flags[i];
	}
}

get_num_allies_capturing_flag( flag, ignore_humans )
{
	num_capturing_flag = 0;
	flag_capture_radius = get_flag_capture_radius();
	
	foreach( other_player in level.players )
	{
		if ( other_player.team == self.team && other_player != self )
		{
			if ( IsBot( other_player ) )
			{
				if ( other_player bot_is_capturing_flag( flag ) )
				{
					num_capturing_flag++;
				}
			}
			else if ( !IsDefined(ignore_humans) || !ignore_humans )
			{
				if ( DistanceSquared(flag.origin,other_player.origin) < flag_capture_radius * flag_capture_radius )
				{
					num_capturing_flag++;
				}
			}
		}
	}
	
	return num_capturing_flag;
}

bot_is_capturing_flag( flag )
{
	if ( !self bot_is_defending() )
		return false;
	
	if ( self.bot_defending_type != "capture" )
		return false;
	
	return self bot_target_is_flag( flag );
}

bot_is_protecting_flag( flag )
{
	if ( !self bot_is_defending() )
		return false;
	
	if ( self.bot_defending_type != "protect" )
		return false;
	
	return self bot_target_is_flag( flag );
}

bot_target_is_flag( flag )
{
	return ( self.current_flag == flag );
}

get_num_ally_flags(team)
{
	count = 0;
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag_team = level.flags[i] maps\mp\gametypes\greed::getFlagTeam();
		if ( flag_team == team )
		{	
			count++;
		}
	}
	
	return count;
}

get_enemy_flags(team)
{
	flags = [];
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag_team = level.flags[i] maps\mp\gametypes\greed::getFlagTeam();
		if ( flag_team == get_enemy_team(team) )
		{	
			flags = array_add(flags, level.flags[i]);
		}
	}
	
	return flags;
}

get_ally_flags(team)
{
	flags = [];
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag_team = level.flags[i] maps\mp\gametypes\greed::getFlagTeam();
		if ( flag_team == team )
		{	
			flags = array_add(flags, level.flags[i]);
		}
	}
	
	return flags;
}

bot_should_defend_flag(flag, num_flags_defending)
{
	if ( num_flags_defending == 1 )
		max_num_bots_defending_this_flag = 1;
	else
		max_num_bots_defending_this_flag = 2;
	
	bots_defending_flag = get_bots_defending_flag( flag );
	
	return ( bots_defending_flag.size < max_num_bots_defending_this_flag );
}

get_bots_defending_flag( flag )
{
	flag_protect_radius = get_flag_protect_radius();
	
	bots_defending = [];
	foreach( other_player in level.players )
	{
		if ( other_player.team == self.team && other_player != self )
		{
			if ( IsBot( other_player ) )
			{
				if ( other_player bot_is_protecting_flag( flag ) )
				{
					bots_defending = array_add(bots_defending, other_player);
					}
				}
			else
			{
				if ( DistanceSquared(flag.origin,other_player.origin) < flag_protect_radius * flag_protect_radius )
				{
					bots_defending = array_add(bots_defending, other_player);
			}
			}
		}
	}
	
	return bots_defending;
}