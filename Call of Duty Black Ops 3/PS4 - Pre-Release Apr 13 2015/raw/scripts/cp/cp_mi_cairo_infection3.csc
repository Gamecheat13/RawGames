#using scripts\codescripts\struct;

#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_cairo_infection3_fx;
#using scripts\cp\cp_mi_cairo_infection3_sound;

#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\cp_mi_cairo_infection_zombies;
#using scripts\cp\cp_mi_cairo_infection_hideout_outro;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                               	                                                          	              	                                                                                           

function main()
{
	util::set_streamer_hint_function( &force_streamer, 7 );
	
	
	cp_mi_cairo_infection3_fx::main();
	cp_mi_cairo_infection3_sound::main();
		
	infection_zombies::main();
	hideout_outro::main();
		
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

//--------------------------------------------------------------------------------------------------
// 	force_streamer
//--------------------------------------------------------------------------------------------------
function force_streamer( n_zone )
{
    switch ( n_zone )
    {
        case 5:
            ForceStreamBundle( "cin_inf_14_04_sarah_vign_05" );
            break;
           
        default:
            break;
    }
}