#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.wave_table 	= "sp/so_survival/tier_2.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_2.csv";	// enables player load out override
	
	// mp map precache and art
	maps\mp\mp_carbon_precache::main();
	maps\createart\mp_carbon_art::main();
	maps\mp\mp_carbon_fx::main();
	maps\mp\mp_carbon_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_carbon" );	

	// survival mode post load
	maps\_utility::set_vision_set( "mp_carbon", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_carbon" );
	
	// kick off survival mode
	maps\_so_survival::survival_init();	
}