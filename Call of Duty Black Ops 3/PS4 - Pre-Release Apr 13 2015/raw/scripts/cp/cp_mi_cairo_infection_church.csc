#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

#using scripts\cp\_load;
#using scripts\shared\util_shared;

#namespace church;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	init_clientfields();
}

//--------------------------------------------------------------------------------------------------
// 	init_clientfields
//--------------------------------------------------------------------------------------------------
function init_clientfields()
{
	clientfield::register( "world", "light_church_int_cath_all",	1, 1, "int", &callback_light_church_int_cath_all,	!true, !true );
}

//--------------------------------------------------------------------------------------------------
// 	callback_light_church_int_cath_all
//--------------------------------------------------------------------------------------------------
function callback_light_church_int_cath_all( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		exploder::exploder( "light_church_int_cath_all" );
	}
	else
	{
		exploder::stop_exploder( "light_church_int_cath_all" );
	}
}
