#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	maps\mp\_load::main();
	
	game["allies"] = "mi6";
	game["axis"] = "terrorists";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	precacheShader( "compass_map_mp_bx_white_estate" );
	setminimap( "compass_map_mp_bx_white_estate", -3144, 1178, -440, -1480 ); 

	
	precacheFX();
	playFX();

	
	sbm = getEntArray("script_brushmodel","classname");
	for (i = 0 ; i < sbm.size; i++)
		sbm[i] hide();

	sm = getEntArray("script_model","classname");
	for (i = 0 ; i < sm.size; i++)
		sm[i] hide();

	
	
	
	

	level.mp_musicplay = "mus_sca_helicopter_lp";
}

precacheFX()
{
}

playFX()
{
}