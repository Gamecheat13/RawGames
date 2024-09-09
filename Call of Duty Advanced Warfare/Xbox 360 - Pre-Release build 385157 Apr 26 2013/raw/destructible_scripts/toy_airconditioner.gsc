#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	//---------------------------------------------------------------------
	// Small Airconditioner hanging on wall
	//---------------------------------------------------------------------
	destructible_create( "toy_airconditioner", "tag_origin", 0, undefined, 32 );
			destructible_anim( %ex_airconditioner_fan, #animtree, "setanimknob", undefined, undefined, "ex_airconditioner_fan" );
			destructible_loopsound( "airconditioner_running_loop" );
		destructible_state( "tag_origin", "com_ex_airconditioner", 300 );
			destructible_fx( "tag_fx", "fx/explosions/airconditioner_ex_explode", undefined, undefined, undefined, 1 );
			destructible_sound( "airconditioner_burst" );
			destructible_explode( 1000, 2000, 32, 32, 32, 48, undefined, 0 );   // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage, continue damage, originoffset
		destructible_state( undefined, "com_ex_airconditioner_dam", undefined, undefined, "no_melee" );
		// door
		destructible_part( "tag_fx", "com_ex_airconditioner_fan", undefined, undefined, undefined, undefined, 1.0, 1.0 );
}
