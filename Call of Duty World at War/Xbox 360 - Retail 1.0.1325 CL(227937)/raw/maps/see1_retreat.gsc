#include common_scripts\utility;
#include maps\_utility;


retreat_groups_init()
{
	level.retreat_groups = [];
}

create_retreat_group( group_name, retreat_nodes_noteworthy, group_to_merge_into, num_to_kill )
{
	new_group = spawnstruct();
	new_group.retreat_nodes_noteworthy = retreat_nodes_noteworthy;
	new_group.spawner_noteworthies = [];
	new_group.merge_to = group_to_merge_into;
	new_group.num_killed = 0;
	
	level.retreat_groups[group_name] = new_group;

	level thread retreat_group_notify_detection( group_name );

	if( isdefined( num_to_kill ) )
	{
		level thread retreat_group_kills_detection( group_name, num_to_kill );
	}
}

add_to_retreat_group( group_name, spawner_noteworthy )
{
	current_size = level.retreat_groups[group_name].spawner_noteworthies.size;
	level.retreat_groups[group_name].spawner_noteworthies[current_size] = spawner_noteworthy;
}

spawn_func_assign_retreat_group()
{
	keys = getarraykeys( level.retreat_groups );
	for( i = 0; i < keys.size; i++ )
	{
		noteworthies = level.retreat_groups[keys[i]].spawner_noteworthies;

		for( j = 0; j < noteworthies.size; j++ )
		{
			if( noteworthies[j] == self.script_noteworthy )
			{
				self.retreat_group = keys[i];
				level thread retreat_group_track_death( self );
				return;
			}
		}
	}
}

run_retreat_trigger( trigger_name, retreat_group_name )
{
	end_msg = retreat_group_name + "_retreated";
	level endon( end_msg );

	trigger = getent( trigger_name, "targetname" );
	if( isdefined( trigger ) )
	{
		trigger waittill( "trigger" );
		retreat_group( retreat_group_name );
	}
}

retreat_group_notify_detection( group_name )
{
	end_msg = group_name + "_retreated";
	level endon( end_msg );

	notify_msg = group_name + "_retreat";
	level waittill( notify_msg );

	retreat_group( group_name );
}

retreat_group_kills_detection( group_name, num_to_kill )
{
	end_msg = group_name + "_retreated";
	level endon( end_msg );

	while( level.retreat_groups[group_name].num_killed < num_to_kill )
	{
		wait( 0.05 );
	}
	retreat_group( group_name );
}

retreat_group_track_death( guy )
{
	guy waittill( "death" );
	if( isdefined( guy.retreat_group ) )
	{
		if( isdefined( level.retreat_groups[guy.retreat_group] ) )
		{
			if( isdefined( level.retreat_groups[guy.retreat_group].num_killed ) )
			{
				level.retreat_groups[guy.retreat_group].num_killed++;
			}
		}
	}
}

retreat_group( group_name )
{
	if( isdefined( level.retreat_groups[group_name] ) )
	{
		if( isdefined( level.retreat_groups[group_name].retreat_nodes_noteworthy ) )
		{
			enemies = getaiarray( "axis" );
			destination_nodes = getnodearray( level.retreat_groups[group_name].retreat_nodes_noteworthy, "script_noteworthy" );
	
			for( i = 0; i < enemies.size; i++ )
			{
				if( isdefined( enemies[i].retreat_group ) && enemies[i].retreat_group == group_name )
				{
					node_index = i;
					if( destination_nodes.size < enemies.size )
					{
						node_index = i % destination_nodes.size;
					}
					node = destination_nodes[node_index];
					enemies[i].retreat_group = level.retreat_groups[group_name].merge_to;
					enemies[i] thread set_goal_node_forced( node );
				}
			}
		}
	}

	complete_msg = group_name + "_retreated";
	level notify( complete_msg );
}


set_goal_node_forced( node )
{
	old_goalradius = self.goalradius;
	old_ignoreall = self.ignoreall;
	old_pacifist = self.pacifist;

	self.goalradius = 64;
	self.ignoreall = 1;
	self.pacifist = 1;

	self setgoalnode( node );
	self waittill( "goal" );

	self.goalradius = old_goalradius;
	self.ignoreall = old_ignoreall;
	self.pacifist = old_pacifist;
}