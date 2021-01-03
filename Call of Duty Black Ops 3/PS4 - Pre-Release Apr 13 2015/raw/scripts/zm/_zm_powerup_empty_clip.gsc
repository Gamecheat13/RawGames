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

#namespace zm_powerup_empty_clip;

function autoexec __init__sytem__() {     system::register("zm_powerup_empty_clip",&__init__,undefined,undefined);    }

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "empty_clip", &grab_empty_clip );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "empty_clip", "zombie_ammocan", &"ZOMBIE_POWERUP_MAX_AMMO", &zm_powerups::func_should_never_drop, !true, !true, true );
	}
}

function grab_empty_clip( player )
{	
	level thread empty_clip_powerup( self );
			
//			players = GetPlayers();
//			players[randomintrange(0,players.size)] thread powerup_vo( "empty_clip" ); // TODO: Audio should uncomment this once the sounds have been set up
}

//******************************************************************************
// empty clip powerup
//******************************************************************************
function empty_clip_powerup( item )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !player laststand::player_is_in_laststand() && !(player.sessionstate == "spectator") )
		{
			weapon = player GetCurrentWeapon();
			player SetWeaponAmmoClip( weapon, 0 );
		}
	}
}
