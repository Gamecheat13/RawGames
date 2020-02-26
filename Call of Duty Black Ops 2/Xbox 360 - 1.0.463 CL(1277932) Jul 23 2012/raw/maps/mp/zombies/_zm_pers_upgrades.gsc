#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_utility; 

register_pers_upgrade( name, pers_upgrade_func, stat_name, stat_desired_value )
{
	if ( !isDefined( level.pers_upgrades ) )
	{
		level.pers_upgrades = [];
		level.pers_upgrades_keys = [];
	}	
	
	if ( isDefined( level.pers_upgrades[name] ) )
	{
		assert( 0,"A persistent upgrade is already registered for name : " + name );
	}
	
	level.pers_upgrades_keys[level.pers_upgrades_keys.size] = name;
	level.pers_upgrades[name] = spawnstruct();
	level.pers_upgrades[name].stat_names = [];
	level.pers_upgrades[name].stat_desired_values = [];
	level.pers_upgrades[name].upgrade_func = pers_upgrade_func;

	add_pers_upgrade_stat( name, stat_name, stat_desired_value );
}

add_pers_upgrade_stat( name, stat_name, stat_desired_value )
{
	if( !isDefined(level.pers_upgrades[name]) )
	{
		assert( 0, name + "Persistent upgrade is not registered yet." );
	}

	stats_size = level.pers_upgrades[name].stat_names.size;
	level.pers_upgrades[name].stat_names[stats_size] = stat_name;
	level.pers_upgrades[name].stat_desired_values[stats_size] = stat_desired_value;
}

pers_upgrades_monitor( )
{
	if ( !isDefined( level.pers_upgrades ) )
	{
		return;
	}

	while ( 1 )
	{
		waittillframeend;
		
		players = GetPlayers();
		for ( player_index = 0; player_index < players.size; player_index++ )
		{
			player = players[player_index];
			if ( is_player_valid( player ) &&  isDefined( player.stats_this_frame ) )
			{				
				if ( !player.stats_this_frame.size && !is_true( player.pers_upgrade_force_test ) )
				{
					continue;
				}
			
				for ( pers_upgrade_index = 0; pers_upgrade_index < level.pers_upgrades_keys.size; pers_upgrade_index++ )
				{
					pers_upgrade = level.pers_upgrades[level.pers_upgrades_keys[pers_upgrade_index]];

					if ( is_true( player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] ) )
					{
						continue;
					}
		
					should_award = player check_pers_upgrade( pers_upgrade );
					if ( should_award )
					{
						player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] = true;
						if ( IsDefined( pers_upgrade.upgrade_func) )
						{
							player [[pers_upgrade.upgrade_func]]();			
						}
					}
				}

				player.pers_upgrade_force_test = false;
				player.stats_this_frame = [];
			}
		}

		wait( 0.05 );
	}
}

check_pers_upgrade( pers_upgrade )
{
	should_award = true;
	
	is_stat_updated = self is_any_pers_upgrade_stat_updated( pers_upgrade );
	if ( !is_stat_updated )
	{
		should_award = false;	
	}
	else
	{
		for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
		{
			stat_name = pers_upgrade.stat_names[i];
			should_award = self check_pers_upgrade_stat( stat_name, pers_upgrade.stat_desired_values[i] );
			if ( !should_award )
			{
				break;
			}
		}
	}
	
	return should_award;
}

is_any_pers_upgrade_stat_updated( pers_upgrade )
{
	if ( is_true( self.pers_upgrade_force_test ) )
	{
		return true;
	}

	result = false;
	for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
	{
		stat_name = pers_upgrade.stat_names[i];		
		if ( isDefined( self.stats_this_frame[stat_name] ) )
		{
			result = true;
			break;
		}
	}
	
	return result;
}

check_pers_upgrade_stat( stat_name, stat_desired_value )
{
	should_award = true;
	current_stat_value = self maps\mp\zombies\_zm_stats::get_game_mode_group_stat( "zclassic", stat_name );
	if ( current_stat_value < stat_desired_value )
	{
		should_award = false;
	}
			
	return should_award;
}


pers_upgrade_do_nothing()
{
}
