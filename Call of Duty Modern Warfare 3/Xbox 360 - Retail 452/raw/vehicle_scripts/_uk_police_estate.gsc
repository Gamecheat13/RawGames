#include maps\_vehicle;
#include maps\_vehicle_aianim;

#using_animtree( "vehicles" );
main( model, type, classname )
{
    build_template( "uk_police_estate", model, type, classname );
    build_localinit( ::init_local );

    build_destructible( model, "vehicle_uk_police_estate" );
	
	build_deathfx( "explosions/large_vehicle_explosion", 	undefined, 				"car_explode", 						undefined, 			undefined, 		undefined, 		0 );      
    
    build_radiusdamage( ( 0, 0, 32 ), 300, 200, 100, false );
    build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
   
    build_deathquake( 1, 1.6, 500 );
    build_treadfx();
    build_life( 999, 500, 1500 );
    build_team( "axis" );
    
	anim_func = ::setanims;			
	build_aianims( anim_func, ::set_vehicle_anims );
}

init_local()
{
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	positions[ 0 ].vehicle_getoutanim = %london_police_car_exit_2_jog_b_doors;
	positions[ 0 ].vehicle_getoutsound = "policeestate_door_open";

	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	positions[ 0 ] = spawnstruct();
	positions[ 0 ].sittag = "tag_driver";
	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 0 ].idle = %london_police_drive_idle;
	positions[ 0 ].getout = %london_police_car_exit_2_jog_b;

	return positions;
}

/*QUAKED script_vehicle_uk_police_estate_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_uk_police_estate::main( "uk_police_estate_destructible", "uk_police_estate_physics", "script_vehicle_uk_police_estate_physics" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_uk_police_estate_destructible
sound,vehicle_uk_police_estate,vehicle_standard,all_sp


defaultmdl="uk_police_estate_destructible"
default:"vehicletype" "uk_police_estate_physics"
*/