#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace demo;

function autoexec __init__sytem__() {     system::register("demo",&__init__,undefined,undefined);    }	

function __init__()
{
	level thread watch_actor_bookmarks();
}

function initActorBookmarkParams( killTimesCount, killTimeMsec, killTimeDelay )
{
	level.actor_bookmark_kill_times_count = killTimesCount;
	level.actor_bookmark_kill_times_msec = killTimeMsec;
	level.actor_bookmark_kill_times_delay = killTimeDelay;

	level.actorbookmarkParamsInitialized = true;
}

function bookmark( type, time, mainClientEnt, otherClientEnt, eventPriority, inflictorEnt, overrideEntityCamera, actorEnt )
{
	mainClientNum = -1;
	otherClientNum = -1;
	inflictorEntNum = -1;
	inflictorEntType = 0;
	inflictorBirthTime = 0;
	actorEntNum = undefined;
	scoreEventPriority = 0;

	if ( isdefined( mainClientEnt ) )
	{
		mainClientNum = mainClientEnt getEntityNumber();
	}

	if ( isdefined( otherClientEnt ) )
	{
		otherClientNum = otherClientEnt getEntityNumber();
	}

	if ( isdefined( eventPriority ) )
	{
		scoreEventPriority = eventPriority;
	}

	if ( isdefined( inflictorEnt ) )
	{
		inflictorEntNum = inflictorEnt getEntityNumber();
		inflictorEntType = inflictorEnt getEntityType();

		if ( isdefined( inflictorEnt.birthTime ) )
		{
			inflictorBirthTime = inflictorEnt.birthTime;
		}
	}

	if ( !isdefined( overrideEntityCamera ) )
	{
		overrideEntityCamera = false;
	}

	if ( isdefined( actorEnt ) )
	{
		actorEntNum = actorEnt getEntityNumber();
	}

	addDemoBookmark( type, time, mainClientNum, otherClientNum, scoreEventPriority, inflictorEntNum, inflictorEntType, inflictorBirthTime, overrideEntityCamera, actorEntNum );
}

function gameResultBookmark( type, winningTeamIndex, losingTeamIndex )
{
	mainClientNum = -1;
	otherClientNum = -1;
	scoreEventPriority = 0;
	inflictorEntNum = -1;
	inflictorEntType = 0;
	inflictorBirthTime = 0;
	overrideEntityCamera = false;
	actorEntNum = undefined;

	if ( isdefined( winningTeamIndex ) )
	{
		mainClientNum = winningTeamIndex;
	}

	if ( isdefined( losingTeamIndex ) )
	{
		otherClientNum = losingTeamIndex;
	}

	// We reuse mainClientNum and otherClientNum for the winning and losing teamIndex
	addDemoBookmark( type, gettime(), mainClientNum, otherClientNum, scoreEventPriority, inflictorEntNum, inflictorEntType, inflictorBirthTime, overrideEntityCamera, actorEntNum );
}

function reset_actor_bookmark_kill_times()
{
	if ( !isDefined( level.actorbookmarkParamsInitialized ) )
	{
		return;
	}
	
	if ( !IsDefined( self.actor_bookmark_kill_times ) )
	{
		self.actor_bookmark_kill_times = [];
		self.ignore_actor_kill_times = 0;
	}

	for ( i = 0; i < level.actor_bookmark_kill_times_count; i++ )
	{
		self.actor_bookmark_kill_times[i] = 0;
	}
}


function add_actor_bookmark_kill_time()
{
	if ( !isDefined( level.actorbookmarkParamsInitialized ) )
		return;

	now = gettime();
	if ( now <= self.ignore_actor_kill_times )
	{
		return;
	}

	oldest_index = 0;
	oldest_time = now + 1;

	for ( i = 0; i < level.actor_bookmark_kill_times_count; i++ )
	{
		if ( !self.actor_bookmark_kill_times[i] )
		{
			oldest_index = i;
			break;
		}
		else if ( oldest_time > self.actor_bookmark_kill_times[i] )
		{
			oldest_index = i;
			oldest_time = self.actor_bookmark_kill_times[i];
		}
	}

	self.actor_bookmark_kill_times[oldest_index] = now;
}


function watch_actor_bookmarks()
{
	while ( true )
	{
		if ( !isDefined( level.actorbookmarkParamsInitialized ) )
		{
			wait( 0.5 );
			continue;
		}

		{wait(.05);};
		waittillframeend;

		now = gettime();
		oldest_allowed = now - level.actor_bookmark_kill_times_msec;
		players = GetPlayers();
		for ( player_index = 0; player_index < players.size; player_index++ )
		{
			player = players[player_index];
			
			/#
			if (( isdefined( player.pers["isBot"] ) && player.pers["isBot"] ))
				continue;
			#/

			for ( time_index = 0; time_index < level.actor_bookmark_kill_times_count; time_index++ )
			{
				if ( !IsDefined( player.actor_bookmark_kill_times ) || !player.actor_bookmark_kill_times[time_index] )
				{
					break;
				}
				else if ( oldest_allowed > player.actor_bookmark_kill_times[time_index] )
				{
					player.actor_bookmark_kill_times[time_index] = 0;
					break;
				}
			}
			
			if ( time_index >= level.actor_bookmark_kill_times_count ) // all times slots were within the needed range
			{
				bookmark( "actor_kill", gettime(), player );
				player reset_actor_bookmark_kill_times();
				player.ignore_actor_kill_times = now + level.actor_bookmark_kill_times_delay;
			}
		}
	}
}
