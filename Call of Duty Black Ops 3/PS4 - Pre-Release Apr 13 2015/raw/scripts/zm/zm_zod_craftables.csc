                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   
                                                                                                                                                                              	                           	                                        	                                                     	                                 

#using scripts\zm\zm_zod_quest;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;


function init_craftables()
{
	//level.craftable_piece_count = 4; // can't see where this does anything, although it is referenced in _zm_craftables, it doesn't seem to really be used; going to comment this out for now
	
	register_clientfields();

	zm_craftables::add_zombie_craftable( "idgun" );
	zm_craftables::add_zombie_craftable( "ritual_boxer" );
	zm_craftables::add_zombie_craftable( "ritual_detective" );
	zm_craftables::add_zombie_craftable( "ritual_femme" );
	zm_craftables::add_zombie_craftable( "ritual_magician" );
	zm_craftables::add_zombie_craftable( "ritual_pap" );

	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
}


function include_craftables()
{
	// Common
	//-------------------
	
	zm_craftables::include_zombie_craftable( "idgun" );
	zm_craftables::include_zombie_craftable( "ritual_boxer" );
	zm_craftables::include_zombie_craftable( "ritual_detective" );
	zm_craftables::include_zombie_craftable( "ritual_femme" );
	zm_craftables::include_zombie_craftable( "ritual_magician" );
	zm_craftables::include_zombie_craftable( "ritual_pap" );
}


//
//	Must Match zm_ZOD_craftables.gsc clientfields
function register_clientfields()
{
	// NOTES:
	// Shared Items and quest items will be stored in "world" fields because they are global events.
	// 8th parameter for RegisterClientField: Setting it will generate callbacks for 0 when the ent is new. Needed for hud clientfields ("world" fields).
	// Code needs to activate a callback so the UI will update, so we need to add a callback for each field we add

	// Shared Items
	shared_bits = 1;	// either you have it (1) or you don't (0)
	
	// Interdimensional Gun
	RegisterClientField( "world", "idgun" + "_" + "part_heart",			1, shared_bits, "int", undefined, false, true );
	RegisterClientField( "world", "idgun" + "_" + "part_skeleton",		1, shared_bits, "int", undefined, false, true );
	RegisterClientField( "world", "idgun" + "_" + "part_xenomatter",		1, shared_bits, "int", undefined, false, true );

	// Quest Items	
	foreach( character_name in level.zod_character_names )
	{
		// Player held item indicator (who's holding the item)
		RegisterClientField( "world", "holder_of_" + character_name,	1, 3, "int", undefined, false, true );
		SetupClientFieldCodeCallbacks( "world", 1, "holder_of_" + character_name );
	}

	// Quest state field (current status of the item)
	RegisterClientField( "world", "quest_state_" + "boxer",		1, 3, "int", &zm_zod_quest::quest_state_boxer,		false, true );
	RegisterClientField( "world", "quest_state_" + "detective",	1, 3, "int", &zm_zod_quest::quest_state_detective,	false, true );
	RegisterClientField( "world", "quest_state_" + "femme",		1, 3, "int", &zm_zod_quest::quest_state_femme,		false, true );
	RegisterClientField( "world", "quest_state_" + "magician",		1, 3, "int", &zm_zod_quest::quest_state_magician,	false, true );
	
	foreach( character_name in level.zod_character_names )
	{
		SetupClientFieldCodeCallbacks( "world", 1, "quest_state_" + character_name );
	}
}
