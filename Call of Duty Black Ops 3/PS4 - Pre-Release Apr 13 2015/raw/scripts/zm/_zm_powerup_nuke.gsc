#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\gib;

#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

                                                                
                                                                                                                               

                                                                                                                                                                                                                                                                                                                                                                   



#precache( "string", "ZOMBIE_POWERUP_NUKE" );
#precache( "fx", "zombie/fx_powerup_nuke_zmb" );

#namespace zm_powerup_nuke;

function autoexec __init__sytem__() {     system::register("zm_powerup_nuke",&__init__,undefined,undefined);    }


//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "nuke", &grab_nuke );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "nuke", "p7_zm_power_up_nuke", &"ZOMBIE_POWERUP_NUKE", &zm_powerups::func_should_always_drop, !true, !true, !true, "zombie/fx_powerup_nuke_zmb" );
	}	
}

function grab_nuke( player )
{
	level thread nuke_powerup( self, player.team );
	
	//chrisp - adding powerup VO sounds
	player thread zm_powerups::powerup_vo("nuke");
	zombies = GetAiTeamArray( level.zombie_team );
	//player.zombie_nuked = array::get_all_closest( self.origin, zombies );
	player.zombie_nuked = ArraySort( zombies, self.origin );
	player notify("nuke_triggered");	
}

// kill them all!
function nuke_powerup( drop_item, player_team )
{
	location = drop_item.origin;

	PlayFx( drop_item.fx, location );
	level thread nuke_flash(player_team);

	wait( 0.5 );

	zombies = GetAiTeamArray( level.zombie_team );
	//zombies = array::get_all_closest( location, zombies );
	zombies = ArraySort( zombies, location );
	zombies_nuked = [];

	// Mark them for death
	for (i = 0; i < zombies.size; i++)
	{
		// unaffected by nuke
		if ( ( isdefined( zombies[i].ignore_nuke ) && zombies[i].ignore_nuke ) )
		{
			continue;
		}

		// already going to die
		if ( IsDefined(zombies[i].marked_for_death) && zombies[i].marked_for_death )
		{
			continue;
		}

		// check for custom damage func
		if ( IsDefined(zombies[i].nuke_damage_func) )
		{
			zombies[i] thread [[ zombies[i].nuke_damage_func ]]();
			continue;
		}
		
		if( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}

		zombies[i].marked_for_death = true;
		zombies[i].nuked = true;
		zombies_nuked[ zombies_nuked.size ] = zombies[i];
	}

	for (i = 0; i < zombies_nuked.size; i++)
	{
		wait (randomfloatrange(0.1, 0.7));
		if( !IsDefined( zombies_nuked[i] ) )
		{
			continue;
		}

		if( zm_utility::is_magic_bullet_shield_enabled( zombies_nuked[i] ) )
		{
			continue;
		}

		if( i < 5 && !( ( isdefined( zombies_nuked[i].isdog ) && zombies_nuked[i].isdog ) ) )
		{
			zombies_nuked[i] thread zombie_death::flame_death_fx();
		}

		if( !( ( isdefined( zombies_nuked[i].isdog ) && zombies_nuked[i].isdog ) ) )
		{
			if ( !( isdefined( zombies_nuked[i].no_gib ) && zombies_nuked[i].no_gib ) )
			{
				zombies_nuked[i] zombie_utility::zombie_head_gib();
			}
			zombies_nuked[i] playsound ("evt_nuked");
		}
		

		zombies_nuked[i] dodamage( zombies_nuked[i].health + 666, zombies_nuked[i].origin );
	}

	players = GetPlayers( player_team );
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_score::player_add_points( "nuke_powerup", 400 ); 
	}
}

function nuke_flash(team)
{
/*	players = GetPlayers();	
	for(i=0; i<players.size; i ++)
	{
		players[i] zm_utility::play_sound_2d("evt_nuke_flash");
	}
	level thread devil_dialog_delay(); */

	if (IsDefined(team))
		GetPlayers()[0] PlaySoundToTeam("evt_nuke_flash", team);
	else
		GetPlayers()[0] PlaySound("evt_nuke_flash");
		
	fadetowhite = newhudelem();

	fadetowhite.x = 0;
	fadetowhite.y = 0;
	fadetowhite.alpha = 0;

	fadetowhite.horzAlign = "fullscreen";
	fadetowhite.vertAlign = "fullscreen";
	fadetowhite.foreground = true;
	fadetowhite SetShader( "white", 640, 480 );

	// Fade into white
	fadetowhite FadeOverTime( 0.2 );
	fadetowhite.alpha = 0.8;

	wait 0.5;
	fadetowhite FadeOverTime( 1.0 );
	fadetowhite.alpha = 0;

	wait 1.1;
	fadetowhite destroy();
}
