#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;

//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	//will be 8 building destruction bundles
	n_building_bundles = 8;
	for( i = 1; i <= n_building_bundles; i++ )
	{
		str_name = "p7_fxanim_cp_infection_sarah_building_0" + i + "_bundle";
		s_test = struct::get( str_name, "scriptbundlename" );//make sure scriptbundle exists.
		if( isdefined( s_test ) )
		{	
			level scene::init( str_name );	
		}
	}
	
	init_clientfields();
}

function init_clientfields()
{
	n_clientbits = GetMinBitCountForNum( 8 );
	
	clientfield::register("world", "building_destruction_callback", 1, n_clientbits, "int", &building_destruction_callback, !true, !true);
	clientfield::register("world", "building_end_callback", 1, 1, "int", &building_end_callback, !true, !true);
}	
//--------------------------------------------------------------------------------------------------
// 	Building Destruction
//--------------------------------------------------------------------------------------------------
function building_destruction_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		str_name = "p7_fxanim_cp_infection_sarah_building_0" + newVal + "_bundle";
		
		s_test = struct::get( str_name, "scriptbundlename" );//make sure scriptbundle exists.
		if( isdefined( s_test ) )
		{	
			level scene::play( str_name );	
		}
	}
}

function building_end_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		n_building_bundles = 8;
		for( i = 1; i <= n_building_bundles; i++ )
		{
			str_name = "p7_fxanim_cp_infection_sarah_building_0" + i + "_bundle";
			s_test = struct::get( str_name, "scriptbundlename" );//make sure scriptbundle exists.
			if( isdefined( s_test ) )
			{	
				level scene::play( str_name );	//TODO: will need to be a skipto_end so we don't have to wait for them to explode.
			}
		}
	}
}
