#using scripts\codescripts\struct;

#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\music_shared;

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_sh_cairo_fx;
#using scripts\cp\cp_sh_cairo_sound;

#using scripts\cp\_safehouse;

function main()
{
	cp_sh_cairo_fx::main();
	cp_sh_cairo_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
	
	//Music States  (NOT USED FOR MILESTONE)
	music::declareMusicState ("INTRO");
	music::musicAliasloop ("mus_underscore",0, 0);
	
}


	
