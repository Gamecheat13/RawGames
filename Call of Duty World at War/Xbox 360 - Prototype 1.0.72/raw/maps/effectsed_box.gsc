#include maps\_utility;
main()
{
 maps\effectsEd_box_fx::main();
 maps\_load::main();	
 
 players = GetEntArray( "player", "classname" );
 
 for( i = 0; i < players.size; i++ )
 {
 	players[i] takeallweapons();
  // Testing out weapons.
  players[i] GiveWeapon("flamethrower");
  players[i] GiveWeapon("thompson");
  players[i] SwitchToWeapon("flamethrower");
//  players[i] GiveWeapon("fraggrenade"); 
 }
}  