#include clientscripts\_utility; 

main()
{
	level thread rumble_garrote();
}

rumble_garrote()
{
	while (true)
	{
		level waittill("garrote_stand");
		player = level.localPlayers[0];
		player PlayRumbleOnEntity( 0, "melee_garrote");
	}
}