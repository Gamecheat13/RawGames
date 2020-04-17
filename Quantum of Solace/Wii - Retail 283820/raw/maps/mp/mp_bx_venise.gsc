#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	maps\mp\_load::main();
	
	game["allies"] = "mi6";
	game["axis"] = "terrorists";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	precacheShader( "compass_map_mp_bx_venise" );
	setminimap( "compass_map_mp_bx_venise", -856, 1152, 1712, -1368); 

	
	precacheFX();
	playFX();

	
	sbm = getEntArray("script_brushmodel","classname");
	for (i = 0 ; i < sbm.size; i++)
		sbm[i] hide();

	sm = getEntArray("script_model","classname");
	for (i = 0 ; i < sm.size; i++)
		sm[i] hide();

	
	
	
	

	level.mp_musicplay = "mus_get_house_lp";
}

precacheFX()
{
	
	level._effect["venice_birds_takeoff01"] 	= loadfx ("maps/venice/venice_birds_takeoff01");
}

playFX()
{
	
	fxid = playloopedfx ( level._effect["venice_birds_takeoff01"], 45, (436,-762,361) );
}