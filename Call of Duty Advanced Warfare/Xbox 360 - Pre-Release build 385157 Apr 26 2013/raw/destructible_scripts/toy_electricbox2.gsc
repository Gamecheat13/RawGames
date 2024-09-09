#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	//---------------------------------------------------------------------
	// electric box large toy
	//---------------------------------------------------------------------
	destructible_create( "toy_electricbox2", "tag_origin", 150, undefined, 32, "no_melee" );
		destructible_splash_damage_scaler( 15 );
			destructible_fx( "tag_fx", "fx/props/electricbox4_explode", undefined, undefined, undefined, 1 );
			destructible_sound( "exp_fusebox_sparks" );
			destructible_explode( 1000, 2000, 32, 32, 32, 48, undefined, 0 );   // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage, continue damage, originoffset
		destructible_state( undefined, "me_electricbox2_dest", undefined, undefined, "no_melee" );
		// door
		destructible_part( "tag_fx", "me_electricbox2_door", undefined, undefined, undefined, undefined, 1.0, 1.0 );

		// door upper
		destructible_part( "tag_door_upper", "me_electricbox2_door_upper", undefined, undefined, undefined, undefined, 1.0, 1.0 );

}
