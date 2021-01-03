#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace counteruav;

function autoexec __init__sytem__() {     system::register("counteruav",&__init__,undefined,undefined);    }

function __init__()
{	
	clientfield::register( "scriptmover", "counteruav", 1, 1, "int", &spawned, !true, !true );
}

function spawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !isdefined( level.counteruavs ) )
	{
		level.counteruavs = [];
	}

	if ( !isdefined( level.counteruavs[localClientNum] ) )
	{
		level.counteruavs[localClientNum] = 0;
	}
		
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	if ( newVal )
	{
		level.counteruavs[localClientNum]++;
		self thread counteruav_think( localClientNum );
		player SetEnemyGlobalScrambler( true );
	}
	else
	{
		self notify( "counteruav_off" );
	}
}

function counteruav_think( localClientNum )
{
	self util::waittill_any( "entityshutdown", "counteruav_off" );

	level.counteruavs[localClientNum]--;

	if ( level.counteruavs[localClientNum] < 0 )
	{
		// reference counting gone bad
		level.counteruavs[localClientNum] = 0;
	}

	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	if ( level.counteruavs[localClientNum] == 0 )
	{
		player SetEnemyGlobalScrambler( 0 );
	}
}
