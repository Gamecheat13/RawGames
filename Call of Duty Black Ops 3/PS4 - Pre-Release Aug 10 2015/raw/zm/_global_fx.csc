#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace global_fx;

function autoexec __init__sytem__() {     system::register("global_fx",&__init__,&main,undefined);    }

function __init__()
{
	wind_initial_setting();
}

function main()
{
	check_for_wind_override();
}

function wind_initial_setting()
{
	SetSavedDvar( "enable_global_wind", 1 );				// enable wind for your level
	SetSavedDvar( "wind_global_vector", "-110 -150 -110" );	// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", -175 );		// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 4000 );		// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", .5 );	// change 0.5 to your desired wind strength percentage
}

function check_for_wind_override()
{
	//Allow for level overrides of global wind settings
	if( isdefined( level.custom_wind_callback ) )
	{
		level thread [[level.custom_wind_callback]]();
	}
}
	
