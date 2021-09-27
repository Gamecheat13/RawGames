#include maps\_vehicle;
#include maps\_specialops;
#include common_scripts\utility;

main()
{
	level.wave_table 	= "sp/so_survival/tier_4.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_4.csv";	// enables player load out override
	
	// mp map precache and art
	maps\mp\mp_plaza2_precache::main();
	maps\createart\mp_plaza2_art::main();
	maps\mp\mp_plaza2_fx::main();
	maps\createfx\mp_plaza2_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_plaza2" );
	
	// survival mode post load
	maps\_utility::set_vision_set( "mp_plaza2", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_plaza2" );
	
	maps\_so_survival_code::break_glass();
	
	// kick off survival mode
	maps\_so_survival::survival_init();
}