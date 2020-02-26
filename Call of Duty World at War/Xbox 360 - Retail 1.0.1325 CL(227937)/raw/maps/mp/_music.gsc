
#include maps\mp\_utility;

music_init()
{
	assert(level.clientscripts);

	level.musicState = "";
	registerClientSys("musicCmd");
}

setMusicState(state, player)
{
	if( isDefined( player ) )
	{
			player setClientSysState("musicCmd", state );
			return;
	}
	else if(level.musicState != state)
	{
			setClientSysState("musicCmd", state );
	}
	level.musicState = state;
}
