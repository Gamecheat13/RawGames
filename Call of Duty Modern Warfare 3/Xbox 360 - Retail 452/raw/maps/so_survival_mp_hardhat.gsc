#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.wave_table 	= "sp/so_survival/tier_3.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_3.csv";	// enables player load out override
	
	// mp map precache and art
	maps\mp\mp_hardhat_precache::main();
	maps\createart\mp_hardhat_art::main();
	maps\mp\mp_hardhat_fx::main();
	maps\createfx\mp_hardhat_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_hardhat" );
	
	// survival mode post load
	maps\_utility::set_vision_set( "mp_hardhat", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_hardhat" );
	
	// kick off survival mode
	maps\_so_survival::survival_init();	
}