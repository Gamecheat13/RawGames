#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                
                                                                                                                               

#precache( "string", "ZOMBIE_POWERUP_BONUS_POINTS" );

#namespace zm_powerup_bonus_points_team;

function autoexec __init__sytem__() {     system::register("zm_powerup_bonus_points_team",&__init__,undefined,undefined);    }

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "bonus_points_team", &grab_bonus_points_team );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "bonus_points_team", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS", &zm_powerups::func_should_never_drop, !true, !true, !true );
	}
}

function grab_bonus_points_team( player )
{	
	level thread bonus_points_team_powerup( self );
	player thread zm_powerups::powerup_vo( "bonus_points_team" ); // TODO: Audio should uncomment this once the sounds have been set up
}

function bonus_points_team_powerup( item )
{
	points = RandomIntRange( 1, 25 ) * 100;
	
	if( IsDefined( level.bonus_points_powerup_override ) )
	{
		points = [[ level.bonus_points_powerup_override ]]();
	}

	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() && !(players[i].sessionstate == "spectator") )
		{
			players[i] zm_score::player_add_points( "bonus_points_powerup", points );
		}
	}
}
