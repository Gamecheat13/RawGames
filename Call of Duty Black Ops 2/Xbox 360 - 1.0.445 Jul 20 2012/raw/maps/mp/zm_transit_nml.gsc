#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

nml_start()
{
	maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_NML_INDEX );

	zombies = GetAIArray( "axis");
	level.prev_round_zombies = zombies.size + level.zombie_total;

	maps\mp\zombies\_zm_race_utility::race_kill_all_zombies();

	if ( !level.objectiveBased )
	{
		if ( level.teamBased )
		{
			IPrintLnBold( "SURVIVE LONGER THAN YOUR YOUR OPPONENTS" );
		}
		else
		{
			IPrintLnBold( "SURVIVE THE LONGEST" );
		}
	}

	flag_set( "enter_nml" );

	set_zombie_var( "zombie_intermission_time", 2 );
	set_zombie_var( "zombie_between_round_time", 2 );

	maps\mp\zombies\_zm_game_module_nml::init_no_mans_land();
	level thread maps\mp\zombies\_zm_game_module_nml::nml_ramp_up_zombies();
	level thread maps\mp\zombies\_zm_game_module_nml::nml_setup_round_spawner();

	level.survival_last_round = level.round_number;

	flag_clear( "zombie_drop_powerups" );
}

nml_end()
{
	if ( level.objectiveBased )
	{
		flag_wait( "end_nml" );
		flag_clear( "end_nml" );

		level notify( "stop_ramp" );
		flag_clear( "start_supersprint" );

		level.ignore_distance_tracking = true;

		level.round_number = level.survival_last_round - 1;
		level thread previousZombieTotal();
		
		maps\mp\zombies\_zm_game_module_nml::resume_survival_rounds( level.round_number );
		flag_clear( "enter_nml" );

		level.round_spawn_func = maps\mp\zombies\_zm::round_spawning;

		set_zombie_var( "zombie_intermission_time", 15 );
		set_zombie_var( "zombie_between_round_time", 10 );

		flag_set( "zombie_drop_powerups" );
		level.ignore_distance_tracking = false;
	}
	else
	{
		// TODO: Call this on player connect incase someone joins match later
		players = get_players();
		foreach( player in players )
		{
			player thread onPlayerKilled();
		}

		last_alive_player = undefined;
		winning_team = undefined;

		while( true )
		{
			level waittill( "playerKilled" );

			alive = 0;
			all_finished = true;

			players = get_players();
			foreach ( player in players )
			{
				if ( !IsDefined( player ) )
				{
					continue;
				}

				if ( player.sessionstate != "playing" )
				{
					continue;
				}

				alive++;
				last_alive_player = player;
			}

			if ( alive == 1 )
			{
				break;
			}
		}

		flag_set( "end_nml" );

		if ( level.teamBased )
		{
			if ( winning_team == 1 )
			{
				IPrintLnBold( "TEAM 1 WINS!" );
			}
			else
			{
				IPrintLnBold( "TEAM 2 WINS!" );
			}
		}
		else
		{
			IPrintLnBold( last_alive_player.name + "WINS!" );
		}
	}

	level thread maps\mp\zombies\_zm_game_module_nml::onCleanUp();
}

previousZombieTotal()
{
	level waittill( "zombie_total_set" );
	
	zombies = GetAISpeciesArray( "axis", "all" );
		
	if ( level.prev_round_zombies != 0 )
	{
		level.zombie_total = level.prev_round_zombies;
	}
	
	if ( level.zombie_total >= zombies.size )
	{
		level.zombie_total -= zombies.size;
	}
	else
	{
		level.zombie_total = 0; 
	}
}

onPlayerKilled()
{
	level endon( "end_nml" );
	self endon( "disconnect" );

	while( true )
	{
		self waittill( "death" );

		level notify( "playerKilled" );
	}
}