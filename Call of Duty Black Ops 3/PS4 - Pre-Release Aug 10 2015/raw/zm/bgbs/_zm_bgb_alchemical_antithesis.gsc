#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

    

                                                                 
                                                                                                                               

#namespace zm_bgb_alchemical_antithesis;


function autoexec __init__sytem__() {     system::register("zm_bgb_alchemical_antithesis",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_alchemical_antithesis", "activated", 2, undefined, undefined, &validation, &activation );
	bgb::register_add_to_player_score_override( "zm_bgb_alchemical_antithesis", &add_to_player_score_override );
}

function activation()
{
	self bgb::run_timer( 60 ); // block, show timer
	self bgb::do_one_shot_use();
}

// only allow activation if we aren't already mid-activation
function validation()
{
	return !( isdefined( self bgb::get_active() ) && self bgb::get_active() );
}

// for every 10 points that would have been earned, at 1 ammo to the stock of the current weapon
// self = player
function add_to_player_score_override( points )
{
	if( !( isdefined( self.bgb_active ) && self.bgb_active ) )
	{
		return points;
	}

	n_ammo_count_to_add = Int( points / 10 ); // should be fine doing this as long as our points are always at least a multiple of 10
	current_weapon = self GetCurrentWeapon();
	n_current_ammo_stock = self GetWeaponAmmoStock( current_weapon );
	n_current_ammo_stock += n_ammo_count_to_add;
	self SetWeaponAmmoStock( current_weapon, n_current_ammo_stock );
	
	return 0; // while active, this eats up all incoming points
}
