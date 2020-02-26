
#include maps\mp\_utility;

music_init()
{
	assert(level.clientscripts);

	level.musicState = "";
	registerClientSys("musicCmd");
}

setMusicState(state, player)
{
	if (isdefined(level.musicState))
	{
		if( isDefined( player ) )
		{
				setClientSysState("musicCmd", state, player );
				//println ( "Music cl Number " + player getEntityNumber() );
				return;
		}
		else if(level.musicState != state)
		{
				setClientSysState("musicCmd", state );
		}
	}
	level.musicState = state;
}
