#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.wave_table 	= "sp/so_survival/tier_3.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_3.csv";	// enables player load out override
	
	// mp map precache and art
	maps\mp\mp_radar_precache::main();
	maps\createart\mp_radar_art::main();
	maps\mp\mp_radar_fx::main();
	maps\createfx\mp_radar_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_radar" );	

	// survival mode post load
	maps\_utility::set_vision_set( "mp_radar", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_radar" );
	
	// kick off survival mode
	maps\_so_survival::survival_init();	
}