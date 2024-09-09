#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;
#include maps\mp\bots\_bots_personality;


//=======================================================
//						main
//=======================================================
main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
/#
	thread bot_conf_debug();
#/
	
	level.bot_tag_obj_radius = 200;
}


//=======================================================
//					setup_callbacks
//=======================================================
setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_conf_think;
}


//=======================================================
//					can_use_crate
//=======================================================
can_use_crate()
{
	return true;
}

/#
bot_conf_debug()
{
	while(1)
	{
		if ( GetDvar("bot_DrawDebugGametype") == "conf" )
		{
			foreach( tag in level.dogtags )
			{
				if ( tag maps\mp\gametypes\_gameobjects::canInteractWith("allies") || tag maps\mp\gametypes\_gameobjects::canInteractWith("axis") )
				{
					bot_draw_circle( tag.curorigin, level.bot_tag_obj_radius, (1,0,0), false, 16 );
				}
			}
		}
		
		wait(0.05);
	}
}
#/

//=======================================================
//					bot_conf_think
//=======================================================
bot_conf_think()
{
	self notify( "bot_conf_think" );
	self endon(  "bot_conf_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	self.next_time_check_tags = GetTime() + 500;
	self.tags_seen = [];
	self.last_killtag_tactical_goal_pos = (0,0,0);
	
	if ( self.personality == "camper" )
	{
		self.conf_camper_camp_tags = (RandomInt(100) < 70);
	}
	
	while ( true )
	{
		needs_to_sprint = false;
		if ( IsDefined(self.tag_getting) && self BotHasScriptGoal() )
		{
			script_goal = self BotGetScriptGoal();
			if ( DistanceSquared( self.tag_getting.curorigin, script_goal ) < 1 )
			{
				// Script goal is this tag
				if ( self BotPursuingScriptGoal() )
				{
					needs_to_sprint = true;
				}
			}
		}
		
		self BotSetFlag( "force_sprint", needs_to_sprint );
		
		self.tags_seen = self bot_remove_invalid_tags( self.tags_seen );
		best_tag = self bot_find_best_tag_from_array( self.tags_seen, true );
		
		has_curr_tag = IsDefined(self.tag_getting);
		desired_tag_exists = IsDefined(best_tag);
		if ( (has_curr_tag && !desired_tag_exists) || (!has_curr_tag && desired_tag_exists) || (has_curr_tag && desired_tag_exists && self.tag_getting != best_tag) )
		{
			// We're either setting self.tag_getting, clearing it, or changing it from one tag to a new one
			self.tag_getting = best_tag;
			self BotClearScriptGoal();
			self notify("stop_camping_tag");
			self clear_camper_data();
			self bot_abort_tactical_goal( "kill_tag" );
		}
		
		if ( IsDefined(self.tag_getting) )
		{
			camping = false;
			if ( self.personality == "camper" && self.conf_camper_camp_tags )
			{
				// Camp this tag instead of grabbing it
				camping = true;
				if ( self should_select_new_ambush_point() )
				{
					if ( find_ambush_node( self.tag_getting.curorigin ) )
					{
						self childthread bot_camp_tag();
					}
					else
					{
						camping = false;
					}
				}
			}

			if ( !camping )
			{
				if ( !self bot_has_tactical_goal( "kill_tag" ) )
				{
					tag_origin = self.tag_getting.curorigin;
					if ( DistanceSquared( self.last_killtag_tactical_goal_pos, self.tag_getting.curorigin ) < 1 )
					{
						// Trying a tactical goal to exactly the same position as last time.  This is probably because the bot couldn't calculate a path to the tag
						// So we need to adjust the position a bit
						nearest_nodes_to_tag = GetNodesInRadiusSorted( tag_origin, 256, 0, 100 );
						if ( IsDefined(nearest_nodes_to_tag) && nearest_nodes_to_tag.size > 0 )
						{
							dir_to_nearest_node = nearest_nodes_to_tag[0].origin - tag_origin;
							tag_origin = tag_origin + (VectorNormalize(dir_to_nearest_node) * Length(dir_to_nearest_node) * 0.5);
						}
					}
					
					self.last_killtag_tactical_goal_pos = self.tag_getting.curorigin;
					
					extra_params = SpawnStruct();
					extra_params.script_goal_type = "objective";
					extra_params.objective_radius = level.bot_tag_obj_radius;
					self bot_new_tactical_goal( "kill_tag", tag_origin, 25, extra_params );
				}
			}
		}
		else
		{
			self [[ self.personality_update_function ]]();
		}
		
		if ( GetTime() > self.next_time_check_tags )
		{
			self.next_time_check_tags = GetTime() + 500;
			current_bot_fov = self BotGetFovDot();
			nearest_node_to_bot = self BotGetNearestNode();
			
			new_visible_tags = self bot_find_visible_tags( nearest_node_to_bot, current_bot_fov );
			self.tags_seen = bot_combine_tag_seen_arrays( new_visible_tags, self.tags_seen );
		}
		
		/#
		if ( GetDvar("bot_DrawDebugGametype") == "conf" )
		{
			if ( IsDefined(self.tag_getting) && self.health > 0 )
			{
				color = (0.5,0,0.5);
				if ( self.team == "allies" )
					color = (1,0,1);
				if ( IsDefined(self.conf_camper_camp_tags) && self.conf_camper_camp_tags )
					color = (1,0,0);
				Line( self.origin + (0,0,40), self.tag_getting.curorigin + (0,0,10), color, 1.0, true, 1 );
			}
		}
		#/
		
		waitframe();
	}
}

bot_combine_tag_seen_arrays( new_tag_seen_array, old_tag_seen_array )
{
	new_array = old_tag_seen_array;
	foreach ( new_tag in new_tag_seen_array )
	{
		tag_already_exists_in_old_array = false;
		foreach ( old_tag in old_tag_seen_array )
		{
			if ( (new_tag.tag == old_tag.tag) && DistanceSquared( new_tag.origin, old_tag.origin ) < 1 )
			{
				tag_already_exists_in_old_array = true;
				break;
			}
		}
		
		if ( !tag_already_exists_in_old_array )
			new_array = array_add( new_array, new_tag );
	}
	
	return new_array;
}

bot_find_visible_tags( nearest_node_self, fov_self )
{
	visible_tags = [];
	
	if ( IsDefined(nearest_node_self) )
	{
		dogtag_array_randomized = array_randomize( level.dogtags );
		foreach( tag in dogtag_array_randomized )
		{
			if ( tag maps\mp\gametypes\_gameobjects::canInteractWith(self.team) )
			{
				nearest_nodes_to_tag = GetNodesInRadiusSorted( tag.curorigin, 256, 0, 100 );
				if ( IsDefined( nearest_nodes_to_tag ) && nearest_nodes_to_tag.size > 0 )
			    {
					node_visible = NodesVisible( nearest_nodes_to_tag[0], nearest_node_self, true );
					node_within_fov = within_fov( self.origin, self.angles, tag.curorigin, fov_self );
					if ( node_visible && node_within_fov )
					{
						new_tag_struct = SpawnStruct();
						new_tag_struct.origin = tag.curorigin;
						new_tag_struct.tag = tag;
						visible_tags = array_add( visible_tags, new_tag_struct );
					}
			    }
			}
		}
	}
	
	return visible_tags;
}

bot_find_best_tag_from_array( tag_array, check_allies_getting_tag )
{
	best_tag = undefined;
	if ( tag_array.size > 0 )
	{
		// find best tag
		best_tag_dist_sq = 99999 * 99999;
		foreach( tag_struct in tag_array )
		{
			num_allies_getting_tag = self get_num_allies_getting_tag( tag_struct.tag );
			if ( !check_allies_getting_tag || num_allies_getting_tag < 2 )
			{
				dist_self_to_tag_sq = DistanceSquared( tag_struct.tag.curorigin, self.origin );
				if ( dist_self_to_tag_sq < best_tag_dist_sq )
				{
					best_tag = tag_struct.tag;
					best_tag_dist_sq = dist_self_to_tag_sq;
				}
			}
		}
	}
	
	return best_tag;
}

bot_remove_invalid_tags( tags )
{
	valid_tags = [];
	foreach ( tag_struct in tags )
	{
		// Need to check if the tag can still be interacted with and if it is in the same place as where we originally saw it
		// This is because the tags are reused in the game, so this is to check if the tag has already been picked up, or if the player whose tag it is
		// died again in a different spot, moving the tag to that location
		if ( tag_struct.tag maps\mp\gametypes\_gameobjects::canInteractWith(self.team) && DistanceSquared( tag_struct.tag.curorigin, tag_struct.origin ) < 1 )
		{
			valid_tags = array_add( valid_tags, tag_struct );
		}
	}
	
	return valid_tags;
}

get_num_allies_getting_tag( tag )
{
	num = 0;
	players = bot_get_all_players_and_agents();
	foreach( player in players )
	{
		if ( player.team == self.team && player != self && IsGameParticipant(player) )
		{
			if ( IsAI( player ) )
			{
				if ( IsDefined(player.tag_getting) && player.tag_getting == tag )
					num++;
			}
			else
			{
				// If player is within 400 distance from a tag, consider him to be going for it
				if ( DistanceSquared( player.origin, tag.curorigin ) < 400 * 400 )
					num++;
			}
		}
	}
	
	return num;
}

bot_camp_tag()
{
	self endon("stop_camping_tag");
	
	self BotSetScriptGoalNode( self.node_ambushing_from, "camp", self.ambush_yaw );
	result = self bot_waittill_goal_or_fail();
	
	if ( result == "goal" )
	{
		nearest_nodes_to_tag = GetNodesInRadiusSorted( self.tag_getting.curorigin, 256, 0, 100 );
		if ( IsDefined( nearest_nodes_to_tag ) && nearest_nodes_to_tag.size > 0 )
		{
			nodes_to_watch = FindEntrances( self.origin );
			nodes_to_watch = array_add( nodes_to_watch, nearest_nodes_to_tag[0] );
			self childthread bot_watch_nodes( nodes_to_watch );
		}
	}
}