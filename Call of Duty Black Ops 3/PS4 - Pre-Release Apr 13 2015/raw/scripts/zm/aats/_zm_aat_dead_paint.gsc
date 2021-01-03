#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_utility;

               

                                                                                                                               

#precache( "material", "t7_hud_zm_aat_dead_paint" );

#namespace zm_aat_dead_paint;


function autoexec __init__sytem__() {     system::register("zm_aat_dead_paint",&__init__,undefined,"aat");    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_dead_paint", 0.5, 1, 1, true, &result, "t7_hud_zm_aat_dead_paint", "wpn_aat_dead_paint_plr" );

	clientfield::register( "actor", "zm_aat_dead_paint", 1, 1, "counter" ); 
}

function result( death, attacker, mod, weapon )
{
	self clientfield::increment( "zm_aat_dead_paint" );

	attacker RadiusDamage( self.origin, 100, 600, 300, attacker );
}
