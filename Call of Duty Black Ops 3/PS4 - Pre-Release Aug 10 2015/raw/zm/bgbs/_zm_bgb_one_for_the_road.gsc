#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;

   
 
                                                                 
                                                                                                                               

#namespace zm_bgb_one_for_the_road;


function autoexec __init__sytem__() {     system::register("zm_bgb_one_for_the_road",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}
	
	bgb::register( "zm_bgb_one_for_the_road", "time", 600, undefined, undefined, undefined, undefined );
	bgb::register_perk_purchase_limit_override( "zm_bgb_one_for_the_road", &perk_purchase_limit_override );
}

// add one to whatever the current perk purchase limit is
function perk_purchase_limit_override( n_perk_purchase_limit_override )
{
	if( isdefined( n_perk_purchase_limit_override ) )
	{
		n_perk_purchase_limit_override++;
	}
	else
	{
		n_perk_purchase_limit_override = level.perk_purchase_limit + 1;
	}

	return n_perk_purchase_limit_override;
}
