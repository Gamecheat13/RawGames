#include maps\_utility;
main()
{

	players = GetEntArray( "player", "classname" );
	
	for( i = 0; i < players.size; i++ )
	{
		// Testing out weapons.
		players[i] GiveWeapon("m1garand");
		players[i] GiveWeapon("thompson");
		players[i] SwitchToWeapon("m1garand");
		players[i] GiveWeapon("fraggrenade"); 
	}
}