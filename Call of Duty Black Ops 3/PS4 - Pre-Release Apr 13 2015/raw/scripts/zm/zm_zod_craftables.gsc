    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                       	                                
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   
                                                                                                                                                                              	                           	                                        	                                                     	                                 

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_BOXER" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_DETECTIVE" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_FEMME" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_MAGICIAN" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PLACE_RELIC" );
#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_INITIATE" );
#precache( "triggerstring", "ZOMBIE_BUILD_PIECE_GRAB" );

#namespace zm_zod_craftables;




// Randomizes craftable locations before initializing them there.
//
function randomize_craftable_spawns()
{
}


	




function init_craftables()
{
	level.custom_craftable_validation = &zod_player_can_craft;
	
	register_clientfields();

	// add_zombie_craftable notes:
	//		hint string is for crafting prompt
	//		crafting 
	//		bought string is only for ONE_USE_AND_FLY or PERSISTENT types (shows after you picked up the item)

	zm_craftables::add_zombie_craftable( "idgun",				&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER",		&"ZM_ZOD_QUEST_RITUAL_INITIATE",		&onFullyCrafted_IDGun );
	zm_craftables::add_zombie_craftable( "ritual_boxer",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER",		&"ZM_ZOD_QUEST_RITUAL_INITIATE",		&onFullyCrafted_Ritual );
	zm_craftables::add_zombie_craftable( "ritual_detective",	&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE",	&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE",	&"ZM_ZOD_QUEST_RITUAL_INITIATE",		&onFullyCrafted_Ritual );
	zm_craftables::add_zombie_craftable( "ritual_femme",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME",		&"ZM_ZOD_QUEST_RITUAL_INITIATE",		&onFullyCrafted_Ritual );
	zm_craftables::add_zombie_craftable( "ritual_magician",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN",		&"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN",		&"ZM_ZOD_QUEST_RITUAL_INITIATE",		&onFullyCrafted_Ritual );
	zm_craftables::add_zombie_craftable( "ritual_pap",			&"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC",				&"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC",				&"ZM_ZOD_QUEST_RITUAL_INITIATE",		&onFullyCrafted_Ritual );

	zm_craftables::set_build_time( "idgun", 0 );
	zm_craftables::set_build_time( "ritual_boxer", 0 );
	zm_craftables::set_build_time( "ritual_detective", 0 );
	zm_craftables::set_build_time( "ritual_femme", 0 );
	zm_craftables::set_build_time( "ritual_magician", 0 );
	zm_craftables::set_build_time( "ritual_pap", 0 );
}


//////////////////////////////////////////////////////////////////////////////
//	Add craftables (crafting, quest, pickups) and what they are composed of here.
//	Use generate_zombie_craftable_piece for each part.  This should be a script struct 
//		in the map with targetname of: craftablename + "_" + modelname
//		So yeah, if the modelname changes, you'll need to change it here and in the map.
//	Add the models to the zm_tomb_craftables.csv
//
function include_craftables()
{
	level.craftable_piece_swap_allowed = false;
	shared_pieces = level.is_forever_solo_game;

	//level thread run_craftables_devgui();
	
	// Interdimensional Gun
	//-------------------
	craftable_name				= "idgun";
	idgun_part_heart			= zm_craftables::generate_zombie_craftable_piece( craftable_name, "part_heart",		32, 64, 0,	undefined,	&onPickup_IDGun_Piece, undefined, undefined, undefined, undefined,	undefined, "idgun" + "_" + "part_heart", 		true, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART",			2 );
	idgun_part_skeleton			= zm_craftables::generate_zombie_craftable_piece( craftable_name, "part_skeleton",	32, 64, 0,	undefined,	&onPickup_IDGun_Piece, undefined, undefined, undefined, undefined,	undefined, "idgun" + "_" + "part_skeleton",		true, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON",		2 );
	idgun_part_xenomatter		= zm_craftables::generate_zombie_craftable_piece( craftable_name, "part_xenomatter",	32, 64, 0,	undefined,	&onPickup_IDGun_Piece, undefined, undefined, undefined, undefined,	undefined, "idgun" + "_" + "part_xenomatter",	true, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER",	2 );

	idgun_part_heart.client_field_state				= undefined;
	idgun_part_skeleton.client_field_state			= undefined;
	idgun_part_xenomatter.client_field_state		= undefined;
	
	idgun = SpawnStruct();
	idgun.name = craftable_name;
	idgun zm_craftables::add_craftable_piece( idgun_part_heart );
	idgun zm_craftables::add_craftable_piece( idgun_part_skeleton );
	idgun zm_craftables::add_craftable_piece( idgun_part_xenomatter );
	idgun.triggerThink = &idgun_Craftable;

	zm_craftables::include_zombie_craftable( idgun );
	level flag::init( "part_heart" + "_found" );
	level flag::init( "part_skeleton" + "_found" );
	level flag::init( "part_xenomatter" + "_found" );
	
	// Ritual - Boxer
	craftable_name				= "ritual_boxer";
	ritual_boxer_memento		= zm_craftables::generate_zombie_craftable_piece( craftable_name, "memento_boxer",	32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_BOXER", 0 );
	if ( shared_pieces )
	{
		ritual_boxer_memento.is_shared				= true;
		ritual_boxer_memento.client_field_state		= undefined;
	}

	ritual_boxer = SpawnStruct();
	ritual_boxer.name = craftable_name;
	ritual_boxer zm_craftables::add_craftable_piece( ritual_boxer_memento );
	ritual_boxer.triggerThink = &ritual_boxer_Craftable;

	zm_craftables::include_zombie_craftable( ritual_boxer );
	level flag::init( "memento_boxer" + "_found" );

	// Ritual - Detective
	craftable_name				= "ritual_detective";
	ritual_detective_memento	= zm_craftables::generate_zombie_craftable_piece( craftable_name, "memento_detective",	32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_DETECTIVE", 0 );
	if ( shared_pieces )
	{
		ritual_detective_memento.is_shared				= true;
		ritual_detective_memento.client_field_state		= undefined;
	}

	ritual_detective = SpawnStruct();
	ritual_detective.name = craftable_name;
	ritual_detective zm_craftables::add_craftable_piece( ritual_detective_memento );
	ritual_detective.triggerThink = &ritual_detective_Craftable;

	zm_craftables::include_zombie_craftable( ritual_detective );
	level flag::init( "memento_detective" + "_found" );

	// Ritual - Femme
	craftable_name				= "ritual_femme";
	ritual_femme_memento		= zm_craftables::generate_zombie_craftable_piece( craftable_name, "memento_femme",	32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_FEMME", 0 );
	if ( shared_pieces )
	{
		ritual_femme_memento.is_shared				= true;
		ritual_femme_memento.client_field_state		= undefined;
	}

	ritual_femme = SpawnStruct();
	ritual_femme.name = craftable_name;
	ritual_femme zm_craftables::add_craftable_piece( ritual_femme_memento );
	ritual_femme.triggerThink = &ritual_femme_Craftable;

	zm_craftables::include_zombie_craftable( ritual_femme );
	level flag::init( "memento_femme" + "_found" );

	// Ritual - Magician
	craftable_name				= "ritual_magician";
	ritual_magician_memento		= zm_craftables::generate_zombie_craftable_piece( craftable_name, "memento_magician",	32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_MAGICIAN", 0 );
	if ( shared_pieces )
	{
		ritual_magician_memento.is_shared				= true;
		ritual_magician_memento.client_field_state		= undefined;
	}

	ritual_magician = SpawnStruct();
	ritual_magician.name = craftable_name;
	ritual_magician zm_craftables::add_craftable_piece( ritual_magician_memento );
	ritual_magician.triggerThink = &ritual_magician_Craftable;

	zm_craftables::include_zombie_craftable( ritual_magician );
	level flag::init( "memento_magician" + "_found" );
	
	// Ritual - Pack-a-Punch
	craftable_name				= "ritual_pap";
	relic_boxer					= zm_craftables::generate_zombie_craftable_piece( craftable_name, "relic_boxer",		32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 1,		undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1 );
	relic_detective				= zm_craftables::generate_zombie_craftable_piece( craftable_name, "relic_detective",	32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 2,	undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1 );
	relic_femme					= zm_craftables::generate_zombie_craftable_piece( craftable_name, "relic_femme",		32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 3,		undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1 );
	relic_magician				= zm_craftables::generate_zombie_craftable_piece( craftable_name, "relic_magician",	32, 64, 0,	undefined,	&onPickup_Ritual_Piece, &onDrop_Ritual_Piece, &onCrafted_Ritual_Piece, undefined, undefined,	undefined, 4,	undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1 );

	if ( shared_pieces )
	{
		// Make pieces shared so quest isn't too tedious
		relic_boxer.is_shared		= true;
		relic_detective.is_shared	= true;
		relic_femme.is_shared		= true;
		relic_magician.is_shared	= true;
	
		// Zero this out so we don't attempt to send client field data when you pick up the part
		relic_boxer.client_field_state		= undefined;
		relic_detective.client_field_state	= undefined;
		relic_femme.client_field_state		= undefined;
		relic_magician.client_field_state	= undefined;
	}
	
	ritual_pap = SpawnStruct();
	ritual_pap.name = craftable_name;
	ritual_pap zm_craftables::add_craftable_piece( relic_boxer );
	ritual_pap zm_craftables::add_craftable_piece( relic_detective );
	ritual_pap zm_craftables::add_craftable_piece( relic_femme );
	ritual_pap zm_craftables::add_craftable_piece( relic_magician );
	ritual_pap.triggerThink = &ritual_pap_Craftable;

	zm_craftables::include_zombie_craftable( ritual_pap );
	level flag::init( "relic_boxer"		+ "_found" );
	level flag::init( "relic_detective"	+ "_found" );
	level flag::init( "relic_femme"		+ "_found" );
	level flag::init( "relic_magician"	+ "_found" );
	
	//level thread craftable_add_glow_fx();
}

//
//	Register the fields used to communicate with UI
function register_clientfields()
{
	// Shared Items
	shared_bits = 1;	// either you have it (1) or you don't (0)
	
	// Interdimensional Gun
	RegisterClientField( "world", "idgun" + "_" + "part_heart",		1, shared_bits,					"int", undefined, false );
	RegisterClientField( "world", "idgun" + "_" + "part_skeleton",	1, shared_bits,					"int", undefined, false );
	RegisterClientField( "world", "idgun" + "_" + "part_xenomatter",	1, shared_bits,					"int", undefined, false );
	
	// Held-by state for each item slot
	foreach( character_name in level.zod_character_names )
	{
		RegisterClientField( "world", "holder_of_" + character_name,					1, 3,	"int", undefined, false );
	}

	//	Quest state for each item slot
	foreach( character_name in level.zod_character_names )
	{
		RegisterClientField( "world", "quest_state_" + character_name,				1, 3,	"int", undefined, false );
	}
}

function craftable_add_glow_fx()
{
	level flag::wait_till( "start_zombie_round_logic" );
	foreach( s_craftable in level.zombie_include_craftables )
	{
		foreach( s_piece in s_craftable.a_piecestubs )
		{
			s_piece craftable_waittill_spawned();
			
			//s_piece.piecespawn.model clientfield::set( "element_glow_fx", n_elem );
		}
	}
}

function craftable_waittill_spawned()
{
	while( !isdefined( self.piecespawn ) )
	{
		util::wait_network_frame();
	}
}


//*****************************************************************************
// Common
//*****************************************************************************

// self is a WorldPiece
function onDrop_Common( player )
{
	self.piece_owner = undefined;
}

// self is a WorldPiece
function onPickup_Common( player )
{
	player playsound( "zmb_craftable_pickup" );	
	self.piece_owner = player;
	
	//self thread piece_pickup_conversation( player );
}

// self is a WorldPiece
// _zm_craftables handles respawning the piece at its starting location on player disconnect
// this function handles our level-specific HUD changes, and the glow effect that should spawn on the piece
function onDisconnect_Common( player )
{
	// end if the piece was crafted or dropped (these cases handle themselves)
	level endon( "crafted_" + self.pieceName );
	level endon( "dropped_" + self.pieceName );
	
	player_num = (player GetEntityNumber()) + 1;
	
	player waittill( "disconnect" );
	
	in_game_map_quest_item_dropped( self.pieceName ); // Update in-game map as necessary
	level clientfield::set( "holder_of_" + get_character_name_from_value( self.pieceName ), 0 );  // this item slot is now held by no-one

	if( is_piece_a_memento( self.pieceName ) )
	{
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 0 );  // update the UI quest item slot, removing memento
	}
	else if( is_piece_a_relic( self.pieceName ) )
	{
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 3 );  // update the UI quest item slot, removing relic
	}
	
	// TODO: play any custom vfx on the dropped piece here
}



//*****************************************************************************
// RITUALS
//*****************************************************************************

// self is a uts_craftable
function onDrop_Ritual_Piece( player )
{
	// CallBack When Player Drops Craftable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> Common part callback onDrop()" );	#/

	level notify( "dropped_" + self.pieceName ); // used to kill disconnect watcher for piece
		
	self dropOnMover( player );
	self.piece_owner = undefined;
	
	if( is_piece_a_memento( self.pieceName ) )
	{
		level.mementos_picked_up--;
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 0 );  // update the UI quest item slot, removing memento
		PlayFXOnTag( level._effect[ "memento_glow" ], self.model, "tag_origin" ); // put a glow vfx on the dropped piece for greater visibility
	}
	else if( is_piece_a_relic( self.pieceName ) )
	{
		level.relics_picked_up--;
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 3 );  // update the UI quest item slot, removing memento
		PlayFXOnTag( level._effect[ "relic_glow" ], self.model, "tag_origin" ); // put a glow vfx on the dropped piece for greater visibility
	}
	
	in_game_map_quest_item_dropped( self.pieceName ); // Update in-game map as necessary

	// Also update which player is holding it to NONE
	if ( !level flag::get("solo_game") )
	{
		level clientfield::set( "holder_of_" + get_character_name_from_value( self.pieceName ), 0 );  // this item slot is now held by no-one
	}
	
	// TODO: play any custom vfx on the dropped piece here
}

// self is a WorldPiece
function onPickup_Ritual_Piece( player )
{
	// CallBack When Player Picks Up Craftable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> Common part callback onPickup()" );	#/
	
	if (!isDefined( level.mementos_picked_up ))
	{
		level.mementos_picked_up = 0;
		level.relics_picked_up = 0;
		level.sndRitualMementos = 1;
	}
	
	self pickupFromMover();
	self.piece_owner = player;
	
	if( is_piece_a_memento( self.pieceName ) )
	{
		level.mementos_picked_up++;
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 1 ); // update the UI quest item slot, adding memento
	}
	else if( is_piece_a_relic( self.pieceName ) )
	{
		level.relics_picked_up++;
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 4 ); // update the UI quest item slot, adding relic
	}

	in_game_map_quest_item_dropped( self.pieceName ); // Update in-game map as necessary
	
	// Also update which player is holding it
	if ( !level flag::get("solo_game") )
	{
		player_num = ( player GetEntityNumber() ) + 1;
		level clientfield::set( "holder_of_" + get_character_name_from_value( self.pieceName ), player_num );  // this item slot is now held by player_num
	}

	// SFX/VO
	self play_vo_if_newly_found();
	self play_vo_if_final_piece_of_a_type_is_found();
	if( level.sndRitualMementos == level.mementos_picked_up )
	{
		level thread zm_audio::sndMusicSystem_PlayState( "piece_" + level.sndRitualMementos );
		level.sndRitualMementos++;
	}
	player playsound( "zmb_craftable_pickup" );
	
	self thread onDisconnect_Common( player );
}

function onPickup_IDGun_Piece( player )
{
	level flag::set( self.pieceName + "_found" );
		
	level notify( "idgun_part_found" ); // used to kill blinking effect on part in world
}

function play_vo_if_newly_found( )
{
	if ( !level flag::get( self.pieceName + "_found" ) )
	{
		//vo_alias_call = self.pickup_alias; // something broke with how self.pickup_alias was being set, making this a switch to keep it working in the meantime
		switch( self.pieceName )
		{
			case "memento_boxer":
				vo_alias_call = "sidequest_oxygen";
				break;
			case "memento_detective":
				vo_alias_call = "sidequest_sheets";
				break;
			case "memento_femme":
				vo_alias_call = "sidequest_engine";
				break;
			case "memento_magician":
				vo_alias_call = "sidequest_valves";
				break;
			case "relic_boxer":
				break;
			case "relic_detective":
				break;
			case "relic_femme":
				break;
			case "relic_magician":
				break;
		}
		
		level flag::set( self.pieceName + "_found" );
		
		if ( IsDefined( vo_alias_call ) )
		{
			//level thread play_plane_piece_call_and_response_vo( player, vo_alias_call );
		}
	}
}

function play_vo_if_final_piece_of_a_type_is_found()
{
	// we just picked up the last piece, start a final piece reminder thread
	if( level.mementos_picked_up == 4 ) // only ever going to have four mementos or relics (one for each character)
	{
		//level thread roof_nag_vo();
	}
	// we just picked up the last piece, start a final piece reminder thread
	if( level.relics_picked_up == 4 ) // only ever going to have four mementos or relics (one for each character)
	{
		//level thread roof_nag_vo();
	}
}

// self is a uts_craftable
function onCrafted_Ritual_Piece( player )
{
	if( is_piece_a_memento( self.pieceName ) )
	{
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 2 );  // update the UI quest item slot, removing memento
	}
	else
	{
		level clientfield::set( "quest_state_" + get_character_name_from_value( self.pieceName ), 5 );  // update the UI quest item slot, removing memento
		// show the placed relic
		quest_ritual_relic_placed = GetEnt( "quest_ritual_relic_placed_" + get_character_name_from_value( self.pieceName ), "targetname" );
		quest_ritual_relic_placed Show();
	}
	
	// Also update which player is holding it to NONE
	if ( !level flag::get("solo_game") )
	{
		// Also clear the player's held item status
		level clientfield::set( "holder_of_" + get_character_name_from_value( self.pieceName ), 0 );  // this item slot is now held by no-one
	}
}
	
// self is a uts_craftable
function onFullyCrafted_Ritual( player )
{
	if( self.equipname != "ritual_pap" ) // character ritual fully crafted
	{
		str_character_name = get_character_name_from_value( self.equipname );
		onFullyCrafted_Ritual_internal( str_character_name );
		[[ level.a_o_defend_areas[ str_character_name ] ]]->start();
	}
	else // Pack-a-Punch Ritual fully crafted
	{
		level flag::set( "ritual_pap_ready" );
		level clientfield::set( "ritual_state_pap", 1 );
		[[ level.a_o_defend_areas[ "pap" ] ]]->start(); // start the defend area
	}

	return true;	// keep processing craftable as normal
}

function onFullyCrafted_Ritual_internal( name )
{
	level flag::set( "ritual_" + name + "_ready" );
	level clientfield::set( "ritual_state_" + name, 1 );
	level clientfield::set( "quest_state_" + name, 2 ); // update the UI quest item slot, removing memento
	in_game_map_ritual_crafted( name );
}

function onFullyCrafted_IDGun( player )
{
}

////////////////////////////////////////////
//	Craftable Trigger Think functions
////////////////////////////////////////////

function init_craftable_choke()
{
	level.craftables_spawned_this_frame = 0;
	while( true )
	{
		util::wait_network_frame();
		level.craftables_spawned_this_frame = 0;
	}
}

function craftable_wait_your_turn()
{
	const max_craftables_per_frame = 2;
	if ( !isdefined( level.craftables_spawned_this_frame ) )
	{
		level thread init_craftable_choke();
	}
	
	while ( level.craftables_spawned_this_frame >= max_craftables_per_frame )
	{
		util::wait_network_frame();
	}
	
	level.craftables_spawned_this_frame++;
}

function zod_player_can_craft( player )
{
	if ( ( isdefined( player.beastmode ) && player.beastmode ) )
	{
		return false;
	}
	
	return true;
}

function ritual_boxer_Craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think( "quest_ritual_usetrigger_boxer",		"ritual_boxer", 		"ritual_boxer",			"", 1, 0 );
}

function ritual_detective_Craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think( "quest_ritual_usetrigger_detective",	"ritual_detective",		"ritual_detective",		"", 1, 0 );
}

function ritual_femme_Craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think( "quest_ritual_usetrigger_femme",		"ritual_femme",			"ritual_femme",			"", 1, 0 );
}

function ritual_magician_Craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think( "quest_ritual_usetrigger_magician",		"ritual_magician",		"ritual_magician",		"", 1, 0 );
}

function ritual_pap_Craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think( "quest_ritual_usetrigger_pap",			"ritual_pap",			"ritual_pap",			"", 1, 0 );
}

function idgun_Craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think( "idgun_usetrigger",						"idgun",				"idgun",				"", 1, 0 );
}


////////////////////////////////////////////
//	Utility
////////////////////////////////////////////

function get_character_name_from_value( name )
{
	a_character_names = array( "boxer", "detective", "femme", "magician" );
	foreach( character_name in a_character_names )
	{
		if( IsSubStr( name, character_name ) )
		{
			return character_name;
		}
	}
}

function is_piece_a_memento( name )
{
	a_memento_names = array( "memento_boxer", "memento_detective", "memento_femme", "memento_magician" );
	if( IsInArray( a_memento_names, name ) )
	{
		return true;
	}
	return false;
}

function is_piece_a_relic( name )
{
	if(	( name == "relic_boxer" ) ||
	   	( name == "relic_detective" ) ||
	   	( name == "relic_femme" ) ||
	   	( name == "relic_magician" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function in_game_map_quest_item_picked_up( str_partname )
{
	// update in-game map here
}

function in_game_map_quest_item_dropped( str_partname )
{
	// update in-game map here
}

function in_game_map_ritual_crafted( str_partname )
{
	// update in-game map here
}

// TODO: get this old Gondola script working for the Train
function dropOnMover( player )
{
	/*
	if ( IsDefined( player ) && player maps\mp\zm_alcatraz_travel::Is_Player_On_Gondola() )
	{		
		str_location = undefined;
		
		if( IS_TRUE(level.e_gondola.is_moving) && IsDefined( level.e_gondola.destination ) )
		{
			str_location = level.e_gondola.destination;
		}
		else
		{
			str_location = level.e_gondola.location;
		}
		
		// Failsafe if somehow the location is undefined
		if( !IsDefined( str_location ) )
		{
			str_location = "roof";
		}
		
		a_s_part_teleport = getstructarray( "gondola_dropped_parts_" + str_location, "targetname" );
		foreach( struct in a_s_part_teleport )
		{
			if( !IS_TRUE( struct.occupied ) )
			{
				self.model.origin = struct.origin;
				self.model.angles = struct.angles;
				struct.occupied = 1;
				self.unitrigger.struct_teleport = struct;
				break;
			}
		}
	}
	*/
}

// TODO: get this working for the Train
function pickupFromMover()
{	
	/*
	if(isdefined(self.unitrigger))
	{
		if(isdefined(self.unitrigger.struct_teleport))
		{
			self.unitrigger.struct_teleport.occupied = 0;
			self.unitrigger.struct_teleport = undefined;	
		}
	}
	*/
}
