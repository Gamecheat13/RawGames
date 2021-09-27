#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "vehicles" );

main( model, type, classname )
{
	build_template( "ugv", model, type, classname );
	build_localinit( ::init_local );
	build_turret( "50cal_turret_ugv", "tag_gun", "ugv_robot_gun", undefined, "manual", 0.5, 20, -14 );
	build_deathmodel( model, model );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	
	init_grenade_launcher();
}

init_local()
{
	waittillframeend;
	self.mgturret[0] attach( "ugv_robot_grenade_launcher", "launcherAttach" );	
}

#using_animtree( "script_model" );
init_grenade_launcher()
{
	level.scr_model[ "ugv_grenade_launcher" ]										= "ugv_robot_grenade_launcher";
	level.scr_animtree[ "ugv_grenade_launcher" ]									= #animtree;
}


/*QUAKED script_vehicle_ugv_robot (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_ugv::main( "vehicle_ugv_robot_viewmodel", undefined, "script_vehicle_ugv_robot" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_ugv

defaultmdl="vehicle_ugv_robot_viewmodel"
default:"vehicletype" "ugv"
default:"script_team" "allies"
*/
