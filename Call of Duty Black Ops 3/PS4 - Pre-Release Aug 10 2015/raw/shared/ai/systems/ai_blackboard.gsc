    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     



#namespace Blackboard;

function autoexec main()
{
	_InitializeBlackboard();
}

function private _InitializeBlackboard()
{
	level.__ai_blackboard = [];
	level thread _UpdateEvents();
}

function private _UpdateEvents()
{
	waitTime = 1 * .05;
	updateMillis =  waitTime * 1000;
	
	while ( true )
	{
		foreach ( eventName, events in level.__ai_blackboard )
		{
			liveEvents = [];
		
			// Reduce time to live, and only keep events that still have addition time to live.
			foreach ( event in events )
			{
				event.ttl = event.ttl - updateMillis;
				
				if ( event.ttl > 0 )
				{
					liveEvents[ liveEvents.size ] = event;
				}
			}
			
			level.__ai_blackboard[ eventName ] = liveEvents;
		}
		
		wait waitTime;
	}
}

function AddBlackboardEvent( eventName, data, timeToLiveInMillis )
{
	/#
	assert( IsString( eventName ), "Must pass in an event name when adding an event to the blackboard." );
	assert( IsDefined( data ), "Must pass in some type of data to store as an event." );
	assert( IsInt( timeToLiveInMillis ) && timeToLiveInMillis > 0,
		"Must pass in a positive time to live value for the lifespan of the event." );
	#/

	event = SpawnStruct();
	event.data = data;
	event.timestamp = GetTime();
	event.ttl = timeToLiveInMillis;
	
	if ( !isdefined( level.__ai_blackboard[eventName] ) ) level.__ai_blackboard[eventName] = []; else if ( !IsArray( level.__ai_blackboard[eventName] ) ) level.__ai_blackboard[eventName] = array( level.__ai_blackboard[eventName] ); level.__ai_blackboard[eventName][level.__ai_blackboard[eventName].size]=event;;
}

function GetBlackboardEvents( eventName )
{
	if ( IsDefined( level.__ai_blackboard[eventName] ) )
	{
		return level.__ai_blackboard[eventName];
	}
	
	return [];
}

function RemoveBlackboardEvents( eventName )
{
	if ( IsDefined( level.__ai_blackboard[eventName] ) )
	{
		level.__ai_blackboard[eventName] = undefined;
	}
}