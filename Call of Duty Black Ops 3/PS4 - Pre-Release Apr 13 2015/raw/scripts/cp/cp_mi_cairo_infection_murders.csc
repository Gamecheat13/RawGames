#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;

#namespace blackstation_murders;

//--------------------------------------------------------------------------------------------------
//		main
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
	clientfield::register("world", "black_station_ceiling_fxanim", 1, 2, "int", &black_station_ceiling_fxanim, true, true);
}	

//--------------------------------------------------------------------------------------------------
// 	black_station_ceiling_fxanim
//--------------------------------------------------------------------------------------------------
function black_station_ceiling_fxanim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		//init is supposed to move buildings up into place.
		level thread scene::init( "p7_fxanim_cp_infection_ceiling_open_bundle" );
	}
	else if(newVal == 2)
	{
		level thread scene::play( "p7_fxanim_cp_infection_ceiling_open_bundle" );
	}		
}
