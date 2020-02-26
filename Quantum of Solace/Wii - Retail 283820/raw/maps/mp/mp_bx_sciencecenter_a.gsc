#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	precacheShader( "compass_map_mp_bx_sciencecenter_a" );
	setminimap( "compass_map_mp_bx_sciencecenter_a", -1000, 2744, 2544, 248 ); 

	
	sbm = getEntArray("script_brushmodel","classname");
	for (i = 0 ; i < sbm.size; i++)
		sbm[i] hide();

	sm = getEntArray("script_model","classname");
	for (i = 0 ; i < sm.size; i++)
		sm[i] hide();

	
	
	

	level.mp_musicplay = "mus_scb_hall_lp";
}