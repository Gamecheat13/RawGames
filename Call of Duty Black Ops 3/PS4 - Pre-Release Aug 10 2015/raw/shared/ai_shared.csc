    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function autoexec main()
{
	level._customActorCBFunc = &ai::spawned_callback;
}

#namespace ai;

function add_ai_spawn_function( spawn_func )
{
	if ( !IsDefined( level.spawn_ai_func ) )
	{
		level.spawn_ai_func = [];
	}

	func = [];
	func[ "function" ] = spawn_func;

	level.spawn_ai_func[ level.spawn_ai_func.size ] = func;
}

function add_archetype_spawn_function( archetype, spawn_func )
{
	if ( !IsDefined( level.spawn_funcs ) )
	{
		level.spawn_funcs = [];
	}
	
	if ( !IsDefined( level.spawn_funcs[archetype] ) )
	{
		level.spawn_funcs[archetype] = [];
	}
	
	func = [];
	func[ "function" ] = spawn_func;
	
	if ( !isdefined( level.spawn_funcs[ archetype ] ) ) level.spawn_funcs[ archetype ] = []; else if ( !IsArray( level.spawn_funcs[ archetype ] ) ) level.spawn_funcs[ archetype ] = array( level.spawn_funcs[ archetype ] ); level.spawn_funcs[ archetype ][level.spawn_funcs[ archetype ].size]=func;;
}

function spawned_callback( localClientNum )
{
	if ( IsDefined( level.spawn_ai_func ) )
	{
		for ( index = 0; index < level.spawn_ai_func.size; index++ )
		{
			func = level.spawn_ai_func[ index ];
			self thread [[ func[ "function" ] ]]( localClientNum );
		}
	}

	if ( IsDefined( level.spawn_funcs ) && IsDefined( level.spawn_funcs[ self.archetype ] ) )
	{
		for ( index = 0; index < level.spawn_funcs[ self.archetype ].size; index++ )
		{
			func = level.spawn_funcs[ self.archetype ][ index ];
			
			self thread [[ func[ "function" ] ]]( localClientNum );
		}
	}
}