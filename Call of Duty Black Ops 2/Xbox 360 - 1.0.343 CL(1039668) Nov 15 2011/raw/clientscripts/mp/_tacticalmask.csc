#include clientscripts\mp\_utility;
#include clientscripts\_filter;

init()
{
	level thread updateTacticalMask();
}

updateTacticalMask()
{
	WaitForClient( 0 );
	
	while ( true )
	{
		players = GetLocalPlayers();
		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( players[i] HasTacticalMaskOverlay() )
			{
				if ( !isDefined( players[i].tacticalMaskFilterMapped ) )
				{
					players[i].tacticalMaskFilterMapped = 1;
					init_filter_tacticalmask( players[i] );
				}
				enable_filter_tacticalmask( players[i], 0 );
			}
			else
				edisable_filter_tacticalmask( players[i], 0 );
		}
		wait 0.01;
	}
}