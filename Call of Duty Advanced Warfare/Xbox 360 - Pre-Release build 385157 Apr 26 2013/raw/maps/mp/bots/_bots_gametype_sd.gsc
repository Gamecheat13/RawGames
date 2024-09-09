#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
	setup_bot_sd();
}

setup_callbacks()
{
	level.bot_funcs["gametype_think"] = ::bot_sd_think;
	level.bot_funcs["should_start_cautious_approach"]	= ::should_start_cautious_approach_sd;
	level.bot_funcs["know_enemies_on_start"]			= undefined;
}

setup_bot_sd()
{
	level.bots_disable_team_switching = true;
	
	bot_waittill_bots_enabled();
	
	bot_setup_bombzone_bottargets();
	bot_cache_entrances_to_bombzones();
	
	foreach( bombZone in level.bombZones )
	{
		zone = GetZoneNearest( bombZone.curorigin );
		if ( IsDefined( zone ) )
			BotZoneSetTeam( zone, game["defenders"] );
	}
	
	level.bot_gametype_precaching_done = true;
}

bot_sd_think()
{
	self notify( "bot_sd_think" );
	self endon(  "bot_sd_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !IsDefined(level.bot_gametype_precaching_done) )
		wait(0.05);
	
	init_bot_game_sd();

	self BotSetFlag("separation",0);	// don't slow down when we get close to other bots
	self BotSetFlag("grenade_objectives",1);
	attacker_team = game["attackers"];
	
	if ( !IsDefined(level.can_pickup_bomb_time) )
	{
		time = 5000;
		level.can_pickup_bomb_time = GetTime() + time;
		BadPlace_Cylinder("bomb", time / 1000, level.sdBomb.curorigin, 45, 300, attacker_team);
	}

	while(1)
	{
		wait( RandomIntRange(1,3) * 0.05 );
		
		if ( self.health <= 0 )
			continue;
		
		if ( GetTime() >= level.next_game_update_time )
		{
			update_game_sd();	// update logic that isn't specific to one bot - only once a frame
			level.next_game_update_time = GetTime() + 100;
		}
		
		if ( !IsDefined(self.role) )
		{
			self set_sd_role();
		}
		
		if ( self.team == attacker_team )
		{
			// Attackers
			if ( level.bombPlanted )
			{
				// If the bomb has been planted, defend it
				if ( !self bot_is_defending_point(level.sdBombModel.origin) )
				{
					self bot_protect_point( level.sdBombModel.origin, get_bomb_protect_radius() );
				}
			}
			else if ( bomber_is_about_to_plant() )
			{
				// Defend the area where the bomb will be planted
				if ( !self bot_is_defending_point(level.atk_bomber.bombZoneGoal.botTarget.origin) )
				{
					if ( self.role == "atk_bomber" )
						self bot_enable_tactical_goals();
					
					self bot_protect_point( level.atk_bomber.bombZoneGoal.botTarget.origin, get_bomb_protect_radius() );
				}
			}
			else if ( GetTime() < level.can_pickup_bomb_time )
			{
				// Protect the bomb until it's time to pick it up
				if ( !self bot_is_defending() )
				{
					self bot_protect_point( level.sdBomb.curOrigin, 900 );
				}
			}
			else if ( self.role == "atk_bomber" )
			{
				// Else, if we're the bomb carrier and the bomb hasn't been planted
				if ( !self.isBombCarrier )
				{
					if ( self bot_is_defending() )
						self bot_defend_stop();
					
					// If we don't yet have the bomb, go to its location
					if ( !self BotHasScriptGoal() )
					{
						self BotSetScriptGoal(level.sdBomb.curOrigin, 0, "critical");
					}
				}
				else
				{
					self BotClearScriptGoal();
					
					// Once we have the bomb, bring it to the objective
					if ( !IsDefined(level.attackers_chose_random_bombzone) )
					{
						// If this is the first time, choose a random zone
						bombZoneGoal = level.bombZones[ RandomInt( level.bombZones.size ) ];
						level.attackers_chose_random_bombzone = true;
					}
					else
					{
						// Else pick the closest zone
						bombZoneGoal = self find_closest_bombzone();
					}
					self.bombZoneGoal = bombZoneGoal;
					
					self cautious_approach_till_close( bombZoneGoal.botTarget.origin, "zone" + bombZoneGoal.label );
					pathResult = self bot_waittill_goal_or_fail();
					if ( pathResult == "goal" )
					{
						time_left = maps\mp\gametypes\_gamelogic::getTimeRemaining();
						time_till_last_chance_to_plant = time_left - (level.plantTime + 3) * 1000;
						if ( time_till_last_chance_to_plant > 0 )
						{
							self bot_waittill_out_of_combat_or_time( time_till_last_chance_to_plant - level.bot_out_of_combat_time );
						}
						
						self sd_press_use( level.plantTime + 2, "bomb_planted" );
						self BotClearScriptGoal();
					}
				}
			}
			else if ( self.role == "atk_follower" && IsDefined( level.atk_bomber ) )
			{
				// Else, if we're a follower and the bomb hasn't been planted, follow/protect the bomb carrier
				if ( !self bot_is_defending() || self.bot_defending_type == "protect" )
				{
					self bot_guard_player( level.atk_bomber, 600 );
				}
			}
		}
		else
		{
			// Defenders
			if ( level.bombPlanted && !level.bombExploded )	// If the bomb has been planted,
			{
				if ( IsDefined(level.bomb_defuser) )	// And someone has been chosen to defuse it
				{
					if ( self.role == "bomb_defuser" )
					{
						// path to the bomb location
						zone = find_ticking_bomb();
						
						// Temp asserts to help track down some SREs
						AssertEx( IsDefined(zone), "Couldn't find ticking bombzone" );
						AssertEx( IsDefined(level.sdBombModel), "Undefined level.sdBombModel" );
						Assert( IsDefined(level.sdBombModel.origin[0]) );
						Assert( IsDefined(level.sdBombModel.origin[1]) );
						Assert( IsDefined(zone.botTarget.origin[2]) );
								 
						defuse_target_origin = (level.sdBombModel.origin[0], level.sdBombModel.origin[1], zone.botTarget.origin[2] );
						
						self cautious_approach_till_close( defuse_target_origin, undefined );
						pathResult = self bot_waittill_goal_or_fail();
						if ( pathResult == "goal" )
						{
							time_left = maps\mp\gametypes\_gamelogic::getTimeRemaining();
							time_till_last_chance_to_defuse = time_left - (level.defuseTime + 3) * 1000;
							if ( time_till_last_chance_to_defuse > 0 )
							{
								self bot_waittill_out_of_combat_or_time( time_till_last_chance_to_defuse - level.bot_out_of_combat_time );
							}
							
							self sd_press_use( level.defuseTime + 2 );
							self BotClearScriptGoal();
							self bot_enable_tactical_goals();
						}
					}
					else if ( !self bot_is_defending() )
					{
						// defend the bomb location
						self bot_protect_point( level.sdBombModel.origin, get_bomb_protect_radius() );
					}
				}
			}
			else
			{
				// If the bomb hasn't been planted, defend our specific zone
				if ( !self bot_is_defending() )
				{
					self bot_protect_point( self.defend_zone.botTarget.origin, get_bomb_protect_radius() );
				}
			}
		}
	}
}

cautious_approach_till_close( target, label )
{
	// Send the bot to the bombzone using Capture, so he'll cautiously approach it
	capture_radius = get_bomb_capture_radius();
	self bot_capture_point( target, capture_radius, label );
	
	// Wait till bot reaches the bombzone area
	wait(0.05);	// Wait one frame, so if we are already within the capture radius, we give time for defense to start before we end it
	while( DistanceSquared( self.origin, target ) > capture_radius * capture_radius )
	{
		wait(0.05);
	}
	
	self bot_defend_stop();
	self BotSetScriptGoal( target, 20, "critical" );	
}

sd_press_use( time, level_end_notify )
{
	// Press the "Use" button once we're in position
	chance_to_prone = 0;
	if ( self bot_get_persistent_value("strategyLevel") == 1 )
		chance_to_prone = 40;
	else if ( self bot_get_persistent_value("strategyLevel") == 2 )
		chance_to_prone = 80;
	
	if ( RandomInt(100) < chance_to_prone )
	{
		self BotSetStance("prone");
		wait(0.2);
	}
	
	self BotPressUseButton(time);
	self bot_usebutton_wait( time * 1000, level_end_notify );
	self BotSetStance("none");
}

find_ticking_bomb()
{
	if ( IsDefined( level.tickingObject ) )
	{
		foreach(zone in level.bombZones)
		{
			if ( DistanceSquared( level.tickingObject.origin, zone.curorigin ) < 300 * 300 )
				return zone;
		}
	}

	return undefined;
}

bomber_is_about_to_plant()
{
	if ( IsDefined(level.atk_bomber) && IsDefined(level.atk_bomber.bombZoneGoal) )
	{
		if ( DistanceSquared(level.atk_bomber.origin, level.atk_bomber.bombZoneGoal.curorigin) < 300 * 300 )
			return true;
	}
	
	return false;
}

should_start_cautious_approach_sd( firstCheck )
{
	distance_start_cautiousness = 2000;
	distance_start_cautiousness_sq = distance_start_cautiousness * distance_start_cautiousness;
	
	// If firstCheck is true, this is called to determine if the bot should even attempt to do a cautious approach
	// If firstCheck is false, this is called to determine if the bot should start his cautious approach, or keep waiting
	
	if ( firstCheck )
	{
		return true;
	}
	else
	{
		// Wait until we are within the radius and are pathing toward our goal (vs chasing down enemies)
		return ( DistanceSquared(self.origin, self.bot_defending_center) <= distance_start_cautiousness_sq && self BotPursuingScriptGoal() );
	}
}

get_bomb_protect_radius()
{
	if ( !IsDefined(level.protect_radius) )
	{
		level.protect_radius = 650;
	}
		
	return level.protect_radius;
}

get_bomb_capture_radius()
{
	if ( !IsDefined(level.capture_radius) )
	{
		level.capture_radius = 140;
	}
		
	return level.capture_radius;
}

find_closest_bombzone()
{
	closest_zone = undefined;
	closest_zone_distSQ = 999999999;
	foreach( zone in level.bombZones )
	{
		distSQ = DistanceSquared(zone.botTarget.origin,self.origin);
		if ( distSQ < closest_zone_distSQ )
		{
			closest_zone = zone;
			closest_zone_distSQ = distSQ;
		}
	}
	
	return closest_zone;
}

bomber_wait_for_death()
{
	self waittill_any( "death", "disconnect", "game_ended" );

	level.atk_bomber = undefined;
	
	players = bot_get_all_players_and_agents();
	foreach( player in players )
	{
		if ( player IsAITeamParticipant() && player.pers["team"] == game["attackers"] )
		{
			player.role = undefined;
			player bot_defend_stop();
		}
	}
}

bomber_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while( !level.bombPlanted )
	{
		if ( self.isBombCarrier )
		{
			// check if too far ahead
			followers = [];
			players = bot_get_all_players_and_agents();
			foreach( player in players )
			{
				if ( IsAlive(player) && IsDefined(player.role) && player.role == "atk_follower" && (player bot_is_defending()) )
				{
					followers[followers.size] = player;
				}
			}
			
			num_behind = 0;
			foreach( follower in followers )
			{
				dist_self_to_followerSQ = DistanceSquared(self.origin,follower.origin);
				allowable_dist_away = follower.bot_defending_radius;
				if ( dist_self_to_followerSQ > allowable_dist_away * allowable_dist_away )
				{
					num_behind++;
				}
			}
			
			// If 4 or more followers are outside of radius, then pause
			// If 1-3 followers are outside, slow down
			if ( num_behind >= 4 )
			{
				self SetMoveSpeedScale(0.0);
			}
			else if ( num_behind >= 1 && num_behind <= 3 )
			{
				self SetMoveSpeedScale(1 - 0.25*num_behind);
				wait(1);
			}
			else
			{
				self SetMoveSpeedScale(0.90);
			}
		}
		
		wait(1);
	}
}

set_new_bomber()
{
	assert( IsTeamParticipant(self) );	// Bomb carrier needs to be a team participant, not a squad member
	
	level.atk_bomber = self;
	self.role = "atk_bomber";
	self thread bomber_wait_for_death();
	
	if ( IsAI( self ) )
	{
		self bot_defend_stop();
		self thread bomber_think();
		self BotClearScriptGoal();
		self bot_disable_tactical_goals();
	}
	
	// Stop all other followers from defending so they can defend the new leader
	players = bot_get_all_players_and_agents();
	foreach( player in players )
	{
		if ( IsDefined( player.role ) && player.role == "atk_follower" )
		{
			player bot_defend_stop();
		}
	}
}

set_sd_role()
{
	if( self.pers["team"] == game["attackers"] )
	{
		// On the attacking team, one Bot goes after the bomb and the rest follow him
		if ( !IsDefined(level.atk_bomber) )
		{
			self set_new_bomber();
		}
		else
		{
			self.role = "atk_follower";
		}
	}
	else
	{
		// On the defending team, divide up and defend each bombZone
		if ( !IsDefined(level.next_defend_zone_goal) || level.next_defend_zone_goal == level.bombZones.size )
		{
			level.next_defend_zone_goal = 0;
		}
		
		self.role = "defend";
		self.defend_zone = level.bombZones[level.next_defend_zone_goal];
		level.next_defend_zone_goal++;
	}
}


init_bot_game_sd()
{
	if ( IsDefined( level.bots_gametype_initialized ) && level.bots_gametype_initialized )
	{
		return;
	}
	
	level.next_game_update_time = GetTime() + 1;
	
	level.bots_gametype_initialized = true;
}

update_game_sd()
{	
	// If the bomb still needs to be planted...
	if ( !level.bombPlanted )
	{		
		// if someone else picked up the bomb, make them the leader
		players = bot_get_all_players_and_agents();
		foreach( player in players )
		{
			if ( IsAlive(player) && IsGameParticipant(player) && player.isBombCarrier && ( !IsDefined(level.atk_bomber) || player != level.atk_bomber ) )
			{
				// make old bomb carrier into a follower, if he exists
				if ( IsDefined(level.atk_bomber) && IsAlive(level.atk_bomber) )
				{
					level.atk_bomber.role = "atk_follower";
				}
				
				player set_new_bomber();
			}
		}
		
		bombzone_protect_radius = get_bomb_protect_radius();
	
		// If we need to even out the number of defenders at each zone
		for ( i=0; i<level.bombZones.size; i++ )
		{
			// for each zone, count the number of players defending that zone
			count = 0;
			players = bot_get_all_players_and_agents();
			foreach( player in players )
			{
				if ( IsAlive(player) && IsTeamParticipant(player) )
				{
					if ( IsAI( player ) )
					{
						if ( IsDefined(player.defend_zone) && player.defend_zone == level.bombZones[i] )
						{
							count++;
						}
					}
					else
					{
						if ( DistanceSquared(player.origin,level.bombZones[i].curorigin) < bombzone_protect_radius * bombzone_protect_radius )
						{
							count++;
						}
					}
				}
			}
			
			level.bombZones[i].total_defending = count;
		}
		
		for ( i=0; i<level.bombZones.size; i++ )
		{
			for ( j=0; j<level.bombZones.size; j++ )
			{
				if ( level.bombZones[i].total_defending > level.bombZones[j].total_defending + 1 )
				{
					// move a guy from zone i to zone j
					players = bot_get_all_players_and_agents();
					foreach( player in players )
					{
						if ( IsAlive(player) && IsDefined(player.defend_zone) && player.defend_zone == level.bombZones[i] )
						{
							player bot_defend_stop();
							player.defend_zone = level.bombZones[j];
							return;
						}
					}
				}
			}
		}
	}
	else
	{
		// bomb has been planted
		if ( !IsDefined(level.bomb_defuser) || !IsAlive(level.bomb_defuser) )
		{
			// If we don't have a bomb defuser, choose closest guy to do it
			defenders = [];
			players = bot_get_all_players_and_agents();
			foreach( player in players )
			{
				if ( IsAlive(player) && IsAITeamParticipant(player) && IsDefined(player.role) && player.role == "defend" )
				{
					defenders[defenders.size] = player;
					player bot_defend_stop();
				}
			}
			
			if ( defenders.size > 0 )
			{
				defenders_sorted = get_array_of_closest(level.sdBombModel.origin,defenders);
				defenders_sorted[0].role = "bomb_defuser";
				defenders_sorted[0] bot_disable_tactical_goals();
				level.bomb_defuser = defenders_sorted[0];
			}
		}
	}
}
