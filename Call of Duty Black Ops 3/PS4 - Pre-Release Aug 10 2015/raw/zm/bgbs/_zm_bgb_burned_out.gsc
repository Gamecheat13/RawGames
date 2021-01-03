#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

                  

                                                                 
                                                                                                                               

#namespace zm_bgb_burned_out;


function autoexec __init__sytem__() {     system::register("zm_bgb_burned_out",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_burned_out", "event", &event, undefined, undefined, undefined );

	clientfield::register( "toplayer", (("zm_bgb_burned_out" + "_1p") + "toplayer"), 1, 1, "counter" ); 
	clientfield::register( "allplayers", (("zm_bgb_burned_out" + "_3p") + "_allplayers"), 1, 1, "counter" ); 
	clientfield::register( "actor", (("zm_bgb_burned_out" + "_fire_torso") + "_actor"), 1, 1, "counter" ); 
	clientfield::register( "vehicle", (("zm_bgb_burned_out" + "_fire_torso") + "_vehicle"), 1, 1, "counter" ); 
}


function event()
{
	self endon( "disconnect" );
	self endon( "bgb_update" );

	limit_count = 0;
	self thread bgb::set_timer( 2, 2 );
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );

		if ( "MOD_MELEE" != type || !IsAi( attacker ) )
		{
			continue;
		}

		self thread result();
		self playsound( "zmb_bgb_powerup_burnedout" );
		
		limit_count++;
		self thread bgb::set_timer( 2 - limit_count, 2 );
		self bgb::do_one_shot_use();
		if ( 2 <= limit_count )
		{
			return;
		}

		wait( 1.5 ); // wait a couple seconds so we don't waste a second result while the first is still getting going
	}
}


function result()
{
	self clientfield::increment_to_player( (("zm_bgb_burned_out" + "_1p") + "toplayer") );
	self clientfield::increment( (("zm_bgb_burned_out" + "_3p") + "_allplayers") );

	zombies = array::get_all_closest( self.origin, GetAiTeamArray( level.zombie_team ), undefined, undefined, 720 );
	if ( !isDefined( zombies ) )
	{
		return;
	}

	dist_sq = ( (720) * (720) );
	zombies_burned_out = [];

	// Mark them for death
	for ( i = 0; i < zombies.size; i++ )
	{
		// unaffected by nuke
		if ( ( isdefined( zombies[i].ignore_nuke ) && zombies[i].ignore_nuke ) )
		{
			continue;
		}

		// already going to die
		if ( ( isdefined( zombies[i].marked_for_death ) && zombies[i].marked_for_death ) )
		{
			continue;
		}

		if ( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}

		zombies[i].marked_for_death = true;

		if ( IsVehicle( zombies[i] ) )
		{
			zombies[i] clientfield::increment( (("zm_bgb_burned_out" + "_fire_torso") + "_vehicle") );
		}
		else
		{
			zombies[i] clientfield::increment( (("zm_bgb_burned_out" + "_fire_torso") + "_actor") );
		}

		zombies_burned_out[ zombies_burned_out.size ] = zombies[i];
	}

	for ( i = 0; i < zombies_burned_out.size; i++ )
	{
		util::wait_network_frame();
		if ( !IsDefined( zombies_burned_out[i] ) )
		{
			continue;
		}

		if ( zm_utility::is_magic_bullet_shield_enabled( zombies_burned_out[i] ) )
		{
			continue;
		}

		zombies_burned_out[i] dodamage( zombies_burned_out[i].health + 666, zombies_burned_out[i].origin );
	}
}
