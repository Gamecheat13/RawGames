#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
	setup_bot_dd();
}

setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_demolition_think;
}

can_use_crate()
{
	return ( (self bot_is_defending()) && (self.bot_defending_type == "protect") );
}

monitor_zone_control()
{
	self notify( "monitor_zone_control" );
	self endon( "monitor_zone_control" );
	self endon( "death" );
	level endon( "game_ended" );
	
	for(;;)
	{
		wait 1;
		
		zone = GetZoneNearest( self.curorigin );
		if ( IsDefined( zone ) )
		{
			if ( self.bombPlanted )
				zoneTeam = get_enemy_team(self.ownerTeam);
			else
				zoneTeam = self.ownerTeam;
			
			BotZoneSetTeam( zone, zoneTeam );
		}
	}
}

setup_bot_dd()
{
	bot_waittill_bots_enabled();
	
	bot_setup_bombzone_bottargets();
	bot_cache_entrances_to_bombzones();
	
	foreach ( bombZone in level.bombZones )
	{
		bombZone thread monitor_zone_control();
	}
	
	level.bot_gametype_precaching_done = true;
}

bot_demolition_think()
{
	self notify( "bot_dem_think" );
	self endon(  "bot_dem_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !IsDefined(level.bot_gametype_precaching_done) )
		wait(0.05);
	
	init_bot_game_demolition();

	self BotSetFlag("separation",0);	// don't slow down when we get close to other bots
	self BotSetFlag("grenade_objectives",1);
	self.is_defusing = false;
	self.is_planting = false;
	self.current_bombzone = undefined;
	
	if ( !IsDefined( level.next_game_update_time ) )
	{
		level.next_game_update_time = GetTime() - 100;
	}
	
	for( ;; )
	{
		wait(0.05);
		
		if ( GetTime() >= level.next_game_update_time )
		{
			update_game_demolition();	// update logic that isn't specific to one bot - only once a frame
			level.next_game_update_time = GetTime() + 100;
		}
		
		if ( self.health <= 0 )
		{
			// Wait to be fully spawned before acting
			continue;
		}
		
		if ( self.pers["team"] == game["attackers"] )
		{
			if ( self.is_planting )
			{
				self plant_bomb();
			}
			else
			{
				if ( !IsDefined(self.current_bombzone) )
				{
					self.current_bombzone = self find_best_bombzone("attackers");
				}
				
				if ( IsDefined(self.current_bombzone) )
				{
					if ( is_bomb_planted_on(self.current_bombzone) && !self is_protecting_zone() )
					{
						// Protect a zone while the bomb timer is counting down
						self bot_protect_point( self.current_bombzone.botTarget.origin, 600 );
					}
					else if ( !is_bomb_planted_on(self.current_bombzone) && !self is_capturing_zone() )
					{
						// Capture a zone while a buddy is planting the bomb
						self bot_capture_point( self.current_bombzone.botTarget.origin, 350, "zone" + self.current_bombzone.label );
					}
				}
			}
		}
		else
		{
			if ( self.is_defusing )
			{
				self defuse_bomb();
			}
			else
			{
				if ( !IsDefined(self.current_bombzone) )
				{
					self.current_bombzone = self find_best_bombzone("defenders");
				}
				
				if ( IsDefined(self.current_bombzone) )
				{
					if ( is_bomb_planted_on(self.current_bombzone) && !self is_capturing_zone() )
					{
						// Capture a zone while a buddy is defusing the bomb
						self bot_capture_point( self.current_bombzone.botTarget.origin, 350, "zone" + self.current_bombzone.label );
					}
					else if ( !is_bomb_planted_on(self.current_bombzone) && !self is_protecting_zone() )
					{
						// Protect a zone to stop anyone from planting the bomb on it
						self bot_protect_point( self.current_bombzone.botTarget.origin, 600 );
					}
				}
			}
		}
	}
}

plant_bomb()
{
	goto_bomb_and_use(1);
}

defuse_bomb()
{
	goto_bomb_and_use(0);
}

// TODO: replace with _bots_util::bot_usebutton_wait
goto_bomb_and_use(plant)
{
	// path to the bomb location
	self BotSetScriptGoal( self.current_bombzone.botTarget.origin, 20, "critical", self.current_bombzone.botTarget.angles[1] );
	result = self bot_waittill_goal_or_fail( undefined, "dem_bomb_exploded", "no_longer_bomb_defuser" );
	if ( result == "goal" )
	{
		// Press the "Use" button once we're in position
		self BotPressUseButton(level.defuseTime + 2);
		self waittill_usebutton_released_or_time(level.defuseTime + 2, plant);
		if ( plant )
		{
			self.is_planting = false;
		}
		else
		{
			self.is_defusing = false;
		}
	}
}

waittill_usebutton_released_or_time(time, plant)
{
	time_started = GetTime();
	time_to_end = time_started + time*1000;
	
	wait(0.05);	// give a frame for button to be pressed
	while( self UseButtonPressed() && GetTime() < time_to_end && IsDefined(self.current_bombzone) && (plant != is_bomb_planted_on(self.current_bombzone)) )
	{
		wait(0.05);
	}
}

is_protecting_zone()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "protect" );
}

is_capturing_zone()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "capture" );
}

get_bots_using_zone(zone, team)
{
	bots = [];
	players = bot_get_all_players_and_agents();
	foreach ( player in players )
	{
		if ( IsAlive(player) && IsTeamParticipant(player) && player.pers["team"] == game[team] && IsDefined(player.current_bombzone) && player.current_bombzone == zone )
		{
			bots[bots.size] = player;
		}
	}
	
	return bots;
}

get_bot_defusing_zone(zone)
{
	bots_defending_zone = get_bots_using_zone(zone,"defenders");
	foreach ( bot in bots_defending_zone )
	{
		if ( bot.is_defusing )
		{
			return bot;	
		}
	}
	
	return undefined;
}

get_bot_planting_zone(zone)
{
	bots_attacking_zone = get_bots_using_zone(zone,"attackers");
	foreach ( bot in bots_attacking_zone )
	{
		if ( bot.is_planting )
		{
			return bot;	
		}
	}
	
	return undefined;
}

find_best_bombzone(team)
{
	potential_bombZones = [];
	foreach ( zone in level.bombZones )
	{
		if ( zone.visibleteam == "any" )
		{
			// bombzone has not been destroyed
			zone_has_space = false;
			if ( team == "defenders" )
			{
				zone_has_space = zone.bots_defending_wanted > get_bots_using_zone(zone,"defenders").size;
			}
			else if ( team == "attackers" )
			{
				zone_has_space = zone.bots_attacking_wanted > get_bots_using_zone(zone,"attackers").size;
			}
			
			if ( zone_has_space )
			{
				potential_bombZones[potential_bombZones.size] = zone;
			}
		}
	}
	
	closest_zone = undefined;
	if ( potential_bombZones.size > 0 )
	{
		closest_zone_distSQ = 999999999;
		foreach( zone in potential_bombZones )
		{
			distSQ = DistanceSquared(zone.botTarget.origin,self.origin);
			if ( distSQ < closest_zone_distSQ )
			{
				closest_zone = zone;
				closest_zone_distSQ = distSQ;
			}
		}	
	}
	
	return closest_zone;
}

update_game_demolition()
{
	active_bombZones = [];
	foreach ( zone in level.bombZones )
	{
		if ( zone.visibleteam == "any" )
		{
			// bombzone has not been destroyed
			active_bombZones[active_bombZones.size] = zone;
		}
	}
	
	if ( level.prev_num_active_zones == 2 && active_bombZones.size == 1 )
	{
		players = bot_get_all_players_and_agents();
		foreach ( player in players )
		{
			if ( IsTeamParticipant(player) && IsDefined(player.current_bombzone) && player.current_bombzone != active_bombZones[0] )
			{
				player.current_bombzone = undefined;
				player bot_defend_stop();
				player notify("dem_bomb_exploded");
				player.is_defusing = false;
				player.is_planting = false;
			}
		}
		
		level.prev_num_active_zones = 1;	
	}
	
	update_demolition_attackers(active_bombZones);
	update_demolition_defenders(active_bombZones);
}

update_demolition_attackers(active_bombZones)
{
	if ( GetTime() > level.next_target_switch_time )
	{
		level.current_zone_target = 1 - level.current_zone_target;
		level.next_target_switch_time = GetTime() + 90 * 1000;
	}
	
	total_alive_attackers = 0;
	players = bot_get_all_players_and_agents();
	foreach ( player in players )
	{
		if ( IsAITeamParticipant(player) && IsAlive( player ) && player.team == game["attackers"] )
		{
			total_alive_attackers++;
		}
	}
	
	//	Determine how many attackers should be at each zone
	if ( active_bombZones.size == 2 )
	{
		if ( total_alive_attackers >= 2 )
		{
			active_bombZones[1-level.current_zone_target].bots_attacking_wanted = 1;
		}
		else
		{
			active_bombZones[1-level.current_zone_target].bots_attacking_wanted = 0;
		}
		
		active_bombZones[level.current_zone_target].bots_attacking_wanted = total_alive_attackers - active_bombZones[1-level.current_zone_target].bots_attacking_wanted;
	}
	else if ( active_bombZones.size == 1 )
	{
		active_bombZones[0].bots_attacking_wanted = total_alive_attackers;
	}
	
	// Check if a zone has too many bots
	foreach ( zone in active_bombZones )
	{
		bots_attacking_zone = get_bots_using_zone(zone,"attackers");
		if ( bots_attacking_zone.size > zone.bots_attacking_wanted )
		{
			bots_attacking_zone = array_randomize(bots_attacking_zone);
			foreach ( bot in bots_attacking_zone )
			{
				if ( !bot.is_planting )
				{
					bot.current_bombzone = undefined;
					bot bot_defend_stop();
					break;
				}
			}
		}
	}
	
	// Check if we need to pick a bomb planter
	foreach ( zone in active_bombZones )
	{
		if ( !is_bomb_planted_on(zone) && !IsDefined(get_bot_planting_zone(zone)) )
		{
			// Pick a bot to plant this bomb
			bots_attacking_zone = get_bots_using_zone(zone,"attackers");
			if ( bots_attacking_zone.size > 0 )
			{
				bots_attacking_zone_sorted = get_array_of_closest(zone.botTarget.origin,bots_attacking_zone);
				bots_attacking_zone_sorted[0].is_planting = true;
				bots_attacking_zone_sorted[0] bot_defend_stop();
			}
		}
	}
}

update_demolition_defenders(active_bombZones)
{	
	total_alive_defenders = 0;
	players = bot_get_all_players_and_agents();
	foreach ( player in players )
	{
		if ( IsAITeamParticipant(player) && IsAlive( player ) && player.team == game["defenders"] )
		{
			total_alive_defenders++;
		}
	}
	
	//	Determine how many defenders should be at each zone
	if ( active_bombZones.size == 2 )
	{
		active_bombZones[0].bots_defending_wanted = int( total_alive_defenders / 2 );
		active_bombZones[1].bots_defending_wanted = int( total_alive_defenders / 2 );
		active_bombZones[level.more_populated_bombzone].bots_defending_wanted += total_alive_defenders % 2;
		
		for ( i=0; i<active_bombZones.size; i++ )
		{
			if ( is_bomb_planted_on(active_bombZones[i]) )
			{
				active_bombZones[i].bots_defending_wanted++;
				active_bombZones[1-i].bots_defending_wanted--;
			}
		}
	}
	else if ( active_bombZones.size == 1 )
	{
		active_bombZones[0].bots_defending_wanted = total_alive_defenders;
	}
	
	// Check if a zone has too many bots
	foreach ( zone in active_bombZones )
	{
		bots_defending_zone = get_bots_using_zone(zone,"defenders");
		if ( bots_defending_zone.size > zone.bots_defending_wanted )
		{
			bots_defending_zone = array_randomize(bots_defending_zone);
			foreach ( bot in bots_defending_zone )
			{
				if ( !bot.is_defusing )
				{
					bot.current_bombzone = undefined;
					bot bot_defend_stop();
					break;
				}
			}
		}
	}
	
	// Check if we need to pick a bomb defuser
	foreach ( zone in active_bombZones )
	{
		if ( is_bomb_planted_on(zone) )
		{
			current_defuser = get_bot_defusing_zone(zone);
			if ( !IsDefined(current_defuser) || GetTime() > level.next_time_switch_defusers )
			{
				bots_defending_zone = get_bots_using_zone(zone,"defenders");
				if ( bots_defending_zone.size > 0 )
				{
					bots_defending_zone_sorted = get_array_of_closest(zone.botTarget.origin,bots_defending_zone);
					if ( !IsDefined(current_defuser) || bots_defending_zone_sorted[0] != current_defuser )
					{
						bots_defending_zone_sorted[0].is_defusing = true;
						bots_defending_zone_sorted[0] bot_defend_stop();
						
						if ( IsDefined(current_defuser) )
						{
							current_defuser.is_defusing = false;
							current_defuser notify("no_longer_bomb_defuser");
						}
					}
				}

				level.next_time_switch_defusers = GetTime() + 2500;
			}
		}
	}
}

is_bomb_planted_on(zone)
{
	return (IsDefined(zone.bombPlanted) && zone.bombPlanted == true);
}

init_bot_game_demolition()
{
	if ( IsDefined( level.bots_gametype_initialized ) && level.bots_gametype_initialized )
	{
		return;
	}
	
	level.bots_gametype_initialized = true;
	
	// Choose which bombzone has more bots at it, in the case of an odd number of bots
	level.more_populated_bombzone = RandomInt(2);
	
	// For checking when a zone is blown up
	level.prev_num_active_zones = 2;
	
	// Current target for the attackers.  Will switch eventually during the match
	level.current_zone_target = RandomInt(2);
	level.next_target_switch_time = GetTime() + 90 * 1000;
	
	// Next time to check if we need to switch defusers (to one who is closer to the bomb site)
	level.next_time_switch_defusers = 0;
}