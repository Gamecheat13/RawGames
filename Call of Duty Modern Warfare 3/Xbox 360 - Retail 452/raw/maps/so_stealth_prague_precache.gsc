main()
{
	vehicle_scripts\_bm21_troops::main( "vehicle_bm21_mobile_cover", undefined, "script_vehicle_bm21_mobile_cover_troops" ); 
	vehicle_scripts\_btr80::main( "vehicle_btr80", undefined, "script_vehicle_btr80" );
	vehicle_scripts\_btr80::main( "vehicle_btr80", "btr80_physics", "script_vehicle_btr80_physics" );
	vehicle_scripts\_mi17::main( "vehicle_mi17_woodland_fly_cheap", undefined, "script_vehicle_mi17_woodland_fly_cheap" );
	vehicle_scripts\_t90::main( "vehicle_t90_tank_woodland", undefined, "script_vehicle_t90_tank_woodland" );
	vehicle_scripts\_t90::main( "vehicle_t90_tank_woodland", "t90_trophy", "script_vehicle_t90_tank_woodland_trophy" );
}
