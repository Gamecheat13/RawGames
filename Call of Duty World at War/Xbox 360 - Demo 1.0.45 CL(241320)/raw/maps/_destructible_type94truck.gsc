// Destructible initialization script
#include maps\_destructible;
#using_animtree( "vehicles" );

init()
{
	set_function_pointer( "explosion_anim", "dest_type94truck", ::get_explosion_animation );
	set_function_pointer( "flattire_anim", "dest_type94truck", ::get_flattire_animation );

	build_destructible_radiusdamage( "dest_type94truck", undefined, 260, 240, 40, true );
	build_destructible_deathquake( "dest_type94truck", 0.6, 1.0, 600 );

	set_pre_explosion( "dest_type94truck", "vehicle/vfire/fx_vfire_t94_truck_engine" );
}

get_explosion_animation( broken_notify )
{
	return %v_type94_truck_explode;
}

get_flattire_animation( broken_notify )
{
	if( broken_notify == "flat_tire_left_rear" )
	{
		return %v_type94_truck_flattire_lb2;
	}
	else if( broken_notify == "flat_tire_right_rear" )
	{
		return %v_type94_truck_flattire_rb2;
	}
	else if( broken_notify == "flat_tire_left_front" )
	{
		return %v_type94_truck_flattire_lf;		
	}
	else if( broken_notify == "flat_tire_right_front" )
	{
		return %v_type94_truck_flattire_rf;
	}
	else if( broken_notify == "flat_tire_right_rear_2" )
	{
		return %v_type94_truck_flattire_rb1;
	}
	else if( broken_notify == "flat_tire_left_rear_2" )
	{
		return %v_type94_truck_flattire_lb1;
	}
}

empty()
{
}