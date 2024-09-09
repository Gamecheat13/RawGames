#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
	setup_bot_sab();
}

setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_sabotage_think;
}

can_use_crate()
{
	if ( self.isBombCarrier )
	{
		return false;
	}
	
	if ( self bot_is_defending() )
	{
		return ( self.bot_defending_type == "protect" || self.bot_defending_type == "bodyguard" );
	}
	
	return true;
}

setup_bot_sab()
{
	bot_waittill_bots_enabled();
	
	while( !IsDefined(level.bombZones) )
		wait(0.05);
	
	bot_setup_bombzone_bottargets();
	
	level.bombZones["allies"].label = "allies";
	level.bombZones["axis"].label = "axis";
	
	bot_cache_entrances_to_bombzones();
	
	level.bot_gametype_precaching_done = true;
}

bot_sabotage_think()
{
	self notify( "bot_sab_think" );
	self endon(  "bot_sab_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !IsDefined(level.bot_gametype_precaching_done) )
		wait(0.05);
	
	init_bot_game_sabotage();
	
	self BotSetFlag("separation",0);	// don't slow down when we get close to other bots
	self BotSetFlag("grenade_objectives",1);
	self.next_time_hunt_carrier = GetTime();
	
	if ( !IsDefined( level.next_game_update_time ) )
	{
		level.next_game_update_time = GetTime() + 100;
	}
	
	for( ;; )
	{
		wait(0.05);
		
		if ( GetTime() >= level.next_game_update_time )
		{
			update_game_sabotage();	// update logic that isn't specific to one bot - only once a frame
			level.next_game_update_time = GetTime() + 100;
		}
		
		if ( self.health <= 0 )
		{
			// Wait to be fully spawned before acting
			continue;
		}
		
		if ( !IsDefined(level.team_planted_bomb) )
		{
			// If the bomb hasn't been planted (we haven't defined a team that planted the bomb)
			if ( !IsDefined(level.bomb_carrier) )
			{
				// If there is no bomb carrier, then try to get the bomb
				self BotSetScriptGoal( level.sabBomb.curorigin, 16, "critical" );
			}
			else
			{
				if ( self.isBombCarrier )
				{
					// path to the bombZone
					bombZone = level.bombZones[get_enemy_team(self.team)];
					self BotSetScriptGoal( bombZone.botTarget.origin, 0, "critical", bombZone.botTarget.angles[1] );
					pathResult = self bot_waittill_goal_or_fail();
					if ( pathResult == "goal" )
					{
						// TODO: replace with _bots_util::bot_usebutton_wait
						
						// Press the "Use" button once we're in position
						self BotPressUseButton(level.plantTime + 2);
						level waittill_any_timeout( level.plantTime + 2, "bomb_planted" );
					}
				}
				else if ( level.bomb_carrier.team == self.team )
				{
					// If the bomb carrier is on my team, defend him
					if ( !self bot_is_defending() )
					{
						self bot_guard_player( level.bomb_carrier, 400 );
					}
				}
				else
				{
					// If the bomb carrier is my enemy, attack him
					if ( GetTime() > self.next_time_hunt_carrier || SightTracePassed( self.origin+(0,0,77), level.bomb_carrier.origin+(0,0,77), false, self ) )
					{
						self BotSetScriptGoal( level.bomb_carrier.origin, 16, "hunt" );
						self.next_time_hunt_carrier = GetTime() + RandomIntRange(4500,5500);
					}
				}
			}
		}
		else
		{
			bombZone = level.bombZones[get_enemy_team(level.team_planted_bomb)];
			
			if ( self.team == level.team_planted_bomb )
			{
				// Someone on my team planted the bomb, so defend it
				if ( !self is_defending_bombZone() )
				{
					self bot_protect_point( bombZone.botTarget.origin, 600 );
				}
			}
			else
			{
				// Defuse the bomb
				if ( IsDefined(level.bomb_defuser) && level.bomb_defuser == self )
				{
					// path to the bomb location
					self BotSetScriptGoal( bombZone.botTarget.origin, 16, "critical", bombZone.botTarget.angles[1] );
					result = self bot_waittill_goal_or_fail( undefined, "no_longer_bomb_defuser" );
					if ( result == "goal" )
					{
						// Press the "Use" button once we're in position
						self BotPressUseButton(level.defuseTime + 2);
						self waittill_usebutton_released_or_time_or_bomb_planted(level.defuseTime + 2);
					}
				}
				else if ( !self bot_is_defending() )
				{
					// defend the bomb location
					self bot_capture_point( bombZone.botTarget.origin, 200, "zone" + bombZone.label );
				}
			}
		}
	}
}

// TODO: replace with _bots_util::bot_usebutton_wait
waittill_usebutton_released_or_time_or_bomb_planted(time)
{
	time_started = GetTime();
	time_to_end = time_started + time*1000;
	
	wait(0.05);	// give a frame for button to be pressed
	while( self UseButtonPressed() && GetTime() < time_to_end && level.bombPlanted )
	{
		wait(0.05);
	}
}

is_defending_bombZone()
{
	return ( (self bot_is_defending()) && self.bot_defending_type == "protect" );
}

init_bot_game_sabotage()
{
	if ( IsDefined( level.bots_gametype_initialized ) && level.bots_gametype_initialized )
	{
		return;
	}
	
	level.bots_gametype_initialized = true;
}

update_game_sabotage()
{	
	// If the bomb still needs to be planted...
	if ( !level.bombPlanted )
	{
		if ( IsDefined(level.team_planted_bomb) )
		{
			// a bomb was just defused
			level.team_planted_bomb = undefined;
			level.bomb_carrier = undefined;
		}
		
		prev_carrier = level.bomb_carrier;
		level.bomb_carrier = undefined;
		
		// Check who has the bomb
		players = bot_get_all_players_and_agents();
		foreach( player in players )
		{
			if ( IsAlive(player) && IsGameParticipant(player) && player.isBombCarrier )
			{
				level.bomb_carrier = player;
			}
		}
		
		bomb_changed_ownership = false;
		if ( !IsDefined(prev_carrier) && IsDefined(level.bomb_carrier) )
		{
			assert( IsTeamParticipant(level.bomb_carrier) );	// only team members should be picking up bombs (not squadmembers)
			
			// bomb was picked up off the ground
			bomb_changed_ownership = true;
			if ( IsAI( level.bomb_carrier ) )
			{
				level.bomb_carrier thread bomber_think();
			}
		}
		else if ( IsDefined(prev_carrier) && !IsDefined(level.bomb_carrier) )
		{
			// bomb was dropped to the ground
			bomb_changed_ownership = true;
		}
		
		// If the bomb carrier has changed, clear out all bot defenses
		if ( bomb_changed_ownership )
		{
			players = bot_get_all_players_and_agents();
			foreach( player in players )
			{
				if ( IsAITeamParticipant( player ) )
				{
					player bot_defend_stop();
				}
			}
		}
	}
	else
	{
		if ( IsDefined(level.bombOwner) && !IsDefined(level.team_planted_bomb) )
		{
			level.team_planted_bomb = level.bombOwner.team;
			level.last_time_calc_defuser = GetTime();
		}
		
		// bomb has been planted
		if ( !IsDefined(level.bomb_defuser) || !IsAlive(level.bomb_defuser) || GetTime() > level.last_time_calc_defuser + 1000 )
		{
			// Choose closest guy to be the bomb defuser
			defusers = [];
			players = bot_get_all_players_and_agents();
			foreach( player in players )
			{
				if ( IsAlive( player ) && IsAITeamParticipant(player) && player.team != level.team_planted_bomb )
				{
					defusers[defusers.size] = player;
				}
			}
			
			if ( defusers.size > 0 )
			{
				bombZone = level.bombZones[get_enemy_team(level.team_planted_bomb)];
				defusers_sorted = get_array_of_closest(bombZone.bottarget.origin,defusers);
				
				if ( !IsDefined(level.bomb_defuser) || level.bomb_defuser != defusers_sorted[0] )
				{
					prev_defuser = level.bomb_defuser;
					
					level.bomb_defuser = defusers_sorted[0];
					level.bomb_defuser bot_defend_stop();
					
					if ( IsDefined(prev_defuser) )
					{
						prev_defuser notify("no_longer_bomb_defuser");
					}
				}
			}
		}
	}
}

bomber_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !level.bombPlanted && self.isBombCarrier )
	{
		// check if too far ahead
		followers = [];
		players = bot_get_all_players_and_agents();
		foreach( player in players )
		{
			if ( IsAlive(player) && IsAITeamParticipant(player) && player.team == self.team && (player bot_is_defending()) )
			{
				followers[followers.size] = player;
			}
		}
		
		num_behind = 0;
		foreach( follower in followers )
		{
			dist_self_to_followerSQ = DistanceSquared(self.origin,follower.origin);
			allowable_dist_away_SQ = follower.bot_defending_radius * follower.bot_defending_radius;
			double_allowable_dist_away_SQ = (follower.bot_defending_radius * 2) * (follower.bot_defending_radius * 2);
			if ( dist_self_to_followerSQ > allowable_dist_away_SQ && dist_self_to_followerSQ < double_allowable_dist_away_SQ )
			{
				num_behind++;
			}
		}
		
		self SetMoveSpeedScale(1.00 - 0.15*num_behind);
		wait(1);
	}
}