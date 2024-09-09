#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	//---------------------------------------------------------------------
	// container_plastic_beige_medium
	//---------------------------------------------------------------------
	destructible_create( "container_plastic_beige_med_01_destp", "tag_origin", 500, undefined, 32, "no_melee" );
			destructible_fx( "tag_origin", "vfx/destructible/container_plastic_beige_med_01", true );
			destructible_explode( 1200, 2750, 100, 100, 10, 20, undefined, undefined, undefined, undefined, undefined, undefined, 1000, 3000 );   // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage, continueDamage, originOffset, earthQuakeScale, earthQuakeRadius, originOffset3d, delaytime, angularImpulse_min, angularImpulse_max
		destructible_state( undefined, "container_plastic_beige_med_01_dstry_destp", undefined, undefined, undefined, undefined, undefined, false );
			
		destructible_part( "tag_lid1", "container_plastic_beige_med_01_part_lid1_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_lid2", "container_plastic_beige_med_01_part_lid2_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_lid3", "container_plastic_beige_med_01_part_lid3_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );

}