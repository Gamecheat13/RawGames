#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.wave_table 	= "sp/so_survival/tier_3.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_3.csv";	// enables player load out override
	
	maps\mp\mp_lambeth_precache::main();
	maps\createart\mp_lambeth_art::main();
	maps\mp\mp_lambeth_fx::main();
	maps\createfx\mp_lambeth_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_lambeth" );

	// survival mode post load
	maps\_utility::set_vision_set( "mp_lambeth", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_lambeth" );
	
	// kick off survival mode
	maps\_so_survival::survival_init();	
}