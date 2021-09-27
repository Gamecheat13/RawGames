#include maps\hamburg_code;

main()
{
	maps\createart\hamburg_art::main();
	maps\hamburg_precache::main();
	
	level_precache();
	
	maps\hamburg_landing_zone::pre_load();
	maps\hamburg_garage::pre_load();
	maps\hamburg_end::pre_load();
	
	maps\hamburg_a_starts::main();
	maps\hamburg_b_starts::main();
	maps\hamburg_starts::main();

	maps\_load::main();

	init_level();
	
	
	
	
}