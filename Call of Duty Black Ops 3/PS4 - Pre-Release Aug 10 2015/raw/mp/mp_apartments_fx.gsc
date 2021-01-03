#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

//#using scripts\mp\createart\mp_apartments_art;

function main()
{
	precache_fxanim_props();
	precache_scripted_fx();
	
	//mp_apartments_art::main();
		
	//Commenting out due to breaking game PTASKER 9/23/11
	//wind_initial_setting();
}

// Scripted effects
function precache_scripted_fx()
{
	
}

/*  Commenting out due to breaking game PTASKER 9/23/11
function wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-120 -115 -120" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}
*/

// FXanim Props
function precache_fxanim_props()
{
	level.scr_anim = [];
	level.scr_anim[ "fxanim_props" ] = [];
}