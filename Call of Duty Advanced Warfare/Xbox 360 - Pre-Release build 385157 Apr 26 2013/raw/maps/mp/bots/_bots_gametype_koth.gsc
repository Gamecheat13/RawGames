#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
	setup_bot_koth();
}

setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_headquarters_think;
}

can_use_crate()
{
	return ( (!self bot_is_defending()) || (self.bot_defending_type == "protect") );
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
		set_hq_team = false;
		if ( IsDefined(level.radioObject) && self.trig == level.radioObject.trigger )
		{
			team = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
			if ( team != "neutral" )
			{
				zone = GetZoneNearest( self.origin );
				if ( IsDefined( zone ) )
				{
					BotZoneSetTeam( zone, team );
					set_hq_team = true;
				}
			}
		}
		
		if ( !set_hq_team )
		{
			zone = GetZoneNearest( self.origin );
			if ( IsDefined( zone ) )
			{
				BotZoneSetTeam( zone, "free" );
			}
		}
	}
}

setup_bot_koth()
{
	bot_waittill_bots_enabled();
	
	while( !IsDefined(level.radios) )
		wait(0.05);
	
	bot_setup_radio_bottargets();
	
	for ( i = 0; i < level.radios.size; i++ )
	{
		level.radios[i].script_label = "_" + i;
		level.radios[i] thread monitor_zone_control();
	}
	
	bot_cache_entrances_to_flags_or_radios( level.radios, "radio" );
	
	level.bot_gametype_precaching_done = true;
}

bot_headquarters_think()
{
	self notify( "bot_hq_think" );
	self endon(  "bot_hq_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !IsDefined(level.bot_gametype_precaching_done) )
		wait(0.05);
	
	self BotSetFlag("grenade_objectives",1);
	
	init_bot_game_headquarters();
	
	for( ;; )
	{
		wait_time = RandomIntRange(1,11) * 0.05;
		wait(wait_time);
		
		if ( self.health <= 0 )
		{
			// Wait to be fully spawned before acting
			continue;
		}
		
		if ( !IsDefined(level.radioObject) )
		{
			// No HQ yet, so just pick a random destination
			if ( self bot_is_defending() )
			{
				self bot_defend_stop();
			}
			
			needs_new_destination = true;
			if ( self BotGetScriptGoalType() != "none" )
			{
				distSQ = DistanceSquared( self BotGetScriptGoal(), self.origin );
				radius = self BotGetScriptGoalRadius();
				if ( distSQ > radius * radius )
				{
					needs_new_destination = false;	
				}
			}
			
			if ( needs_new_destination )
			{
				randomNode = self BotFindNodeRandom();
				if ( IsDefined( randomNode ) )
				{
					self BotSetScriptGoal( randomNode.origin, 128, "hunt" );
				}
			}
		}
		else
		{
			hqOwningTeam = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
			if ( self.team != hqOwningTeam )
			{
				// Capture the HQ
				if ( !self is_capturing_current_headquarters() )
				{
					num_capturing = self get_num_ai_capturing_headquarters();
					possible_defense_nodes = find_current_radio().bot_nodes.size;
					if ( num_capturing < possible_defense_nodes )
					{
						// If there is still a node available for us, try to capture the HQ
						self capture_current_headquarters();
					}
					else if ( !self is_protecting_current_headquarters() )
					{
						// Otherwise hold back and protect the point while waiting for a node to be freed up
						self protect_current_headquarters();
					}
				}
			}
			else
			{
				// Protect the HQ
				if ( !self is_protecting_current_headquarters() )
				{
					wait(RandomFloat(2));	// wait a random amount of time, so not everyone gets up at the same time
					if ( IsDefined(level.radioObject) )
					{
						// Make sure level.radioObject didn't go undefined during the 2-second wait
						self protect_current_headquarters();
					}
				}
			}
		}
	}
}

find_current_radio()
{
	foreach ( radio in level.radios )
	{
		if ( radio.trig == level.radioObject.trigger )
		{
			return radio;		
		}
	}
}

is_capturing_current_headquarters()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "capture_zone" );
}

get_num_ai_capturing_headquarters()
{
	total = 0;
	players = bot_get_all_players_and_agents();
	foreach( player in players )
	{
		if ( IsAIGameParticipant(player) && player.health > 0 && player.team == self.team && player is_capturing_current_headquarters() )
		{
			total++;
		}
	}
	
	return total;
}

capture_current_headquarters()
{
	current_radio = find_current_radio();
	self bot_capture_zone(current_radio.origin, current_radio.bot_nodes, "radio" + current_radio.script_label);
}

is_protecting_current_headquarters()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "protect" );
}

protect_current_headquarters()
{
	// Radius for a "protect" will be the minimum of 1000 or 1/4 the average world size
	worldBounds = self BotGetWorldSize();
	average_side = (worldBounds[0] + worldBounds[1]) / 2;
	protect_radius = min(1000,average_side/4);

	self bot_protect_point( find_current_radio().origin, protect_radius );
}

init_bot_game_headquarters()
{
	if ( IsDefined( level.bots_gametype_initialized ) && level.bots_gametype_initialized )
	{
		return;
	}
	
	level.bots_gametype_initialized = true;
	
	foreach ( radio in level.radios )
	{
		radio.bot_nodes = GetNodesInTrigger(radio.trig);
	}
}