#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	dest_onestate("berlin_hotel_lights_wall2","berlin_hotel_lights_wall2_destroyed","fx/misc/light_blowout_wall_runner");
}


dest_onestate(destructibleType,dest,fx,sound)
{
	destructible_create(destructibleType,"tag_origin",150,undefined,32);
		destructible_fx( "tag_fx", fx);
		destructible_state( "tag_origin", dest, undefined, undefined, "no_meele" );
		if (isdefined( sound))
			destructible_sound( sound );
}


