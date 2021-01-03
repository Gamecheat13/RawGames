#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
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

                                                                
                                                                                                                               

#precache( "string", "ZM_ZOD_POWERUP_BEAST_MANA" );

#namespace zm_powerup_beast_mana;

function autoexec __init__sytem__() {     system::register("zm_powerup_beast_mana",&__init__,undefined,undefined);    }

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "beast_mana", &grab_beast_mana );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "beast_mana",	"zombie_z_money_icon", &"ZM_ZOD_POWERUP_BEAST_MANA",	&zm_powerups::func_should_never_drop, true, !true, !true );
	}
}

function grab_beast_mana( player )
{	
	level thread beast_mana_powerup( self, player );
	player thread zm_powerups::powerup_vo( "bonus_points_solo" ); // TODO: Audio should uncomment this once the sounds have been set up
}

function beast_mana_powerup( item, player )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() && !(players[i].sessionstate == "spectator") )
		{
			if ( ( isdefined( players[i].beastmode ) && players[i].beastmode ) )
			{
				players[i].beastmana = 1.0;
			}
			else
			{
				players[i].beastlives++;
			}
		}
	}
	level thread mana_on_hud( item, player.team );
}

function mana_on_hud( drop_item, player_team )
{
	self endon ("disconnect");

	// set up the hudelem
	hudelem = hud::createServerFontString( "objective", 2, player_team );
	hudelem hud::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	if (isdefined(drop_item))
		hudelem.label = drop_item.hint;

	// set time remaining for insta kill
	hudelem thread full_ammo_move_hud( player_team );
}

function full_ammo_move_hud( player_team )
{
	players = GetPlayers( player_team );
	
	players[0] playsoundToTeam ("zmb_full_ammo", player_team);

	wait 0.5;
	move_fade_time = 1.5;

	self FadeOverTime( move_fade_time ); 
	self MoveOverTime( move_fade_time );
	self.y = 270;
	self.alpha = 0;

	wait move_fade_time;

	self destroy();
}
