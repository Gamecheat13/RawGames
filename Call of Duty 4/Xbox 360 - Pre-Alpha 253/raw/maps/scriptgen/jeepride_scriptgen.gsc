//script generated script do not write your own script here it will go away if you do.
main()
{

	level.script_gen_dump = [];

	maps\_uaz::main( "vehicle_uaz_open" );
	maps\_truck::main( "vehicle_pickup_4door" );
	maps\createfx\jeepride_fx::main();
	maps\createart\jeepride_art::main();
	maps\_truck::main( "vehicle_opfor_truck" );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	maps\_luxurysedan::main( "vehicle_luxurysedan_test" );
	maps\_uaz::main( "vehicle_uaz_open_for_ride" );
	level.script_gen_dump[ "vehicle_uaz_open" ] = "vehicle_uaz_open";
	level.script_gen_dump[ "vehicle_pickup_4door" ] = "vehicle_pickup_4door";
	level.script_gen_dump[ "jeepride_fx" ] = "jeepride_fx";
	level.script_gen_dump[ "jeepride_art" ] = "jeepride_art";
	level.script_gen_dump[ "vehicle_opfor_truck" ] = "vehicle_opfor_truck";
	level.script_gen_dump[ "vehicle_blackhawk" ] = "vehicle_blackhawk";
	level.script_gen_dump[ "vehicle_luxurysedan_test" ] = "vehicle_luxurysedan_test";
	level.script_gen_dump[ "vehicle_uaz_open_for_ride" ] = "vehicle_uaz_open_for_ride";

	maps\_load::main( 1,0,1 );
}

