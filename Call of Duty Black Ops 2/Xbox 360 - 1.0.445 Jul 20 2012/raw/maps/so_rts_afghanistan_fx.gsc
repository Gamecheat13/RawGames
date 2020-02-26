#include maps\_utility;

precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{
}

main()
{

	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();

	maps\afghanistan_fx::main();
}
