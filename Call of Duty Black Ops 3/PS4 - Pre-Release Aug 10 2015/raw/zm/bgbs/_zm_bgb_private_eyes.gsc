#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

   

                                                                 
                                                                                                                               

#using scripts\shared\ai\systems\gib;

#namespace zm_bgb_private_eyes;


function autoexec __init__sytem__() {     system::register("zm_bgb_private_eyes",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}
	
	bgb::register( "zm_bgb_private_eyes", "rounds", 1, &enable, &disable, undefined, undefined );
	
	// zombie awareness around player
	clientfield::register( "toplayer", 	"bgb_private_eyes"	, 1, 1,		"int" );
}

function enable()
{
	self clientfield::set_to_player( "bgb_private_eyes", 1 );
	self thread wait_for_disable();
}

function disable()
{
	self clientfield::set_to_player( "bgb_private_eyes", 0 );
	self bgb::do_one_shot_use();
	bgb::activation_complete();
}

function wait_for_disable()
{
	self util::waittill_any( "bgb_deactivate", "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect" );
	self disable();
}
