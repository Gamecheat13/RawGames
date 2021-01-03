#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_utility;

#namespace zm_server_throttle;

function server_choke_init( id, max )
{
	if ( !isdefined( level.zombie_server_choke_ids_max ) )
	{
		level.zombie_server_choke_ids_max = [];
		level.zombie_server_choke_ids_count = [];
	}

	level.zombie_server_choke_ids_max[ id ] = max;
	level.zombie_server_choke_ids_count[ id ] = 0;

	level thread server_choke_thread( id );
}


function server_choke_thread( id )
{
	while( 1 )
	{
		{wait(.05);};
		level.zombie_server_choke_ids_count[ id ] = 0;
	}
}


function server_choke_safe( id )
{
	return( level.zombie_server_choke_ids_count[ id ] < level.zombie_server_choke_ids_max[ id ] );
}


function server_choke_action( id, choke_action, arg1, arg2, arg3 )
{
	Assert( isdefined( level.zombie_server_choke_ids_max[ id ] ), "server Choke: " + id + " undefined" );

	while( !server_choke_safe( id ) )
	{
		{wait(.05);};		
	}

	level.zombie_server_choke_ids_count[ id ]++;

	if ( !isdefined( arg1 ) )
	{
		return ( [[choke_action]]() );
	}

	if ( !isdefined( arg2 ) )
	{
		return ( [[choke_action]]( arg1 ) );
	}
	
	if ( !isdefined( arg3 ) )
	{
		return ( [[choke_action]]( arg1, arg2 ) );
	}
	
	return ( [[choke_action]]( arg1, arg2, arg3 ) );
}


function server_entity_valid( entity )
{
	if( !isdefined( entity ) )
	{
		return false;
	}
	
	return true;
}


function server_safe_init( id, max )
{
	if ( !isdefined( level.zombie_server_choke_ids_max ) || !isdefined( level.zombie_server_choke_ids_max[ id ] ) )
	{
		server_choke_init( id, max );
	}

	assert( max == level.zombie_server_choke_ids_max[ id ] );
}

function _server_safe_ground_trace( pos )
{
	return zm_utility::groundpos( pos );
}

function server_safe_ground_trace( id, max, origin )
{
	server_safe_init( id, max );
	return( server_choke_action( id,&_server_safe_ground_trace, origin ) );
}

function _server_safe_ground_trace_ignore_water( pos )
{
	return zm_utility::groundpos_ignore_water( pos );
}

function server_safe_ground_trace_ignore_water( id, max, origin )
{
	server_safe_init( id, max );
	return( server_choke_action( id,&_server_safe_ground_trace_ignore_water, origin ) );
}