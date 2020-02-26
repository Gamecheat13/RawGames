// Client side audio functionality

#include clientscripts\mp\_utility;
#include clientscripts\mp\_ambientpackage;

//GAMETYPE GENERAL AUDIO FUNCTIONS
zmbMusLooper()
{
	ent = spawn( 0, (0,0,0), "script_origin" );
	playsound( 0, "mus_zmb_gamemode_start", (0,0,0) );
	wait(10);
	ent playloopsound( "mus_zmb_gamemode_loop", .05 );
	ent thread waitfor_music_stop();
}
waitfor_music_stop()
{
	level waittill( "stpm" );
	self stoploopsound( .1 );
	playsound( 0, "mus_zmb_gamemode_end", (0,0,0) );
	wait(1);
	self delete();
}