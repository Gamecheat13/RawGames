#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;


main()
{
	clientscripts\mp\zm_transit::gamemode_common_setup( "meat", "tunnel", "zm_encounters_town", 2 );
	
	/*
	level thread clientscripts\mp\zombies\_zm_game_mode_objects::init_game_mode_objects("meat","tunnel");	
	//level thread clientscripts\mp\zombies\_zm_audio::zmbMusLooper();
	players = GetLocalPlayers();
	for(i=0;i<players.size;i++)
	{
		localclientnum = players[i] GetLocalClientNumber();
		if(!isDefined(localclientnum))
		{
			return;
		}
		visionsetnaked(localclientnum,"zm_encounters_town",5);
		SetWorldFogActiveBank(localclientnum,2);
	}	
	*/
}