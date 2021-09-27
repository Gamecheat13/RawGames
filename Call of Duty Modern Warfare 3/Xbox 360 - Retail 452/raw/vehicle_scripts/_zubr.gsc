#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "zubr", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "russian_zubr_watercraft" );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	//build_aianims( ::setanims, ::set_vehicle_anims );
	//build_unload_groups( ::Unload_Groups );
	//build_treadfx();  //currently disabled because vehicle type "boat" isn't supported. http://bugzilla.infinityward.net/show_bug.cgi?id=85644

}

init_local()
{
}


/*QUAKED script_vehicle_zubr (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_zubr::main( "russian_zubr_watercraft", undefined, "script_vehicle_zubr" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_zubr
sound,vehicle_zodiac,vehicle_standard,all_sp


defaultmdl="russian_zubr_watercraft"
default:"vehicletype" "zubr"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_zubr_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_zubr::main( "russian_zubr_watercraft", "zubr_physics", "script_vehicle_zubr_physics" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_zubr
sound,vehicle_zodiac,vehicle_standard,all_sp


defaultmdl="russian_zubr_watercraft"
default:"vehicletype" "zubr_physics"
default:"script_team" "axis"
*/


