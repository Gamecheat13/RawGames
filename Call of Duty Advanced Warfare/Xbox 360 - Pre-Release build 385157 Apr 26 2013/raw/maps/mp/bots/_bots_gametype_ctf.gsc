#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
	setup_bot_ctf();
}

setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_ctf_think;
}

setup_bot_ctf()
{
	bot_waittill_bots_enabled();
	
	level.teamFlags["allies"].label = "allies";
	level.teamFlags["axis"].label = "axis";
	
	entrance_origin_points[0] = level.teamFlags["allies"].curorigin;
	entrance_labels[0] = "flag_" + level.teamFlags["allies"].label;
	entrance_origin_points[1] = level.teamFlags["axis"].curorigin;
	entrance_labels[1] = "flag_" + level.teamFlags["axis"].label;

	bot_cache_entrances( entrance_origin_points, entrance_labels );
	
	zone = GetZoneNearest( level.teamFlags["allies"].curorigin );
	if ( IsDefined( zone ) )
		BotZoneSetTeam( zone, "allies" );
	
	zone = GetZoneNearest( level.teamFlags["axis"].curorigin );
	if ( IsDefined( zone ) )
		BotZoneSetTeam( zone, "axis" );
	
	level.bot_gametype_precaching_done = true;
}

can_use_crate()
{
	if ( IsDefined(self.carryFlag) )
	{
		return false;
	}
	
	if ( !level.teamFlags[self.team] maps\mp\gametypes\_gameobjects::isHome() )
	{
		return false;
	}
	
	return true;
}

bot_ctf_think()
{
	self notify( "bot_ctf_think" );
	self endon(  "bot_ctf_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !IsDefined(level.bot_gametype_precaching_done) )
		wait(0.05);
	
	init_bot_game_ctf();
	
	self.next_time_hunt_carrier = GetTime();
	self.next_flag_hide_time = GetTime();
	self BotSetFlag("separation",0);	// don't slow down when we get close to other bots
	
	if ( !IsDefined( level.next_game_update_time ) )
	{
		level.next_game_update_time = GetTime() - 100;
	}
	
	for( ;; )
	{
		wait(0.05);
		
		if ( GetTime() >= level.next_game_update_time )
		{
			update_game_ctf();	// update logic that isn't specific to one bot - only once a frame
			level.next_game_update_time = GetTime() + 100;
		}
		
		if ( self.health <= 0 )
		{
			// Wait to be fully spawned before acting
			continue;
		}
		
		if ( !IsDefined(self.role) )
		{
			self set_ctf_role();
		}
		
		if ( IsDefined(self.carryFlag) )
		{
			// I have the flag, so bring it home
			self clear_defend();
			if ( !IsDefined(level.flag_carriers[level.otherTeam[self.team]]) )
			{
				self BotSetScriptGoal( level.capZones[self.team].curorigin, 16, "critical" );
			}
			else if ( GetTime() > self.next_flag_hide_time )
			{
				nodes = GetNodesInRadius( level.capZones[self.team].curorigin, 900, 0, 300 );
				hide_node = self BotNodePick( nodes, nodes.size * 0.15, "node_hide" );
				if ( IsDefined( hide_node ) )
				{
					self BotSetScriptGoalNode(hide_node, "critical");
				}
				
				self.next_flag_hide_time = GetTime() + 10000;
			}
		}
		else if ( self.role == "attacker" )
		{
			if ( IsDefined(level.flag_carriers[self.team]) )
			{
				// One of my friends has the flag, so escort him
				if ( !self is_guarding_player() )
				{
					self bot_guard_player(level.flag_carriers[self.team], 400);
				}
			}
			else
			{
				// Try to get the flag
				self clear_defend();
				self BotSetScriptGoal( level.teamFlags[level.otherTeam[self.team]].curorigin, 16, "guard" );
			}
		}
		else
		{
			if ( !level.teamFlags[self.team] maps\mp\gametypes\_gameobjects::isHome() )
			{
				// My flag was taken, try to get it back
				if ( !IsDefined(level.flag_carriers[level.otherTeam[self.team]]) )
				{
					// no one is carrying flag, so run to it	
					self BotSetScriptGoal( level.teamFlags[self.team].curorigin, 16, "critical" );
				}
				else
				{
					flag_carrier = level.flag_carriers[level.otherTeam[self.team]];
					if ( GetTime() > self.next_time_hunt_carrier || self BotCanSeeEntity(flag_carrier) )
					{
						self clear_defend();
						self BotSetScriptGoal( flag_carrier.origin, 16, "critical" );						
						self.next_time_hunt_carrier = GetTime() + RandomIntRange(4500,5500);
					}
				}
			}
			else if ( !self is_protecting_flag() )
			{
				self bot_protect_point( level.teamFlags[self.team].curorigin, 600, "flag_" + level.teamFlags[self.team].label );
			}
		}
	}
}

clear_defend()
{
	if ( self bot_is_defending() )
	{
		self bot_defend_stop();
	}
}

is_guarding_player()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "bodyguard" );
}

is_protecting_flag()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "protect" );
}

set_ctf_role()
{
	self.role = level.next_role[self.team];
	
	if ( level.next_role[self.team] == "attacker" )
	{
		level.next_role[self.team] = "defender";
	}
	else if ( level.next_role[self.team] == "defender" )
	{
		level.next_role[self.team] = "attacker";
	}
}

init_bot_game_ctf()
{
	if ( IsDefined( level.bots_gametype_initialized ) && level.bots_gametype_initialized )
	{
		return;
	}
	
	level.bots_gametype_initialized = true;

	// Initial role selection
	level.next_role["allies"] = "attacker";
	level.next_role["axis"] = "attacker";
	
	level.flag_carriers = [];
}

update_game_ctf()
{
	level.flag_carriers["allies"] = undefined;
	level.flag_carriers["axis"] = undefined;
	players = bot_get_all_players_and_agents();
	foreach ( player in players )
	{
		if ( IsAlive(player) && IsDefined(player.carryFlag) )
		{
			assert( IsTeamParticipant( player ) );	// only team participants should be carrying the flag, not squadmembers
			level.flag_carriers[player.team] = player;
		}
	}
	
	allies_attackers = [];
	allies_defenders = [];
	axis_attackers = [];
	axis_defenders = [];
	players = bot_get_all_players_and_agents();
	foreach ( player in players )
	{
		if ( IsDefined(player.role) )
		{
			if ( player.team == "allies" )
			{
				if ( player.role == "attacker" )
				{
					allies_attackers[allies_attackers.size] = player;
				}
				else if ( player.role == "defender" )
				{
					allies_defenders[allies_defenders.size] = player;
				}
			}
			else if ( player.team == "axis" )
			{
				if ( player.role == "attacker" )
				{
					axis_attackers[axis_attackers.size] = player;
				}
				else if ( player.role == "defender" )
				{
					axis_defenders[axis_defenders.size] = player;
				}
			}
		}
	}
	
	if ( allies_defenders.size > allies_attackers.size )
	{
		// Too many defenders
		random(allies_defenders).role = undefined;
	}
	else if ( allies_attackers.size > allies_defenders.size + 1 )
	{
		// Too many attackers
		random(allies_attackers).role = undefined;
	}
	
	if ( axis_defenders.size > axis_attackers.size )
	{
		// Too many defenders
		random(axis_defenders).role = undefined;
	}
	else if ( axis_attackers.size > axis_defenders.size + 1 )
	{
		// Too many attackers
		random(axis_attackers).role = undefined;
	}
}