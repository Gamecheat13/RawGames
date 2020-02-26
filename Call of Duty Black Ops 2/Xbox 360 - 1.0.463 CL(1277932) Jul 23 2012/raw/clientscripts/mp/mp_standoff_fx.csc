#include clientscripts\mp\_utility;

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
	
}

// fx animations
#using_animtree ( "fxanim_props" );
precache_fx_anims()
{
	level.scr_anim = [];
	level.scr_anim[ "fxanim_props" ] = [];
}

main()
{
	clientscripts\mp\createfx\mp_standoff_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_createfx_fx();
	precache_fx_anims();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

