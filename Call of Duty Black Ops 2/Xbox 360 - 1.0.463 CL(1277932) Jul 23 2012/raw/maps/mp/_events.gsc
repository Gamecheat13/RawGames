#include maps\mp\_utility;

/*------------------------------------
Adds an event based on the current value of the gametypes timer
------------------------------------*/
add_timed_event( seconds, notify_string, client_notify_string )
{
	assert( seconds >= 0 );

	if ( level.timelimit > 0 )
	{
		level thread timed_event_monitor( seconds, notify_string, client_notify_string );
	}
}


/*------------------------------------
checks the game/level timer for timed events 
------------------------------------*/
timed_event_monitor( seconds, notify_string, client_notify_string )
{
	for ( ;; )
	{
		wait( 0.5 );
		
		if( !IsDefined( level.startTime ) )
		{
			continue;
		}
		
		//get the time remaining and see if events need to be fired off
		millisecs_remaining =  maps\mp\gametypes\_globallogic_utils::getTimeRemaining();
		seconds_remaining = millisecs_remaining / 1000;

		if( seconds_remaining <= seconds )
		{
			event_notify( notify_string, client_notify_string );
			return;
		}
	}
}


add_score_event( score, notify_string, client_notify_string )
{
	assert( score >= 0 );

	if ( level.scoreLimit > 0 )
	{
		if ( level.teamBased )
		{
			level thread score_team_event_monitor( score, notify_string, client_notify_string );
		}
		else
		{
			level thread score_event_monitor( score, notify_string, client_notify_string );
		}
	}
}

any_team_reach_score( score )
{
	foreach( team in level.teams )
	{
		if ( game["teamScores"][team] >= score )
			return true;
	}
	
	return false;
}

score_team_event_monitor( score, notify_string, client_notify_string )
{
	for ( ;; )
	{
		wait( 0.5 );

		if ( any_team_reach_score( score ) )
		{
			event_notify( notify_string, client_notify_string );
			return;
		}
	}
}


score_event_monitor( score, notify_string, client_notify_string )
{
	for ( ;; )
	{
		wait ( 0.5 );

		players = GET_PLAYERS();

		for ( i = 0; i < players.size; i++ )
		{
			if ( IsDefined( players[i].score ) && players[i].score >= score )
			{
				event_notify( notify_string, client_notify_string );
				return;
			}
		}
	}
}


event_notify( notify_string, client_notify_string )
{
	if ( IsDefined( notify_string ) )
	{
		level notify( notify_string );
	}

	if ( IsDefined( client_notify_string ) )
	{
		ClientNotify( client_notify_string );
	}
}

