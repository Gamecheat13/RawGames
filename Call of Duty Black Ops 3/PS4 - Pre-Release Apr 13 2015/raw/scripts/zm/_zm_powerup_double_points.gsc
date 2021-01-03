#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

                                                                
                                                                                                                               

#precache( "material", "specialty_doublepoints_zombies" );
#precache( "string", "ZOMBIE_POWERUP_DOUBLE_POINTS" );

#namespace zm_powerup_double_points;

function autoexec __init__sytem__() {     system::register("zm_powerup_double_points",&__init__,undefined,undefined);    }


//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "double_points", &grab_double_points );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "double_points", "p7_zm_power_up_double_points", &"ZOMBIE_POWERUP_DOUBLE_POINTS", &zm_powerups::func_should_always_drop, !true, !true, !true, undefined, "powerup_double_points", "zombie_powerup_double_points_time", "zombie_powerup_double_points_on" );
	}
}

function grab_double_points( player )
{	
	level thread double_points_powerup( self, player );
	player thread zm_powerups::powerup_vo("double_points");
}

// double the points
function double_points_powerup( drop_item, player )
{
	level notify ("powerup points scaled_" + player.team );
	level endon ("powerup points scaled_" + player.team );

	team = player.team;
	
	level thread zm_powerups::show_on_hud( team, "double_points" );

	// Notify the persistent player ability "double points"
	if( ( isdefined( level.pers_upgrade_double_points ) && level.pers_upgrade_double_points ) )
	{
		player thread zm_pers_upgrades_functions::pers_upgrade_double_points_pickup_start();
	}

	if(isDefined(level.current_game_module) && level.current_game_module == 2 ) //race
	{
		if(isDefined(player._race_team))
		{
			if(player._race_team == 1)
			{
				level._race_team_double_points = 1;
			}
			else
			{
				level._race_team_double_points = 2;
			}
		}
	}

	level.zombie_vars[team]["zombie_point_scalar"] = 2;

	players = GetPlayers();
	for ( player_index = 0; player_index < players.size; player_index++ )
	{
		if ( team == players[player_index].team )
		{
			players[player_index] clientfield::set( "score_cf_double_points_active", 1 );
		}
	}

	wait 30;

	level.zombie_vars[team]["zombie_point_scalar"] = 1;
	
	level._race_team_double_points = undefined;

	players = GetPlayers();
	for ( player_index = 0; player_index < players.size; player_index++ )
	{
		if ( team == players[player_index].team )
		{
			players[player_index] clientfield::set( "score_cf_double_points_active", 0 );
		}
	}
}
