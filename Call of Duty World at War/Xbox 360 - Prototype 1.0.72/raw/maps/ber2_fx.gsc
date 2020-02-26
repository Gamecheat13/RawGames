//
// file: ber2_fx.gsc
// description: fx setup script for berlin2
// scripter: slayback
//

#include maps\_utility;
main()
{
	precache_util_fx();
}

// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] = loadfx( "impacts/flesh_hit" );
}
