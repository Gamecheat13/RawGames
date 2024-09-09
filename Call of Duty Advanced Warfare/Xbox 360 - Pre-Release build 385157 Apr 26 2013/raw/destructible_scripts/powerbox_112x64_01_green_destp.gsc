#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	//---------------------------------------------------------------------
	// powerbox_112x64_01_green
	//---------------------------------------------------------------------
	destructible_create( "powerbox_112x64_01_green_destp", "tag_origin", 500, undefined, 32, "no_melee" );
			destructible_fx( "tag_fx", "vfx/destructible/powerbox_112x64_01_green", true );
			destructible_explode( 30000, 34000, 100, 100, 10, 20 );   // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage
		destructible_state( "tag_origin", "powerbox_112x64_01_green_dstry_destp", undefined, undefined, undefined, undefined, undefined, false );
		
		destructible_part( "tag_door", "powerbox_112x64_01_green_door_part_a_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
}