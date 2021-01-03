#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_utility;

   

                                                                 
                                                                                       	                                
                                                                                                                               

#using scripts\shared\ai\systems\gib;

#namespace zm_bgb_aftertaste;


function autoexec __init__sytem__() {     system::register("zm_bgb_aftertaste",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}
	
	bgb::register( "zm_bgb_aftertaste", "rounds", 3, &event, undefined, undefined, undefined );
	bgb::register_lost_perk_override( "zm_bgb_aftertaste", &lost_perk_override );
}

function lost_perk_override( perk )
{
	// if perk is Quick Revive, and there's one player, return false
	if( zm_perks::use_solo_revive() && ( perk == "specialty_quickrevive" ) )
	{
		return false;
	}
	
	return true;
}

function event()
{
	self endon( "disconnect" );
	self endon( "bled_out" );
	self endon( "bgb_update" );
	
	while( true )
	{
		self waittill( "player_downed" );
		self bgb::do_one_shot_use();
	}
}
