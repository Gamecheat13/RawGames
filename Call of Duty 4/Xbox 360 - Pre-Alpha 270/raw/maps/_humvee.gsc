#include maps\_vehicle;
#include maps\_vehicle_aianim;
main( model, type )
{
	build_template( "humvee", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_humvee_camo" );
	build_deathmodel( "vehicle_humvee_camo_50cal_doors" );
	build_deathmodel( "vehicle_humvee_camo_50cal_nodoors" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
	
}

set_vehicle_anims( positions )
{
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<4;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "body_animate_jnt";
	positions[ 1 ].sittag = "body_animate_jnt";
	positions[ 2 ].sittag = "tag_passenger";
	positions[ 3 ].sittag = "body_animate_jnt";

	positions[ 0 ].idle = %humvee_driver_climb_idle;
	positions[ 1 ].idle = %humvee_passenger_idle_L;
	positions[ 2 ].idle = %humvee_passenger_idle_R;
	positions[ 3 ].idle = %humvee_passenger_idle_R;

	positions[ 0 ].getout = %humvee_driver_climb_out;
	positions[ 1 ].getout = %humvee_passenger_out_L;
	positions[ 2 ].getout = %humvee_passenger_out_R;
	positions[ 3 ].getout = %humvee_passenger_out_R;

	positions[ 0 ].getin = %humvee_driver_climb_in;
	positions[ 1 ].getin = %humvee_passenger_in_L;
	positions[ 2 ].getin = %humvee_passenger_in_R;
	positions[ 3 ].getin = %humvee_passenger_in_R;

	return positions;
}

