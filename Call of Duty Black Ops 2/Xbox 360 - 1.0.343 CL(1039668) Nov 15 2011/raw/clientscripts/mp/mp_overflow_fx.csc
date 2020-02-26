#include clientscripts\mp\_utility;

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
	
}


main()
{
	clientscripts\mp\createfx\mp_overflow_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

