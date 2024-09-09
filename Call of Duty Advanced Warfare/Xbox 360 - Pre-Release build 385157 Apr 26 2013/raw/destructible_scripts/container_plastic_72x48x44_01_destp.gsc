#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	//---------------------------------------------------------------------
	// container_plastic_72x48x44_01
	//---------------------------------------------------------------------
	destructible_create( "container_plastic_72x48x44_01_destp", "tag_origin", 500, undefined, 32, "no_melee" );
			destructible_fx( "tag_origin", "vfx/destructible/container_plastic_72x48x44_01", true );
			destructible_explode( 1500, 3000, 100, 100, 10, 20, undefined, undefined, undefined, undefined, undefined, undefined, 2500, 4000 );   // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage, continueDamage, originOffset, earthQuakeScale, earthQuakeRadius, originOffset3d, delaytime, angularImpulse_min, angularImpulse_max
	destructible_state( "tag_origin", "container_plastic_72x48x44_01_dstry_destp", undefined, undefined, undefined, undefined, undefined, false );
			
		destructible_part( "tag_part_01", "container_plastic_72x48x44_01_part_01_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_part_02", "container_plastic_72x48x44_01_part_02_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_part_03", "container_plastic_72x48x44_01_part_03_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_part_04", "container_plastic_72x48x44_01_part_04_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_part_05", "container_plastic_72x48x44_01_part_05_destp", undefined, undefined, undefined, undefined, 1.0, 1.0 );

}