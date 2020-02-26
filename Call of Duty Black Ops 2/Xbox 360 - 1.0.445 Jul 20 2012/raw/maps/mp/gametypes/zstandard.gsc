#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


/*
	zstandard - zstandard Mode, wave based gameplay
	Objective: 	Stay alive for as long as you can
	Map ends:	When all players die
	Respawning:	No wait / Near teammates
*/

main()
{
	maps\mp\gametypes\_zm_gametype::main("zstandard");
}
  	
