#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

                                                                
                                                                                                                               

#precache( "string", "ZOMBIE_POWERUP_MAX_AMMO" );

#namespace zm_powerup_full_ammo;

function autoexec __init__sytem__() {     system::register("zm_powerup_full_ammo",&__init__,undefined,undefined);    }


//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "full_ammo", &grab_full_ammo );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "full_ammo", "p7_zm_power_up_max_ammo", &"ZOMBIE_POWERUP_MAX_AMMO", &zm_powerups::func_should_always_drop, !true, !true, !true );
	}
}

function grab_full_ammo( player )
{	
	level thread full_ammo_powerup( self ,player );
	player thread zm_powerups::powerup_vo("full_ammo");
}

function full_ammo_powerup( drop_item , player)
{
	players = GetPlayers( player.team );
	
	if(isDefined(level._get_game_module_players))
	{
		players = [[level._get_game_module_players]](player);
	}
	
	for (i = 0; i < players.size; i++)
	{
		// skip players in last stand
		if ( players[i] laststand::player_is_in_laststand() )
		{
			continue;
		}

		primary_weapons = players[i] GetWeaponsList( true ); 

		players[i] notify( "zmb_max_ammo" );
		players[i] notify( "zmb_lost_knife" );
		players[i] zm_placeable_mine::disable_all_prompts_for_player();
		for( x = 0; x < primary_weapons.size; x++ )
		{
			//don't give grenades if headshot only option is enabled
			if( level.headshots_only && zm_utility::is_lethal_grenade( primary_weapons[x] ) )
			{
				continue;
			}
			
			// Don't refill Equipment
			if ( IsDefined( level.zombie_include_equipment ) && IsDefined( level.zombie_include_equipment[ primary_weapons[ x ] ] ) )
			{
				continue;
			}
			
			// exclude specific weapons from this list
			if ( IsDefined( level.zombie_weapons_no_max_ammo ) && IsDefined( level.zombie_weapons_no_max_ammo[ primary_weapons[ x ] ] ) )
			{
				continue;
			}

			if ( players[i] HasWeapon( primary_weapons[x] ) )
				players[i] GiveMaxAmmo( primary_weapons[x] );
		}
	}

	level thread full_ammo_on_hud( drop_item, player.team );
}

function full_ammo_on_hud( drop_item, player_team )
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
