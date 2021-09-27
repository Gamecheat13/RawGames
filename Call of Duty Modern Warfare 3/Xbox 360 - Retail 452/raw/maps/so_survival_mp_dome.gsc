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
	remove_explosive_barrels( 0.8 );
	
	maps\mp\mp_dome_precache::main();
	maps\createart\mp_dome_art::main();
	maps\mp\mp_dome_fx::main();
	maps\createfx\mp_dome_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_dome" );
	

	// survival mode post load
	maps\_utility::set_vision_set( "mp_dome", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_dome" );
	
	// Break glass so AI guns don't clip through
	maps\_so_survival_code::break_glass();
	
	// kick off survival mode
	maps\_so_survival::survival_init();	
}

// removing explosive barrels for E3 ( rate is percentage of barrels to be removed )
remove_explosive_barrels( rate )
{
	barrels 				= getentarray( "explodable_barrel", "targetname" );
	barrel_delete_num 		= int( rate * barrels.size );
	barrels_to_be_deleted 	= [];
	
	// random barrel removal - temp
	barrels = array_randomize( barrels );
	
	foreach ( index, ent in barrels )
	{
		if ( index >= barrel_delete_num )
			break;
		
		barrels_to_be_deleted[ barrels_to_be_deleted.size ] = ent;
		barrel_col = getent( ent.target, "targetname" );
		barrel_col delete();
	}
	
	foreach ( ent in barrels_to_be_deleted )
		ent delete();
}
