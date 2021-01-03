#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                       	                                
                                                                                                                               
                                                                                                                                                                              	                           	                                        	                                                     	                                 

//
//	A rundown of how the data is structured:
//		UTS - unitrigger stub with craftable info
//		PSt = Piece Stub - (piece_header data)
//		PSp = Piece Spawn - (piece_instance data)
//		CSt = Craftable Stub - header info on craftables
//		CSp = Craftable Spawn...(craftable_instance)
//				These structs contain duplicated data and also refer to each other.  It's a mess.
//				Entries with the same indicator means they are the same data struct.
//
//CSt	level.zombie_include_craftables contains an array of the basic craftable data
//PSt		.a_pieceStubs
//			(hint strings)
//			.name
//			.onFullyCrafted - callback for when all pieces have been crafted
//			.triggerThink
//
//
//		level.zombie_craftableStubs - same as level.zombie_include_craftables... why!?!?
//
//
//  UTS	level.a_uts_craftables contains an array of unitrigger stubs, which is crafting (table) trigger info
//			(trigger info)
//	CSt		.craftableStub - general crafting info
//				(hint strings)
//	PSt			.a_pieceStubs - array of general piece data (copied to the specific piece in the world)
//					(piece info - offsets, callback functions)
//					.client_field_id - clientfield name to set when a shared item is picked up (undefined if not shared)
//					.client_field_state - state to set when an non-shared item is picked up (undefined if shared)
//					.craftablename - name of parent craftable
//	PSp				.pieceSpawn - piece in the world
//					.is_shared - is this a shared item (global inventory)
//					.need_all_pieces - must have all pieces before you can start building (undefined otherwise)
//				.name - of craftable
//				(buy and trigger think function pointers)
//	CSp		.craftableSpawn - actual in-world data
//				.craftable_name - name of craftable
//	PSp			.a_pieceSpawns - array of specific pieces in the world
//					(piece info - offsets, callback functions)
//					.craftablename - name of craftable
//					.crafted - defined to 1 after piece is placed
//					.in_shared_inventory - a shared item that was picked up.
//					.is_shared - is this a shared item (global inventory)
//	Pst				.pieceStub - points to struct of general piece data
//	UTS			.stub - (the parent stub in level.a_uts_craftables), also, .stub value in a unitrigger ent.
//			.crafted - was this object completely crafted?
//			.equipname - craftable name
//			.model - the script_model pointed to by the trigger (if any).
//			.targetname - name of the trigger
//

#precache( "string", "ZOMBIE_BUILDING" );
#precache( "string", "ZOMBIE_BUILD_PIECE_MISSING" );
#precache( "string", "ZOMBIE_BUILD_PIECE_GRAB" );

#precache( "fx", "zombie/fx_crafting_dust_zmb" );



#namespace zm_craftables;

function autoexec __init__sytem__() {     system::register("zm_craftables",&__init__,&__main__,undefined);    }

function __init__()
{
	callback::on_finalize_initialization( &set_craftable_clientfield );
}

function init()
{
	// Allow Players To Swap Carry Pieces
	//-----------------------------------
	if(!isdefined(level.craftable_piece_swap_allowed))level.craftable_piece_swap_allowed=true;

	zombie_craftables_callbacks = [];

	level.craftablePickUps = [];
	level.craftables_crafted = [];
	level.a_uts_craftables = [];

	if ( !isdefined( level.craftable_piece_count ) )
	{
		level.craftable_piece_count = 0;
	}

	level._effect["building_dust"]				= "zombie/fx_crafting_dust_zmb";

	if ( isdefined( level.init_craftables ) )
	{
		[[level.init_craftables]]();
	}

	// create the stub for the open craftable table - any open-type craftable can be made at these places
	open_table = SpawnStruct();
	open_table.name = "open_table";
	open_table.triggerThink = &openTableCraftable;
	open_table.custom_craftablestub_update_prompt = &open_craftablestub_update_prompt;
	include_zombie_craftable( open_table );
	add_zombie_craftable( "open_table", &"" );

	// DT 101314 Zombies have difficulty attacking players that are clipping into large craftable pieces
	if ( isdefined( level.use_swipe_protection ) )
	{
		callback::on_connect( &craftables_watch_swipes );
	}
}

function __main__()
{
	level thread think_craftables();
	/#level thread run_craftables_devgui();#/
}

function set_craftable_clientfield()
{
	set_piece_count( level.zombie_craftableStubs.size );
}

function anystub_update_prompt( player )
{
	//no craftable trigger can be used while in last stand or if you could be reviving someone
	if ( player laststand::player_is_in_laststand() || player zm_utility::in_revive_trigger() )
	{
		self.hint_string = "";
		return false;
	}

//	if( player isThrowingGrenade() )
//	{
//		self.hint_string = "";
//		return false;
//	}
	if ( isdefined( player.is_drinking ) && ( player.is_drinking > 0 ) )
	{
		self.hint_string = "";
		return false;
	}

	if ( isdefined( player.screecher_weapon ) )
	{
		self.hint_string = "";
		return false;
	}

	return true;
}

function anystub_get_unitrigger_origin()
{
	if ( isdefined( self.origin_parent ) )
	{
		return self.origin_parent.origin;
	}

	return self.origin;
}

function anystub_on_spawn_trigger( trigger )
{
	if ( isdefined( self.link_parent ) )
	{
		trigger EnableLinkTo();
		trigger LinkTo( self.link_parent );
		trigger SetMovingPlatformEnabled( true );
	}
}

function craftables_watch_swipes()
{
	self endon( "disconnect" );
	self notify( "craftables_watch_swipes" );
	self endon( "craftables_watch_swipes" );

	while ( 1 )
	{
		self waittill( "melee_swipe", zombie );

		if ( distancesquared( zombie.origin, self.origin ) > zombie.meleeattackdist * zombie.meleeattackdist )
		{
			continue; // just flailing at nothing
		}

		trigger = level._unitriggers.trigger_pool[self GetEntityNumber()];

		if ( isdefined( trigger ) && isdefined( trigger.stub.piece ) )
		{
			piece = trigger.stub.piece;

			if ( !isdefined( piece.damage ) )
			{
				piece.damage = 0;
			}

			piece.damage++;

			if ( piece.damage > 12 )
			{
				thread zm_equipment::disappear_fx( trigger.stub zm_unitrigger::unitrigger_origin() );
				piece piece_unspawn();
				self zm_stats::increment_client_stat( "cheat_total", false );

				if ( IsAlive( self ) )
				{
					self playlocalsound( level.zmb_laugh_alias );
				}
			}
		}
	}
}


function ExplosionDamage( damage, pos )
{
	/# println( "ZM CRAFTABLE Explode do "+damage+" damage to "+self.name+"\n"); #/
	self DoDamage( damage, pos );
}


//	Makes a craftable able to be crafted at any table.  Extra info is required, such as a localized name string
//		and model information for the craftable (we need to be able to spawn this at any open craftable table).
//	Params:
//		str_craftable - the name of the craftable to modify
//		str_model - model name of the fully crafted item
//		v_angle_offset - angles to add to the model when it's spawned (to adjust its position on the table)
//		v_origin_offset - position to add to the model when it's spawned (to adjust its position on the table)
function make_zombie_craftable_open( str_craftable, str_model, v_angle_offset, v_origin_offset )
{
	Assert( isdefined( level.zombie_craftableStubs[ str_craftable ] ), "Craftable " + str_craftable + " has not been added yet." );

	//PrecacheModel( str_model );

	s_craftable						= level.zombie_craftableStubs[ str_craftable ];
	s_craftable.is_open_table		= true;
	s_craftable.str_model			= str_model;
	s_craftable.v_angle_offset		= v_angle_offset;
	s_craftable.v_origin_offset		= v_origin_offset;
}



//
//	add general info about a craftable.
//		craftable_name - ID
//		str_to_craft - Hold X to craft Y hint string
//		str_crafting - Part added hint string (not neeeded if NEED_ALL_PIECES)
//		str_taken - Player obtained craftable from table hint string (PERSISTENT and ONE_USE_AND_FLY)
//		need_all_pieces - are all pieces required before you can craft the object?
//		onFullyCrafted - callback when the item is fully crafted.  Blocking call.
function add_zombie_craftable( craftable_name, str_to_craft, str_crafting, str_taken, onFullyCrafted, need_all_pieces )
{
	if ( !isdefined( level.zombie_include_craftables ) )
	{
		level.zombie_include_craftables = [];
	}

	if ( isdefined( level.zombie_include_craftables ) && !isdefined( level.zombie_include_craftables[ craftable_name ] ) )
	{
		return;
	}

	// This can be undefined if it uses the system, but not for an actual crafted item.
	if ( isdefined( str_to_craft ) )
	{
		//PrecacheString( str_to_craft );
	}

	// Not needed if it's a shared item that's used in another manner
	if ( isdefined( str_crafting ) )
	{
		//PrecacheString( str_crafting );
	}

	//if (isdefined(str_taken))
	//PrecacheString( str_taken );

	craftable_struct = level.zombie_include_craftables[ craftable_name ];

	if ( !isdefined( level.zombie_craftableStubs ) )
	{
		level.zombie_craftableStubs = [];
	}

	craftable_struct.str_to_craft		= str_to_craft;
	craftable_struct.str_crafting		= str_crafting;
	craftable_struct.str_taken			= str_taken;
	craftable_struct.onFullyCrafted		= onFullyCrafted;
	craftable_struct.need_all_pieces	= need_all_pieces;

	/#	PrintLn( "ZM >> Looking for craftable - " + craftable_struct.name );	#/

	level.zombie_craftableStubs[ craftable_struct.name ] = craftable_struct;
}

function set_build_time( craftable_name, build_time )
{
	if ( isdefined( level.zombie_craftableStubs[ craftable_name ] ) )
	{
		level.zombie_craftableStubs[ craftable_name ].useTime = build_time;
	}
}

function set_piece_count( n_count )
{
	bits = GetMinBitCountForNum( n_count );
	RegisterClientField( "toplayer", "craftable", 1, bits, "int" );
}

function add_zombie_craftable_vox_category( craftable_name, vox_id )
{
	craftable_struct = level.zombie_include_craftables[ craftable_name ];

	craftable_struct.vox_id = vox_id;
}

function include_zombie_craftable( craftableStub )
{
	if ( !isdefined( level.zombie_include_craftables ) )
	{
		level.zombie_include_craftables = [];
	}

	/#	PrintLn( "ZM >> Including craftable - " + craftableStub.name );		#/

	level.zombie_include_craftables[ craftableStub.name ] = craftableStub;

	/#
	level thread add_craftable_cheat( craftableStub );
#/
}


//
//	Sets up a piece of a craftable.
//
//	craftableName - alias name of the craftable
//	pieceName - alias name of the part, if not specified, it will use the modelName as the pieceName.
//	modelName - xmodel name
//	radius - approximate size (used for making the unitrigger)
//	height - approximate size (used for making the unitrigger)
//	drop_offset - ground offset if we need to drop the item
//	hud_icon - need to kill this UNUSED
//	onPickup - Callback when item picked up
//	onDrop - Callback when item dropped
//	onCrafted - Callback when item is crafted (used on the table)
//	use_spawn_num - set a specific spawner location for respawning
//	tag_name - model tag to show when crafted
//	can_reuse - set to true if the same part is used by more than one craftable (no need to create another data struct if so)
//	client_field_state -
//		NOTE: for non-shared items, this will represent a clientfield state number that is stored in the CLIENTFIELD_CRAFTABLE ClientField
//			For Shared items, this will represent the name of the Clientfield to update.  This is not the cleanest
//			implementation, but the two types of pieces are handled differently only in this regard.
//
//	is_shared - indicates if an item is shared inventory amongst all players
//	vox_id - string to play custom VO lines
//	hint_string - override the generic piece pick-up string
function generate_zombie_craftable_piece( craftablename, pieceName, radius, height, drop_offset, hud_icon, onPickup, onDrop, onCrafted, use_spawn_num, tag_name, can_reuse, client_field_value, is_shared = FALSE, vox_id, b_one_time_vo = false, hint_string, slot = 0 )
{
	pieceStub = spawnstruct();

	craftable_pieces = [];

	if ( !isdefined( pieceName ) )
	{
		AssertMsg( "You must provide an alias name for this piece" );
	}

	craftable_pieces_structs = struct::get_array( craftablename + "_" + pieceName, "targetname" );
	/#

	if ( craftable_pieces_structs.size < 1 )
	{
		println( "ERROR: Missing craftable piece <" + craftablename + "> <" + pieceName + ">\n" );
	}

#/

	foreach ( index, struct in craftable_pieces_structs )
	{
		craftable_pieces[ index ] = struct;
		craftable_pieces[ index ].hasSpawned = false;
	}

	pieceStub.spawns = craftable_pieces;

	pieceStub.craftableName = craftableName;
	pieceStub.pieceName = pieceName;
	pieceStub.modelName = craftable_pieces[0].model;
	pieceStub.hud_icon = hud_icon;
	pieceStub.radius = radius;
	pieceStub.height = height;
	pieceStub.tag_name = tag_name;
	pieceStub.can_reuse = can_reuse;
	pieceStub.drop_offset = drop_offset;
	pieceStub.max_instances = 256;

	pieceStub.onPickup = onPickup;
	pieceStub.onDrop = onDrop;
	pieceStub.onCrafted = onCrafted;
	pieceStub.use_spawn_num = use_spawn_num;
	pieceStub.is_shared = is_shared;
	pieceStub.vox_id = vox_id;
	pieceStub.hint_string = hint_string;
	pieceStub.inventory_slot = slot;

	if ( ( isdefined( b_one_time_vo ) && b_one_time_vo ) )
	{
		pieceStub.b_one_time_vo = b_one_time_vo;
	}

	if ( isdefined( client_field_value ) )
	{
		if ( ( isdefined( is_shared ) && is_shared ) )
		{
			Assert( IsString( client_field_value ), "Client field value for shared item (" + pieceName + ") should be a string (the name of the ClientField to use)" );
			pieceStub.client_field_id = client_field_value;
		}
		else
		{
			pieceStub.client_field_state = client_field_value;
		}
	}

	return pieceStub;
}

function manage_multiple_pieces( max_instances )
{
	self.max_instances = max_instances;
	self.managing_pieces = true;
	self.piece_allocated = [];
}


function combine_craftable_pieces( piece1, piece2, piece3 )
{
	spawns1 = piece1.spawns;
	spawns2 = piece2.spawns;

	spawns = ArrayCombine( spawns1, spawns2, true, false );

	if ( isdefined( piece3 ) )
	{
		spawns3 = piece3.spawns;
		spawns = ArrayCombine( spawns, spawns3, true, false );
		spawns = array::randomize( spawns );

		// add piece 4 here if needed

		piece3.spawns = spawns;
	}
	else
	{
		spawns = array::randomize( spawns );
	}

	piece1.spawns = spawns;
	piece2.spawns = spawns;
}

function add_craftable_piece( pieceStub, tag_name, can_reuse )
{
	if ( !isdefined( self.a_pieceStubs ) )
	{
		self.a_pieceStubs = [];
	}

	if ( isdefined( tag_name ) )
	{
		pieceStub.tag_name = tag_name;
	}

	if ( isdefined( can_reuse ) )
	{
		pieceStub.can_reuse = can_reuse;
	}

	self.a_pieceStubs[self.a_pieceStubs.size] = pieceStub;
	if(!isdefined(self.inventory_slot))self.inventory_slot=pieceStub.inventory_slot;
	/#
	assert( self.inventory_slot == pieceStub.inventory_slot, "All the pieces of a craftable must use the same inventory slot" );
#/
}


//
//	This would be better if it was in the _zm_laststand::PlayerLastStand func like the buildables.
//	However, we're trying not to modify any existing common scripts.
//	self is a player
function player_drop_piece_on_downed( slot )
{
	self endon( "craftable_piece_released" + slot );

//	self waittill("entering_last_stand");
	self waittill( "bled_out" );

	onPlayerLastStand();
}


//	Player last stand function.  Drops currently held piece.
//	self is a player
function onPlayerLastStand()
{
	if(!isdefined(self.current_craftable_pieces))self.current_craftable_pieces=[];

	foreach ( index, piece in self.current_craftable_pieces )
	{
		if ( isdefined( piece ) )
		{
			return_to_start_pos = false;

			if ( isdefined( level.safe_place_for_craftable_piece ) )
			{
				if ( ! self [[level.safe_place_for_craftable_piece]]( piece ) )
				{
					return_to_start_pos = true;
				}
			}

			if ( return_to_start_pos )
			{
				piece piece_spawn_at();
			}
			else
			{
				piece piece_spawn_at( self.origin + ( 5, 5, 0 ), self.angles );
			}

			if ( isdefined( piece.onDrop ) )
			{
				piece [[ piece.onDrop ]]( self );
			}

			self clientfield::set_to_player( "craftable", 0 );
		}

		self.current_craftable_pieces[index] = undefined;
		self notify( "craftable_piece_released" + index );
	}
}

// place the unitrigger a few inches above the origin to avoid LOS issues with the ground


function piecestub_get_unitrigger_origin()
{
	if ( isdefined( self.origin_parent ) )
	{
		return self.origin_parent.origin + (0,0,12);
	}

	return self.origin;
}

function generate_piece_unitrigger( classname, origin, angles, flags, radius, script_height, hint_string, moving )
{
	if ( !isdefined( radius ) )
	{
		radius = 64;
	}

	if ( !isdefined( script_height ) )
	{
		script_height = 64;
	}

	script_width = script_height;

	if ( !isdefined( script_width ) )
	{
		script_width = 64;
	}

	script_length = script_height;

	if ( !isdefined( script_length ) )
	{
		script_length = 64;
	}


	unitrigger_stub = spawnstruct();

	unitrigger_stub.origin = origin;
	//unitrigger_stub.angles = trig.angles;

	if ( isdefined( script_length ) )
	{
		unitrigger_stub.script_length = script_length;
	}
	else
	{
		unitrigger_stub.script_length = 13.5;
	}

	if ( isdefined( script_width ) )
	{
		unitrigger_stub.script_width = script_width;
	}
	else
	{
		unitrigger_stub.script_width = 27.5;
	}

	if ( isdefined( script_height ) )
	{
		unitrigger_stub.script_height = script_height;
	}
	else
	{
		unitrigger_stub.script_height = 24;
	}

	unitrigger_stub.radius = radius;

	//unitrigger_stub.target = trig.target;
	//unitrigger_stub.targetname = trig.targetname;

	unitrigger_stub.cursor_hint = "HINT_NOICON";

	if ( isdefined( hint_string ) )
	{
		unitrigger_stub.hint_string_override	= hint_string; // hint_string_override lets the update function know to use this instead
		unitrigger_stub.hint_string				= unitrigger_stub.hint_string_override;
	}
	else
	{
		unitrigger_stub.hint_string = &"ZOMBIE_BUILD_PIECE_GRAB";
	}

	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = false; //true;

	switch ( classname )
	{
		case "trigger_radius":
			unitrigger_stub.script_unitrigger_type = "unitrigger_radius";
			break;

		case "trigger_radius_use":
			unitrigger_stub.script_unitrigger_type  = "unitrigger_radius_use";
			break;

		case "trigger_box":
			unitrigger_stub.script_unitrigger_type  = "unitrigger_box";
			break;

		case "trigger_box_use":
			unitrigger_stub.script_unitrigger_type  = "unitrigger_box_use";
			break;
	}

	zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );
	unitrigger_stub.prompt_and_visibility_func = &piecetrigger_update_prompt;
	unitrigger_stub.originFunc = &piecestub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;

	if ( ( isdefined( moving ) && moving ) )
	{
		zm_unitrigger::register_unitrigger( unitrigger_stub, &piece_unitrigger_think );
	}
	else
	{
		zm_unitrigger::register_static_unitrigger( unitrigger_stub, &piece_unitrigger_think );
	}

	return unitrigger_stub;
}


// self is a unitrigger
function piecetrigger_update_prompt( player )
{
	if(!isdefined(player.current_craftable_pieces))player.current_craftable_pieces=[];
	can_use = self.stub piecestub_update_prompt( player );
	self setInvisibleToPlayer( player, !can_use );
	self SetHintString( self.stub.hint_string );
	return can_use;
}


//
//	Update the unitrigger prompt
//	Returns false if the trigger should not be usable; true if usable
//	self is a unitrigger stub
function piecestub_update_prompt( player, slot = self.piece.inventory_slot )
{
	if ( !self anystub_update_prompt( player ) )
	{
		return false;
	}

	// Only swap if you're holding a piece and the one you want to pick up isn't
	//	a shared inventory piece
	if ( isdefined( player.current_craftable_pieces[slot] ) && !( isdefined( self.piece.is_shared ) && self.piece.is_shared ) )
	{
		if ( !level.craftable_piece_swap_allowed )
		{
			self.hint_string = &"ZOMBIE_CRAFTABLE_NO_SWITCH";
		}
		else
		{
			spiece = self.piece;
			cpiece = player.current_craftable_pieces[slot];

			if ( spiece.pieceName == cpiece.pieceName && spiece.craftableName == cpiece.craftableName )
			{
				self.hint_string = "";
				return false;
			}

			if ( isdefined( self.hint_string_override ) )
			{
				self.hint_string = self.hint_string_override;
			}
			else
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_SWITCH";
			}
		}
	}
	else
	{
		if ( isdefined( self.hint_string_override ) )
		{
			self.hint_string = self.hint_string_override;
		}
		else
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_GRAB";
		}
	}

	return true;
}

function piece_unitrigger_think()
{
	self endon( "kill_trigger" );

	slot = self.stub.piece.inventory_slot;

	while ( 1 )
	{
		self waittill( "trigger", player );

		if ( player != self.parent_player )
		{
			continue;
		}

		if ( isdefined( player.screecher_weapon ) )
		{
			continue;
		}

		// Trigger is usable so the message disallowing swapping shows up, but we don't want them to actually
		// trigger a piece pickup
		if ( !level.craftable_piece_swap_allowed && isdefined( player.current_craftable_pieces[slot] ) && !( isdefined( self.stub.piece.is_shared ) && self.stub.piece.is_shared ) )
		{
			continue;
		}

		if ( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		status = player player_can_take_piece( self.stub.piece );

		if ( !status )
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );
		}
		else
		{
			player thread player_take_piece( self.stub.piece );
			// player_take_piece will end this thread
		}
	}
}

function player_can_take_piece( piece )
{
	if ( !isdefined( piece ) )
	{
		return 0;
	}

	// okay to take
	return 1;
}

/#
function DBLine( from, to )
{
	time = 20;

	while ( time > 0 )
	{
		Line( from, to, ( 0, 0, 1 ), false, 1 );
		time -= 0.05;
		{wait(.05);};
	}
}
#/


function player_throw_piece( piece, origin, dir, return_to_spawn, return_time, endangles )
{
	assert( isdefined( piece ) );

	if ( isdefined( piece ) )
	{
		/#
		thread DBLine( origin, origin + dir );
#/

		pass = 0;
		done = 0;
		altmodel = undefined;

		//origin = origin + 0.1 * dir;
		while ( pass < 2 && !done )
		{
			grenade = self MagicGrenadeType( "buildable_piece", origin, dir, 30000 );
			grenade thread watch_hit_players();
			grenade Ghost();

			if ( !isdefined( altmodel ) )
			{
				altmodel = spawn( "script_model", grenade.origin );
				altmodel SetModel( piece.modelName );
			}

			altmodel.origin = grenade.angles;
			altmodel.angles = grenade.angles;
			altmodel linkTo( grenade, "", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			grenade.altmodel = altmodel;

			grenade waittill( "stationary" );

			grenade_origin = grenade.origin;
			grenade_angles = grenade.angles;

			landed_on = grenade GetGroundEnt();

			grenade delete();

			if ( isdefined( landed_on ) && landed_on == level )
			{
				done = 1;
			}
			else
			{
				origin = grenade_origin;
				dir = ( -dir[0] / 10, -dir[1] / 10, -1 );
				pass++;
			}
		}

		if ( !isdefined( endangles ) )
		{
			endangles = grenade_angles;
		}

		piece piece_spawn_at( grenade_origin, endangles );

		if ( isdefined( altmodel ) )
		{
			altmodel delete();
		}

		if ( isdefined( piece.onDrop ) )
		{
			piece [[ piece.onDrop ]]( self );
		}

		if ( ( isdefined( return_to_spawn ) && return_to_spawn ) )
		{
			piece piece_wait_and_return( return_time );
		}
	}
}

function watch_hit_players()
{
	self endon( "death" );
	self endon( "stationary" );

	while ( isdefined( self ) )
	{
		self waittill( "grenade_bounce", pos, normal, ent );

		if ( IsPlayer( ent ) )
		{
			ent ExplosionDamage( 25, pos );
		}
	}
}



function piece_wait_and_return( return_time )
{
	self endon( "pickup" );
	wait 0.15;

	if ( isdefined( level.exploding_jetgun_fx ) )
	{
		PlayFxOnTag( level.exploding_jetgun_fx, self.model, "tag_origin" );
	}
	else
	{
		PlayFxOnTag( level._effect["powerup_on"], self.model, "tag_origin" );
	}

	wait return_time - 6;
	self piece_hide();
	wait 1;
	self piece_show();
	wait 1;
	self piece_hide();
	wait 1;
	self piece_show();
	wait 1;
	self piece_hide();
	wait 1;
	self piece_show();
	wait 1;
	self notify( "respawn" );
	self piece_unspawn();
	self piece_spawn_at();
}

function player_return_piece_to_original_spawn( slot = 0 )
{
	self notify( "craftable_piece_released" + slot );
	piece = self.current_craftable_pieces[slot];
	self.current_craftable_pieces[slot] = undefined;

	if ( isdefined( piece ) )
	{
		piece piece_spawn_at();

		self clientfield::set_to_player( "craftable", 0 );
	}
}


//
//	NOTE: "piece_released" was changed to "craftable_piece_released" so it is separate from the buildable
//	System.  Some buildable stuff still runs automatically, like calling _zm_buildables::OnPlayerLastStand
//	from _zm_laststand.  That function sends out "piece_released" which would kill functions we're trying
//	to run here and process ourselves.
function player_drop_piece_on_death( slot = 0 )
{
	self notify( "craftable_piece_released" + slot );
	self endon( "craftable_piece_released" + slot );

	// if player dies...
	self thread player_drop_piece_on_downed( slot );

	// if player disconnects...
	origin = self.origin;
	angles = self.angles;
	piece = self.current_craftable_pieces[slot];
	self waittill( "disconnect" );
	piece piece_spawn_at( origin, angles );

	if ( isdefined( self ) )
	{
		self clientfield::set_to_player( "craftable", 0 );
	}
}


function player_drop_piece( piece, slot )
{
	if ( !isdefined( piece ) )
	{
		piece = self.current_craftable_pieces[slot];
	}

	if ( isdefined( piece ) )
	{
		piece.damage = 0;
		piece piece_spawn_at( self.origin, self.angles );

		self clientfield::set_to_player( "craftable", 0 );

		if ( isdefined( piece.onDrop ) )
		{
			piece [[ piece.onDrop ]]( self );
		}
	}

	self.current_craftable_pieces[slot] = undefined;
	self notify( "craftable_piece_released" + slot );
}


// self == player
function player_take_piece( pieceSpawn )
{
	pieceStub = pieceSpawn.pieceStub;
	slot = pieceStub.inventory_slot;
	damage = pieceSpawn.damage;
	
	if(!isdefined(self.current_craftable_pieces))self.current_craftable_pieces=[];

	// Don't pick up shared pieces
	if ( !( isdefined( pieceStub.is_shared ) && pieceStub.is_shared ) && isdefined( self.current_craftable_pieces[slot] ) )
	{
		other_piece = self.current_craftable_pieces[slot];
		self player_drop_piece( self.current_craftable_piece, slot );
		other_piece.damage = damage;
		self zm_utility::do_player_general_vox( "general", "craft_swap" );
	}

	if ( isdefined( pieceStub.onPickup ) )
	{
		pieceSpawn [[ pieceStub.onPickup ]]( self );
	}

	// Update the UI.  The message we send depends on the type of item it is.
	//	Shared items generate a global update, so they set a world ClientField.
	//	Unshared items generate a player update so the UI shows what they picked up.
	if ( ( isdefined( pieceStub.is_shared ) && pieceStub.is_shared ) )
	{
		if ( isdefined( pieceStub.client_field_id ) )
		{
			level clientfield::set( pieceStub.client_field_id, 1 );
		}
	}
	else
	{
		if ( isdefined( pieceStub.client_field_state ) )
		{
			self clientfield::set_to_player( "craftable", pieceStub.client_field_state );
		}
	}

	pieceSpawn piece_unspawn();
	pieceSpawn notify( "pickup" );

	if ( ( isdefined( pieceStub.is_shared ) && pieceStub.is_shared ) )
	{
//		pieceStub.in_shared_inventory = true;
		pieceSpawn.in_shared_inventory = true;	//TODO move this to just pieceStub
	}
	else
	{
		slot = pieceSpawn.inventory_slot;
		self.current_craftable_pieces[slot] = pieceSpawn;
		self thread player_drop_piece_on_death( slot );
	}

	// Stat tracking
	self track_craftable_piece_pickedup( pieceSpawn );
}

function player_destroy_piece( piece, slot )
{
	if ( !isdefined( piece ) )
	{
		piece = self.current_craftable_pieces[slot];
	}

	if ( isdefined( piece ) )
	{
		self clientfield::set_to_player( "craftable", 0 );
	}

	self.current_craftable_pieces[slot] = undefined;
	self notify( "craftable_piece_released" + slot );
}


function claim_location( location )
{
	if ( !isdefined( level.craftable_claimed_locations ) )
	{
		level.craftable_claimed_locations = [];
	}

	if ( !isdefined( level.craftable_claimed_locations[location] ) )
	{
		level.craftable_claimed_locations[location] = true;
		return true;
	}

	return false;
}

// This is VERY expensive - use sparingly

function is_point_in_craft_trigger( point )
{
	//active_zone_names = level.active_zone_names;//zm_zonemgr::get_active_zone_names();

	candidate_list = [];

	foreach ( zone in level.zones )
	{
		if ( isdefined( zone.unitrigger_stubs ) )
		{
			candidate_list = ArrayCombine( candidate_list, zone.unitrigger_stubs, true, false );
		}
	}

	// we don't care about the dynamic unitriggers
	//candidate_list = ArrayCombine(candidate_list, level._unitriggers.dynamic_stubs, true, false);
	valid_range = 128;

	closest = zm_unitrigger::get_closest_unitriggers( point, candidate_list, valid_range );

	index = 0;

	while ( index < closest.size )
	{
		if ( ( isdefined( closest[index].registered ) && closest[index].registered ) && isdefined( closest[index].piece ) )
		{
			return true;
		}

		index++;
	}

	return false;
}



//
//
function piece_allocate_spawn( pieceStub )
{
	self.current_spawn = 0;
	self.managed_spawn = true;
	self.pieceStub = pieceStub;

	if ( self.spawns.size >= 1 && self.spawns.size > 1 )
	{
		any_good = false;
		any_okay = false;
		totalweight = 0;
		spawnweights = [];

		for ( i = 0; i < self.spawns.size; i++ )
		{
			if ( ( isdefined( pieceStub.piece_allocated[i] ) && pieceStub.piece_allocated[i] ) )
			{
				spawnweights[i] = 0;
			}
			else if ( is_point_in_craft_trigger( self.spawns[i].origin ) )
			{
				any_okay = true;
				spawnweights[i] = 0.01;
			}
			else
			{
				any_good = true;
				spawnweights[i] = 1.0;
			}

			totalweight += spawnweights[i];
		}

		/#
		assert( any_good || any_okay, "There is nowhere to spawn this piece" );
#/

		if ( any_good )
		{
			totalweight = float( int( totalweight ) );
		}

		r = RandomFloat( totalweight );

		for ( i = 0; i < self.spawns.size; i++ )
		{
			if ( !any_good || spawnweights[i] >= 1.0 )
			{
				r -= spawnweights[i];

				if ( r < 0 )
				{
					self.current_spawn = i;
					pieceStub.piece_allocated[self.current_spawn] = true;
					return;
				}
			}
		}

		// should never get here
		self.current_spawn = RandomInt( self.spawns.size );
		pieceStub.piece_allocated[self.current_spawn] = true;
	}
}


//
//	self is a pieceSpawn
function piece_deallocate_spawn()
{
	if ( isdefined( self.current_spawn ) )
	{
		self.pieceStub.piece_allocated[self.current_spawn] = false;
		self.current_spawn = undefined;
	}

	self.start_origin = undefined;
}



function piece_pick_random_spawn()
{
	self.current_spawn = 0;

	if ( self.spawns.size >= 1 && self.spawns.size > 1 )
	{
		self.current_spawn = RandomInt( self.spawns.size );

		while ( isdefined( self.spawns[self.current_spawn].claim_location ) &&
		        !claim_location( self.spawns[self.current_spawn].claim_location ) )
		{
			ArrayRemoveIndex( self.spawns, self.current_spawn );

			if ( self.spawns.size < 1 )
			{
				self.current_spawn = 0;
				/# println( "ERROR: All craftable spawn locations claimed" ); #/
				return;
			}

			self.current_spawn = RandomInt( self.spawns.size );
		}
	}
}

function piece_set_spawn( num )
{
	self.current_spawn = 0;

	if ( self.spawns.size >= 1 && self.spawns.size > 1 )
	{
		self.current_spawn = int( min( num, self.spawns.size - 1 ) );
	}
}


//
//	self is a pieceSpawn
function piece_spawn_in( pieceStub )
{
	if ( self.spawns.size < 1 )
	{
		return;
	}

	if ( ( isdefined( self.managed_spawn ) && self.managed_spawn ) )
	{
		if ( !isdefined( self.current_spawn ) )
		{
			self piece_allocate_spawn( self.pieceStub );
		}
	}

	if ( !isdefined( self.current_spawn ) )
	{
		self.current_spawn = 0;
	}

	spawndef = self.spawns[self.current_spawn];

	self.unitrigger = generate_piece_unitrigger( "trigger_radius_use", spawndef.origin + (0,0,12), spawndef.angles, 0, pieceStub.radius, pieceStub.height, pieceStub.hint_string, false );
	self.unitrigger.piece = self;

	self.radius = pieceStub.radius;
	self.height = pieceStub.height;
	self.craftableName = pieceStub.craftableName;
	self.pieceName = pieceStub.pieceName;
	self.modelName = pieceStub.modelName;
	self.hud_icon = pieceStub.hud_icon;
	self.tag_name = pieceStub.tag_name;
	self.drop_offset = pieceStub.drop_offset;
	self.start_origin = spawndef.origin;
	self.start_angles = spawndef.angles;
	self.client_field_state = pieceStub.client_field_state;
	self.is_shared = pieceStub.is_shared;
	self.inventory_slot = pieceStub.inventory_slot;

	self.model = Spawn( "script_model", self.start_origin );

	if ( isdefined( self.start_angles ) )
	{
		self.model.angles = self.start_angles;
	}

	self.model SetModel( pieceStub.modelName );

	if ( isdefined( pieceStub.onSpawn ) )
	{
		self [[ pieceStub.onSpawn ]]();
	}

	self.model GhostInDemo();
	self.model.hud_icon = pieceStub.hud_icon;
	self.pieceStub = pieceStub;

	self.unitrigger.origin_parent = self.model;

	// Cleanup the spawn structs? It would be nice
	//self.spawns = undefined;
}

// self is a piece
function piece_spawn_at( origin, angles, use_random_start )
{
	if ( self.spawns.size < 1 )
	{
		return;
	}

	if ( ( isdefined( self.managed_spawn ) && self.managed_spawn ) )
	{
		if ( !isdefined( self.current_spawn ) && !isdefined( origin ) )
		{
			self piece_allocate_spawn( self.pieceStub );
			spawndef = self.spawns[self.current_spawn];
			self.start_origin = spawndef.origin;
			self.start_angles = spawndef.angles;
		}
	}
	else if ( !isdefined( self.current_spawn ) )
	{
		self.current_spawn = 0;
	}

	unitrigger_offset = (0,0,12);

	if ( ( isdefined( use_random_start ) && use_random_start ) )
	{
		self piece_pick_random_spawn();
		spawndef = self.spawns[self.current_spawn];
		self.start_origin = spawndef.origin;
		self.start_angles = spawndef.angles;
		origin = spawndef.origin;
		angles = spawndef.angles;
	}
	else
	{
		if ( !isdefined( origin ) )
		{
			origin = self.start_origin;
		}
		else
		{
			origin = origin + ( 0, 0, self.drop_offset );
			unitrigger_offset -= ( 0, 0, self.drop_offset );
		}

		if ( !isdefined( angles ) )
		{
			angles = self.start_angles;
		}

		/#

		if ( !isdefined( level.drop_offset ) )
		{
			level.drop_offset = 0;
		}

		origin = origin + ( 0, 0, level.drop_offset );
		unitrigger_offset -= ( 0, 0, level.drop_offset );
#/
	}

	self.model = Spawn( "script_model", origin );

	if ( isdefined( angles ) )
	{
		self.model.angles = angles;
	}

	self.model SetModel( self.modelName );

	if ( isdefined( level.equipment_safe_to_drop ) )
	{
		if ( ! [[level.equipment_safe_to_drop]]( self.model ) )
		{
			origin = self.start_origin;
			angles = self.start_angles;
			self.model.origin = origin;
			self.model.angles = angles;
		}
	}

	if ( isdefined( self.onSpawn ) )
	{
		self [[ self.onSpawn ]]();
	}

	self.unitrigger = generate_piece_unitrigger( "trigger_radius_use", origin + unitrigger_offset, angles, 0, self.radius, self.height, self.piecestub.hint_string, ( isdefined( self.model.canMove ) && self.model.canMove ) );
	self.unitrigger.piece = self;

	self.model.hud_icon = self.hud_icon;

	self.unitrigger.origin_parent = self.model;
}


//
//	self is a pieceSpawn
function piece_unspawn()
{
	if ( ( isdefined( self.managed_spawn ) && self.managed_spawn ) )
	{
		self piece_deallocate_spawn();
	}

	if ( isdefined( self.model ) )
	{
		self.model delete();
	}

	self.model = undefined;

	if ( isdefined( self.unitrigger ) )
	{
		thread zm_unitrigger::unregister_unitrigger( self.unitrigger );
	}

	self.unitrigger = undefined;
}

function piece_hide()
{
	if ( isdefined( self.model ) )
	{
		self.model Ghost();
	}
}

function piece_show()
{
	if ( isdefined( self.model ) )
	{
		self.model Show();
	}
}


//
//	returns a pieceSpawn
function generate_piece( pieceStub )
{
	pieceSpawn = spawnstruct();
	pieceSpawn.spawns = pieceStub.spawns;

	if ( ( isdefined( pieceStub.managing_pieces ) && pieceStub.managing_pieces ) )
	{
		pieceSpawn piece_allocate_spawn( pieceStub );
	}
	else if ( isdefined( pieceStub.use_spawn_num ) )
	{
		pieceSpawn piece_set_spawn( pieceStub.use_spawn_num );
	}
	else
	{
		pieceSpawn piece_pick_random_spawn();
	}

	pieceSpawn piece_spawn_in( pieceStub );

	if ( pieceSpawn.spawns.size >= 1 )
	{
		pieceSpawn.hud_icon = pieceStub.hud_icon;
	}

	if ( isdefined( pieceStub.onPickup ) )
	{
		pieceSpawn.onPickup = pieceStub.onPickup;
	}
	else
	{
		pieceSpawn.onPickup = &onPickupUTS;
	}

	if ( isdefined( pieceStub.onDrop ) )
	{
		pieceSpawn.onDrop = pieceStub.onDrop;
	}
	else
	{
		pieceSpawn.onDrop = &onDropUTS;
	}

	if ( isdefined( pieceStub.onCrafted ) )
	{
		pieceSpawn.onCrafted = pieceStub.onCrafted;
	}

	return pieceSpawn;
}


//
//	self is a unitrigger stub
function craftable_piece_unitriggers( craftable_name, origin )
{

	Assert( isdefined( craftable_name ) );
	Assert( isdefined( level.zombie_craftableStubs[ craftable_name ] ), "Called craftable_think() without including the craftable - " + craftable_name );

	// Grab Craftable
	//---------------
	craftable = level.zombie_craftableStubs[ craftable_name ];

	if ( !isdefined( craftable.a_pieceStubs ) )
	{
		craftable.a_pieceStubs = [];
	}

	// Need To Wait For Some Scripts To Be Set Up Before Proceeding, Best Case Notify
	//-------------------------------------------------------------------------------
	level flag::wait_till( "start_zombie_round_logic" );

	craftableSpawn = spawnstruct();

	craftableSpawn.craftable_name = craftable_name;

	if ( !isdefined( craftableSpawn.a_pieceSpawns ) )
	{
		craftableSpawn.a_pieceSpawns = [];
	}

	// Create A Carry Objects (One Per Each Type Currently)
	//----------------------------------------------------
	craftablePickUps = [];

	foreach ( pieceStub in craftable.a_pieceStubs )
	{
		if(!isdefined(craftableSpawn.inventory_slot))craftableSpawn.inventory_slot=pieceStub.inventory_slot;
		/#
		assert( craftableSpawn.inventory_slot == pieceStub.inventory_slot, "All the pieces of a craftable must use the same inventory slot" );
#/

		if ( !isdefined( pieceStub.generated_instances ) )
		{
			pieceStub.generated_instances = 0;
		}

		// If this craftable is re-using parts from another craftable, use the previously generated piece
		if ( isdefined( pieceStub.pieceSpawn ) && ( isdefined( pieceStub.can_reuse ) && pieceStub.can_reuse ) )
		{
			piece = pieceStub.pieceSpawn;
		}
		else if ( pieceStub.generated_instances >= pieceStub.max_instances )
		{
			piece = pieceStub.pieceSpawn;
		}
		else
		{
			piece = generate_piece( pieceStub );
			pieceStub.pieceSpawn = piece;
			pieceStub.generated_instances++;
		}

		craftableSpawn.a_pieceSpawns[craftableSpawn.a_pieceSpawns.size] = piece;
	}

	craftableSpawn.stub = self;

	return craftableSpawn;
}

function hide_craftable_table_model( trigger_targetname )
{
	trig = GetEnt( trigger_targetname, "targetname" );

	if ( !isdefined( trig ) )
	{
		return;
	}

	if ( isdefined( trig.target ) )
	{
		model = getent( trig.target, "targetname" );

		if ( isdefined( model ) )
		{
			model Ghost();
			model NotSolid();
		}
	}
}

// self is a craftable stub (CSt)
function setup_unitrigger_craftable( trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	trig = GetEnt( trigger_targetname, "targetname" );

	if ( !isdefined( trig ) )
	{
		return;
	}

	return setup_unitrigger_craftable_internal( trig, equipname, weaponname, trigger_hintstring, delete_trigger, persistent );
}

// self is a craftable stub (CSt)
function setup_unitrigger_craftable_array( trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	triggers = GetEntArray( trigger_targetname, "targetname" );
	stubs = [];

	foreach ( trig in triggers )
	{
		stubs[stubs.size] = setup_unitrigger_craftable_internal( trig, equipname, weaponname, trigger_hintstring, delete_trigger, persistent );
	}

	return stubs;
}


// self is a craftable stub (CSt)
function setup_unitrigger_craftable_internal( trig, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	if ( !isdefined( trig ) )
	{
		return;
	}

	unitrigger_stub = spawnstruct();

	unitrigger_stub.craftableStub = level.zombie_include_craftables[ equipname ];

	angles = trig.script_angles;

	if ( !isdefined( angles ) )
	{
		angles = ( 0, 0, 0 );
	}

	unitrigger_stub.origin = trig.origin + ( anglestoright( angles ) * -6 );

	unitrigger_stub.angles = trig.angles;

	if ( isdefined( trig.script_angles ) )
	{
		unitrigger_stub.angles = trig.script_angles;
	}

	unitrigger_stub.equipname = equipname;
	unitrigger_stub.weaponname = GetWeapon( weaponname );
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.delete_trigger = delete_trigger;
	unitrigger_stub.crafted = false;
	unitrigger_stub.persistent = persistent;
	unitrigger_stub.useTime = int( 3 * 1000 );

	if ( isdefined( self.useTime ) )
	{
		unitrigger_stub.useTime = self.useTime;
	}
	else if ( isdefined( trig.useTime ) )
	{
		unitrigger_stub.useTime = trig.useTime;
	}

	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;

	if ( isdefined( trig.script_depth ) )
	{
		unitrigger_stub.script_length = trig.script_depth;
	}
	else
	{
		unitrigger_stub.script_length = 32; //24;
	}

	if ( isdefined( trig.script_width ) )
	{
		unitrigger_stub.script_width = trig.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 100;
	}

	if ( isdefined( trig.script_height ) )
	{
		unitrigger_stub.script_height = trig.script_height;
	}
	else
	{
		unitrigger_stub.script_height = 64;
	}

	unitrigger_stub.target = trig.target;
	unitrigger_stub.targetname = trig.targetname;

	unitrigger_stub.script_noteworthy = trig.script_noteworthy;
	unitrigger_stub.script_parameters = trig.script_parameters;

	unitrigger_stub.cursor_hint = "HINT_NOICON";

	if ( isdefined( level.zombie_craftableStubs[ equipname ].str_to_craft ) )
	{
		unitrigger_stub.hint_string = level.zombie_craftableStubs[ equipname ].str_to_craft;
	}

	unitrigger_stub.script_unitrigger_type  = "unitrigger_box_use";
	unitrigger_stub.require_look_at = true;

	zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );

	if ( isdefined( unitrigger_stub.craftableStub.custom_craftablestub_update_prompt ) )
	{
		unitrigger_stub.custom_craftablestub_update_prompt = unitrigger_stub.craftableStub.custom_craftablestub_update_prompt;
	}

	unitrigger_stub.prompt_and_visibility_func = &craftabletrigger_update_prompt;

	zm_unitrigger::register_static_unitrigger( unitrigger_stub, &craftable_place_think );

	unitrigger_stub.piece_trigger = trig;
	trig.trigger_stub = unitrigger_stub;

	if ( isdefined( trig.zombie_weapon_upgrade ) )
	{
		unitrigger_stub.zombie_weapon_upgrade = GetWeapon( trig.zombie_weapon_upgrade );
	}

	if ( isdefined( unitrigger_stub.target ) )
	{
		unitrigger_stub.model = getent( unitrigger_stub.target, "targetname" );

		if ( isdefined( unitrigger_stub.model ) )
		{
			if ( isdefined( unitrigger_stub.zombie_weapon_upgrade ) )
			{
				unitrigger_stub.model useweaponhidetags( unitrigger_stub.zombie_weapon_upgrade );
			}

			unitrigger_stub.model Ghost();
			unitrigger_stub.model NotSolid();
		}
	}

	// working vars for open craftable tables
	if ( unitrigger_stub.equipname == "open_table" )
	{
		unitrigger_stub.a_uts_open_craftables_available	= [];
		unitrigger_stub.n_open_craftable_choice			= -1;
		unitrigger_stub.b_open_craftable_checking_input	= false;
	}

	// create craftable pieces
	unitrigger_stub.craftableSpawn = unitrigger_stub craftable_piece_unitriggers( equipname, unitrigger_stub.origin );

	if ( delete_trigger )
	{
		trig delete();
	}

	level.a_uts_craftables[level.a_uts_craftables.size] = unitrigger_stub;
	return unitrigger_stub;
}


//
//	Setup the pieces only.  No craftable trigger involved.  ie, if this is just shared stuff you pick up
// self is craftable data (CD)
function setup_craftable_pieces()
{
	unitrigger_stub = spawnstruct();

	unitrigger_stub.craftableStub = level.zombie_include_craftables[ self.name ];

	unitrigger_stub.equipname = self.name;
//	unitrigger_stub.weaponname = self.name;

	// create craftable pieces
	unitrigger_stub.craftableSpawn = unitrigger_stub craftable_piece_unitriggers( self.name, unitrigger_stub.origin );

	level.a_uts_craftables[level.a_uts_craftables.size] = unitrigger_stub;
	return unitrigger_stub;
}


//
//	self is a craftableSpawn
function craftable_has_piece( piece )
{
	for ( i = 0; i < self.a_pieceSpawns.size; i++ )
		if ( self.a_pieceSpawns[i].pieceName == piece.pieceName && self.a_pieceSpawns[i].craftablename == piece.craftablename )
		{
			return true;
		}

	return false;
}


//	If we're crafting at an open table, we'll need to set the values for the
//	actual craftable we're trying to craft, which would not be the "open_table".
//	The open_craftableSpawn will be set via the trigger update
//		returns a uts_craftable
//		self is a uts_craftableSpawn
function get_actual_uts_craftable()
{
	if ( self.craftable_name == "open_table" &&
	        self.n_open_craftable_choice != -1 )
	{
		return self.stub.a_uts_open_craftables_available[ self.n_open_craftable_choice ];
	}
	else
	{
		// Normal craftable, proceed as normal
		return self.stub;
	}
}


//	If we're crafting at an open table, we'll need to set the values for the
//	actual craftable we're trying to craft, which would not be the "open_table".
//	The open_craftableSpawn will be set via the trigger update
//		returns a uts_craftableSpawn
//		self is a uts_craftableSpawn
function get_actual_craftableSpawn()
{
	if ( self.craftable_name == "open_table" &&
	        self.stub.n_open_craftable_choice != -1 &&
	        isdefined( self.stub.a_uts_open_craftables_available[ self.stub.n_open_craftable_choice ].craftableSpawn ) )
	{
		return self.stub.a_uts_open_craftables_available[ self.stub.n_open_craftable_choice ].craftableSpawn;
	}
	else
	{
		// Normal craftable, proceed as normal
		return self;
	}
}


//
//	Returns true if a shared item has been obtained but not used.
//	self is a craftableSpawn
function craftable_can_use_shared_piece()
{
	//	We've already determined that we can use something at this open table
	uts_craftable = self.stub;

	if ( isdefined( uts_craftable.n_open_craftable_choice ) &&
	        uts_craftable.n_open_craftable_choice != -1 &&
	        isdefined( uts_craftable.a_uts_open_craftables_available[ uts_craftable.n_open_craftable_choice ] ) )
	{
		return true;
	}

	// Check if we need all pieces (assuming all are shared)
	if ( ( isdefined( uts_craftable.craftableStub.need_all_pieces ) && uts_craftable.craftableStub.need_all_pieces ) )
	{
		//	If all shared pieces are in the inventory, then we can build it.
		foreach ( piece in self.a_pieceSpawns )
		{
			if ( !( isdefined( piece.in_shared_inventory ) && piece.in_shared_inventory ) )
			{
				return false;
			}
		}

		return true;
	}
	// Otherwise one shared piece is enough
	else
	{
		foreach ( piece in self.a_pieceSpawns )
		{
			if ( !( isdefined( piece.crafted ) && piece.crafted ) && ( isdefined( piece.in_shared_inventory ) && piece.in_shared_inventory ) )
			{
				return true;
			}
		}
	}

	return false;
}


// Mark pieces as having been applied to the table, ie "crafted"
//	self is a craftableSpawn
function craftable_set_piece_crafted( pieceSpawn_check, player )
{
	craftableSpawn_check = get_actual_craftableSpawn();

	foreach ( pieceSpawn in craftableSpawn_check.a_pieceSpawns )
	{
		if ( isdefined( pieceSpawn_check ) )
		{
			if ( pieceSpawn.pieceName == pieceSpawn_check.pieceName &&
			        pieceSpawn.craftablename == pieceSpawn_check.craftablename )
			{
				pieceSpawn.crafted = true;

				// Run onCrafted func
				if ( isdefined( pieceSpawn.onCrafted ) )
				{
					pieceSpawn thread [[pieceSpawn.onCrafted]]( player );
				}

				continue;
			}
		}

		// Check to see if it's a shared piece, and if so, mark it as crafted
		if ( ( isdefined( pieceSpawn.is_shared ) && pieceSpawn.is_shared ) && ( isdefined( pieceSpawn.in_shared_inventory ) && pieceSpawn.in_shared_inventory ) )
		{
			pieceSpawn.crafted = true;

			// Run onCrafted func
			if ( isdefined( pieceSpawn.onCrafted ) )
			{
				pieceSpawn thread [[pieceSpawn.onCrafted]]( player );
			}

			// Remove from inventory so we don't run onCrafted again.
			pieceSpawn.in_shared_inventory = false;
		}
	}
}

// Mark pieces as currently being applied to the table, ie "crafting"
//	self is a craftableSpawn
function craftable_set_piece_crafting( pieceSpawn_check )
{
	craftableSpawn_check = get_actual_craftableSpawn();

	foreach ( pieceSpawn in craftableSpawn_check.a_pieceSpawns )
	{
		if ( isdefined( pieceSpawn_check ) )
		{
			if ( pieceSpawn.pieceName == pieceSpawn_check.pieceName &&
			        pieceSpawn.craftablename == pieceSpawn_check.craftablename )
			{
				pieceSpawn.crafting = true;
			}
		}

		// Check to see if it's a shared piece, and if so, mark it as crafted
		if ( ( isdefined( pieceSpawn.is_shared ) && pieceSpawn.is_shared ) && ( isdefined( pieceSpawn.in_shared_inventory ) && pieceSpawn.in_shared_inventory ) )
		{
			pieceSpawn.crafting = true;
		}
	}
}


// Mark pieces as not in process of "crafting"
//	self is a craftableSpawn
function craftable_clear_piece_crafting( pieceSpawn_check )
{
	if ( isdefined( pieceSpawn_check ) )
	{
		pieceSpawn_check.crafting = false;
	}

	craftableSpawn_check = get_actual_craftableSpawn();

	foreach ( pieceSpawn in craftableSpawn_check.a_pieceSpawns )
	{
		// Check for shared pieces
		if ( ( isdefined( pieceSpawn.is_shared ) && pieceSpawn.is_shared ) && ( isdefined( pieceSpawn.in_shared_inventory ) && pieceSpawn.in_shared_inventory ) )
		{
			pieceSpawn.crafting = false;
		}
	}
}

function craftable_is_piece_crafted( piece )
{
	for ( i = 0; i < self.a_pieceSpawns.size; i++ )
	{
		if ( self.a_pieceSpawns[i].pieceName == piece.pieceName && self.a_pieceSpawns[i].craftablename == piece.craftablename )
		{
			return ( isdefined( self.a_pieceSpawns[i].crafted ) && self.a_pieceSpawns[i].crafted );
		}
	}

	return false;
}

// Is a piece in the process of "crafting"?
//	self is a craftableSpawn
function craftable_is_piece_crafting( pieceSpawn_check )
{
	craftableSpawn_check = get_actual_craftableSpawn();

	foreach ( pieceSpawn in craftableSpawn_check.a_pieceSpawns )
	{
		if ( isdefined( pieceSpawn_check ) )
		{
			if ( pieceSpawn.pieceName == pieceSpawn_check.pieceName &&
			        pieceSpawn.craftablename == pieceSpawn_check.craftablename )
			{
				return pieceSpawn.crafting;
			}
		}

		// Check for shared pieces
		if ( ( isdefined( pieceSpawn.is_shared ) && pieceSpawn.is_shared ) &&
		        ( isdefined( pieceSpawn.in_shared_inventory ) && pieceSpawn.in_shared_inventory ) &&
		        ( isdefined( pieceSpawn.crafting ) && pieceSpawn.crafting ) )
		{
			return true;
		}
	}

	return false;
}

function craftable_is_piece_crafted_or_crafting( piece )
{
	for ( i = 0; i < self.a_pieceSpawns.size; i++ )
		if ( self.a_pieceSpawns[i].pieceName == piece.pieceName && self.a_pieceSpawns[i].craftablename == piece.craftablename )
		{
			return ( isdefined( self.a_pieceSpawns[i].crafted ) && self.a_pieceSpawns[i].crafted ) || ( isdefined( self.a_pieceSpawns[i].crafting ) && self.a_pieceSpawns[i].crafting );
		}

	return false;
}

function craftable_all_crafted()
{
	if ( ( isdefined( self.stub.craftableStub.need_all_pieces ) && self.stub.craftableStub.need_all_pieces ) )
	{
		//	If all shared pieces are in the inventory, then we can build it.
		foreach ( piece in self.a_pieceSpawns )
		{
			if ( !( isdefined( piece.in_shared_inventory ) && piece.in_shared_inventory ) )
			{
				return false;
			}
		}

		return true;
	}

	for ( i = 0; i < self.a_pieceSpawns.size; i++ )
		if ( !( isdefined( self.a_pieceSpawns[i].crafted ) && self.a_pieceSpawns[i].crafted ) )
		{
			return false;
		}

	return true;
}

function waittill_crafted( craftable_name )
{
	level waittill( craftable_name + "_crafted", player );
	return player;
}


function player_can_craft( craftableSpawn, continuing, slot )
{
	if ( !isdefined( craftableSpawn ) )
	{
		return 0;
	}

	if ( !isdefined( slot ) )
	{
		slot = craftableSpawn.inventory_slot;
	}

	if ( !craftableSpawn craftable_can_use_shared_piece() )
	{
		if ( !isdefined( self.current_craftable_pieces[slot] ) )
		{
			return 0;
		}

		if ( !craftableSpawn craftable_has_piece( self.current_craftable_pieces[slot] ) )
		{
			return 0;
		}

		if ( ( isdefined( continuing ) && continuing ) )
		{
			if ( craftableSpawn craftable_is_piece_crafted( self.current_craftable_pieces[slot] ) )
			{
				return 0;
			}
		}
		else
		{
			if ( craftableSpawn craftable_is_piece_crafted_or_crafting( self.current_craftable_pieces[slot] ) )
			{
				return 0;
			}
		}
	}

	// NOTE: custom_craftablestub_update_prompt is called with the following parameters:
	//	( player, b_set_hint_string_now, trigger )
	if ( isdefined( craftableSpawn.stub ) &&
	        isdefined( craftableSpawn.stub.custom_craftablestub_update_prompt ) &&
	        isdefined( craftableSpawn.stub.playertrigger[0] ) &&
	        isdefined( craftableSpawn.stub.playertrigger[0].stub ) &&
	        !craftableSpawn.stub.playertrigger[ 0 ].stub [[ craftableSpawn.stub.custom_craftablestub_update_prompt ]]( self, true, craftableSpawn.stub.playertrigger[ self GetEntityNumber() ] ) )
	{
		return 0;
	}

	// okay to craft
	return 1;
}


//
//	This transfers the current table's trigger data to the craftable
//	we're crafting open craftable.
//	self is a craftableSpawn
function craftable_transfer_data()
{
	uts_craftable = self.stub;

	if ( uts_craftable.n_open_craftable_choice == -1 ||
	        !isdefined( uts_craftable.a_uts_open_craftables_available[ uts_craftable.n_open_craftable_choice ] ) )
	{
		return;
	}

	// source craftable (the thing we're crafting)
	uts_source = uts_craftable.a_uts_open_craftables_available[ uts_craftable.n_open_craftable_choice ];

	//  Check to see if the item crafted was at an open craft table
	uts_target			= uts_craftable;

	uts_target.craftableStub					=	uts_source.craftableStub;
	uts_target.craftableSpawn					=	uts_source.craftableSpawn;
	uts_target.crafted							=	uts_source.crafted;
	uts_target.cursor_hint						=	uts_source.cursor_hint;
	uts_target.custom_craftable_update_prompt	=	uts_source.custom_craftable_update_prompt;
	uts_target.equipname						=	uts_source.equipname;
	uts_target.hint_string						=	uts_source.hint_string;
	uts_target.persistent						=	uts_source.persistent;
	uts_target.prompt_and_visibility_func		=	uts_source.prompt_and_visibility_func;
	uts_target.trigger_func						=	uts_source.trigger_func;
	uts_target.trigger_hintstring				=	uts_source.trigger_hintstring;
	uts_target.weaponname						=	uts_source.weaponname;

	// Make sure to point the stub back to the correct uts_craftable
	uts_target.craftableSpawn.stub				=	uts_target;

	// unregister the old trigger loc
	thread zm_unitrigger::unregister_unitrigger( uts_source );
	uts_source craftablestub_remove();

	return uts_target;
}


//	A player has just crafted a piece.
//	self is a player
function player_craft( craftableSpawn, slot = craftableSpawn.inventory_slot )
{
	if(!isdefined(self.current_craftable_pieces))self.current_craftable_pieces=[];

	if ( isdefined( slot ) )
	{
		craftableSpawn craftable_set_piece_crafted( self.current_craftable_pieces[slot], self );
	}

	// If the current piece was used in crafting, then kill it.
	// Note, if we were crafting shared items, the current piece
	//	could be unrelated, so we would want to keep it.
	if ( isdefined( slot ) &&
	        isdefined( self.current_craftable_pieces[slot] ) &&
	        ( isdefined( self.current_craftable_pieces[slot].crafted ) && self.current_craftable_pieces[slot].crafted ) )
	{
		player_destroy_piece( self.current_craftable_pieces[slot], slot );
	}

	// Did we just craft at an open table?
	if ( isdefined( craftableSpawn.stub.n_open_craftable_choice ) )
	{
		uts_craftable = craftableSpawn craftable_transfer_data();
		craftableSpawn = uts_craftable.craftableSpawn;
		update_open_table_status();
	}
	else
	{
		uts_craftable = craftableSpawn.stub;
	}

	// See if we need to spawn in a model
	if ( !isdefined( uts_craftable.model ) && isdefined( uts_craftable.craftableStub.str_model ) )
	{
		craftableStub = uts_craftable.craftableStub;
		s_model = struct::get( uts_craftable.target, "targetname" );

		if ( isdefined( s_model ) )
		{
			m_spawn = Spawn( "script_model", s_model.origin );

			if ( isdefined( craftableStub.v_origin_offset ) )
			{
				m_spawn.origin += craftableStub.v_origin_offset;
			}

			m_spawn.angles = s_model.angles;

			if ( isdefined( craftableStub.v_angle_offset ) )
			{
				m_spawn.angles += craftableStub.v_angle_offset;
			}

			m_spawn SetModel( craftableStub.str_model );
			uts_craftable.model = m_spawn;
		}
	}

	if ( isdefined( uts_craftable.model ) )
	{
		for ( i = 0; i < craftableSpawn.a_pieceSpawns.size; i++ )
		{
			if ( isdefined( craftableSpawn.a_pieceSpawns[i].tag_name ) )
			{
				uts_craftable.model NotSolid();

				if ( !( isdefined( craftableSpawn.a_pieceSpawns[i].crafted ) && craftableSpawn.a_pieceSpawns[i].crafted ) )
				{
					uts_craftable.model HidePart( craftableSpawn.a_pieceSpawns[i].tag_name );
				}
				else
				{
					uts_craftable.model show();
					uts_craftable.model ShowPart( craftableSpawn.a_pieceSpawns[i].tag_name );
				}
			}
		}
	}

	//stat tracking
	self track_craftable_pieces_crafted( craftableSpawn );

	if ( craftableSpawn craftable_all_crafted() )
	{
		self player_finish_craftable( craftableSpawn );
		//craftableSpawn.stub craftablestub_finish_craft(self);

		//stat tracking
		self track_craftables_crafted( craftableSpawn );

		//SQ
		if ( isdefined( level.craftable_crafted_custom_func ) )
		{
			self thread [[level.craftable_crafted_custom_func]]( craftableSpawn );
		}

		self playsound( "zmb_buildable_complete" );

		// at this point either the trigger will be deleted or the prompt will be changed to the buy prompt so the crafted prompt will never appear in practice
		//assert (isdefined(level.zombie_craftableStubs[ craftableSpawn.craftable_name ].crafted), "Missing crafted hint" );
		//if (isdefined(level.zombie_craftableStubs[ craftableSpawn.craftable_name ].crafted))
		//	return level.zombie_craftableStubs[ craftableSpawn.craftable_name ].crafted;
	}
	else
	{
		self playsound( "zmb_buildable_piece_add" );

		assert ( isdefined( level.zombie_craftableStubs[ craftableSpawn.craftable_name ].str_crafting ), "Missing builing hint" );

		if ( isdefined( level.zombie_craftableStubs[ craftableSpawn.craftable_name ].str_crafting ) )
		{
			return level.zombie_craftableStubs[ craftableSpawn.craftable_name ].str_crafting;
		}
	}

	return "";
}


//
//	Check to see if there's any open craftables remaining.
//	If there isn't, shut down any remaining open craftable tables
function update_open_table_status()
{
	b_open_craftables_remaining = false;

	foreach ( uts_craftable in level.a_uts_craftables )
	{
		if ( isdefined( level.zombie_include_craftables[ uts_craftable.equipname ] ) &&
		        ( isdefined( level.zombie_include_craftables[ uts_craftable.equipname ].is_open_table ) && level.zombie_include_craftables[ uts_craftable.equipname ].is_open_table ) )
		{
			// Check to see if any pieces have been crafted
			b_piece_crafted = false;

			foreach ( pieceSpawn in uts_craftable.craftableSpawn.a_pieceSpawns )
			{
				if ( ( isdefined( pieceSpawn.crafted ) && pieceSpawn.crafted ) )
				{
					b_piece_crafted = true;
					break;
				}
			}

			if ( !b_piece_crafted )
			{
				b_open_craftables_remaining = true;
			}
		}
	}

	// If there's no more open craftables to craft, shut down the open tables
	if ( !b_open_craftables_remaining )
	{
		foreach ( uts_craftable in level.a_uts_craftables )
		{
			if ( uts_craftable.equipname == "open_table" )
			{
				thread zm_unitrigger::unregister_unitrigger( uts_craftable );
			}
		}
	}
}


//	Mark craftable as having been completed
function player_finish_craftable( craftableSpawn )
{
	craftableSpawn.crafted = true;
	craftableSpawn.stub.crafted = true;
	craftableSpawn notify( "crafted", self );
	level.craftables_crafted[ craftableSpawn.craftable_name ] = true;
	level notify( craftableSpawn.craftable_name + "_crafted", self );
}

//
//	magically finish a craftable.  For debug purposes only.  Some side effects may occur
function complete_craftable( str_craftable_name )
{
	foreach ( uts_craftable in level.a_uts_craftables )
	{
		if ( uts_craftable.craftableStub.name == str_craftable_name )
		{
			player = GetPlayers()[0];
			player player_finish_craftable( uts_craftable.craftableSpawn );
			thread zm_unitrigger::unregister_unitrigger( uts_craftable );

			if ( isdefined( uts_craftable.craftableStub.onFullyCrafted ) )
			{
				uts_craftable [[ uts_craftable.craftableStub.onFullyCrafted ]]();
			}

			return;
		}
	}
}


function craftablestub_remove()
{
	ArrayRemoveValue( level.a_uts_craftables, self );
}

function craftabletrigger_update_prompt( player )
{
	can_use = self.stub craftablestub_update_prompt( player );
	self SetHintString( self.stub.hint_string );
	return can_use;
}


//
//	This determines what kind of hintstring the player will see when in the trigger.
//	Returns false if the player cannot use the trigger.
//	Returns true if it is usable.
//	self is a uts_craftable
function craftablestub_update_prompt( player, unitrigger, slot = self.craftableStub.inventory_slot )
{
	if(!isdefined(player.current_craftable_pieces))player.current_craftable_pieces=[];

	if ( !self anystub_update_prompt( player ) )
	{
		return false;
	}

	if ( ( isdefined( self.is_locked ) && self.is_locked ) )
	{
		return true;
	}

	can_use = true;

	if ( isdefined( self.custom_craftablestub_update_prompt ) && !self [[ self.custom_craftablestub_update_prompt ]]( player ) )
	{
		return false;
	}

	if ( !( isdefined( self.crafted ) && self.crafted ) )
	{
		// If they don't have any shared pieces that can be used OR
		// If they don't have a piece, tell them to get more
		if ( !self.craftableSpawn craftable_can_use_shared_piece() )
		{
			if ( !isdefined( player.current_craftable_pieces[slot] ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
				return false;
			}
			// If they have a piece but it can't be used here
			else if ( !self.craftableSpawn craftable_has_piece( player.current_craftable_pieces[slot] ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				return false;
			}
		}

		// Otherwise, it seems like they can craft here!
		assert ( isdefined( level.zombie_craftableStubs[ self.equipname ].str_to_craft ), "Missing craftable hint" );

		self.hint_string = level.zombie_craftableStubs[ self.equipname ].str_to_craft;
	}
	else if ( self.persistent == 1 )
	{
		if ( zm_equipment::is_limited( self.weaponname ) && zm_equipment::limited_in_use( self.weaponname ) )
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
			return false;
		}

		if ( player zm_equipment::has_player_equipment( self.weaponname ) )
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
			return false;
		}

		self.hint_string = self.trigger_hintstring;
	}
	else if ( self.persistent == 2 )
	{
		if ( !zm_weapons::limited_weapon_below_quota( self.weaponname, undefined ) )
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			return false;
		}
		else if ( ( isdefined( self.str_taken ) && self.str_taken ) )
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			return false;
		}

		self.hint_string = self.trigger_hintstring;
	}
	else
	{
		self.hint_string = "";
		return false;
	}

	return true;
}


//
//	Wait until the player chooses a craftable or leaves the trigger
//	self is a uts_craftable
function choose_open_craftable( player )
{
	self endon( "kill_choose_open_craftable" );

	n_playernum = player GetEntityNumber();
	self.b_open_craftable_checking_input = true;
	b_got_input = true;	// Trigger the hint string update

	//	Display control hint text
	hintTextHudElem = newclientHudElem( player );
	hintTextHudElem.alignX = "center";
	hintTextHudElem.alignY = "middle";
	hintTextHudElem.horzAlign = "center";
	hintTextHudElem.vertAlign = "bottom";
	hintTextHudElem.y = -100;

	if ( player IsSplitScreen() )
	{
		hintTextHudElem.y = -50;
	}

	hintTextHudElem.foreground = true;
	hintTextHudElem.font = "default";
	hintTextHudElem.fontScale = 1.0;
	hintTextHudElem.alpha = 1;
	hintTextHudElem.color = ( 1.0, 1.0, 1.0 );
	hintTextHudElem setText( &"ZM_CRAFTABLES_CHANGE_BUILD" );

	if ( !isdefined( self.openCraftableHudElem ) )
	{
		self.openCraftableHudElem = [];
	}

	self.openCraftableHudElem[ n_playernum ] = hintTextHudElem;

	// Loop while we're inside the trigger.
	//	Also, we'll need to cut out if you crafted something.
	//		If the craftable is persistent, then we'd still be looping here without this check
	while ( isdefined( self.playertrigger[ n_playernum ] ) && !self.crafted )
	{
		if ( player ActionSlotOneButtonPressed() )
		{
			self.n_open_craftable_choice++;
			b_got_input = true;
		}
		else if ( player ActionSlotTwoButtonPressed() )
		{
			self.n_open_craftable_choice--;
			b_got_input = true;
		}

		// Limit check.  If we're out of bounds, wrap around
		//	This list could change if someone else crafted or picked up something, so keep checking
		if ( self.n_open_craftable_choice >= self.a_uts_open_craftables_available.size )
		{
			self.n_open_craftable_choice = 0;
		}
		else if ( self.n_open_craftable_choice < 0 )
		{
			self.n_open_craftable_choice = self.a_uts_open_craftables_available.size - 1;
		}

		if ( b_got_input )
		{
			// Update the prompt...promptly!
			self.equipname		= self.a_uts_open_craftables_available[ self.n_open_craftable_choice ].equipname;
			self.hint_string	= self.a_uts_open_craftables_available[ self.n_open_craftable_choice ].hint_string;
			self.playertrigger[ n_playernum ] SetHintString( self.hint_string );
			b_got_input = false;
		}

		// Visibility check
		if ( player util::is_player_looking_at( self.playertrigger[ n_playernum ].origin, 0.76 ) )
		{
			self.openCraftableHudElem[ n_playernum ].alpha = 1;
		}
		else
		{
			self.openCraftableHudElem[ n_playernum ].alpha = 0;
		}

		{wait(.05);};
	}

	self.b_open_craftable_checking_input = false;
	self.openCraftableHudElem[ n_playernum ] destroy();
	self.openCraftableHudElem[ n_playernum ] = undefined;
}


//
//	This determines what kind of hintstring the player will see when in the trigger.
//	NOTE: This function is called once a second.  It's also called when
//		you're trying to craft something, so the logic makes my head hurt.
//	self is a unitrigger craftable stub
//	Returns false if the player cannot use the trigger.
//	Returns true if it is usable.
function open_craftablestub_update_prompt( player, slot = 0 )
{
	// If we haven't already built something here
	if ( !( isdefined( self.crafted ) && self.crafted ) )
	{
		// Check each craftable to see if we can try to make it here
		self.a_uts_open_craftables_available = [];	// have we found a craftable that can be used here?

		foreach ( uts_craftable in level.a_uts_craftables )
		{
			// If our craftable is the open type AND
			//	it hasn't already been crafted AND
			//	it's not really an open_table trigger AND
			//  they have any shared pieces that can be used
			if ( ( isdefined( uts_craftable.craftableStub.is_open_table ) && uts_craftable.craftableStub.is_open_table ) &&
			        !( isdefined( uts_craftable.crafted ) && uts_craftable.crafted ) &&
			        uts_craftable.craftableSpawn.craftable_name != "open_table" &&
			        uts_craftable.craftableSpawn craftable_can_use_shared_piece() )
			{
				// we could potentially craft this thing
				self.a_uts_open_craftables_available[self.a_uts_open_craftables_available.size] = uts_craftable;
			}
		}

		// So how many candidates did we find?

		// If less than 2 kill any existing input checking funcs
		if ( self.a_uts_open_craftables_available.size < 2 )
		{
			self notify( "kill_choose_open_craftable" );
			self.b_open_craftable_checking_input = false;
			n_entitynum = player GetEntityNumber();

			if ( isdefined( self.openCraftableHudElem ) &&
			        isdefined( self.openCraftableHudElem[ n_entitynum ] ) )
			{
				self.openCraftableHudElem[ n_entitynum ] destroy();
				self.openCraftableHudElem[ n_entitynum ] = undefined;
			}
		}

		switch ( self.a_uts_open_craftables_available.size )
		{
			case 0:
				if ( !isdefined( player.current_craftable_pieces[slot] ) )
				{
					self.hint_string				= &"ZOMBIE_BUILD_PIECE_MORE";
					self.n_open_craftable_choice	= -1;
					return false;
				}

				break;

			case 1:
				// Otherwise, it seems like they can craft here!
				self.n_open_craftable_choice	= 0;
				self.equipname					= self.a_uts_open_craftables_available[ self.n_open_craftable_choice ].equipname;
				return true;

			default:

				// If we have 2 or more, we need to show the player a way to choose between them.
				//TODO Known bug: If more than one person approaches the same table, only the first
				//	person will be able to choose.  How do we want to handle this?
				if ( !self.b_open_craftable_checking_input )
				{
					thread choose_open_craftable( player );
				}

				return true;
		}
	}
	else if ( self.persistent == 1 ||
	          ( self.persistent == 2 && !( isdefined( self.bought ) && self.bought ) ) )
	{
		return true;
	}

	return false;
}


//
//	self is a player
function player_continue_crafting( craftableSpawn, slot )
{
	if ( self laststand::player_is_in_laststand() || self zm_utility::in_revive_trigger() )
	{
		return false;
	}

//	if( self isThrowingGrenade() )
//		return false;
	if ( !( self player_can_craft( craftableSpawn, true ) ) )
	{
		return false;
	}

	if ( isdefined( self.screecher ) )
	{
		return false;
	}

	if ( !self UseButtonPressed() )
	{
		return false;
	}

	if ( craftableSpawn.stub.useTime > 0 && isdefined( slot ) && !craftableSpawn craftable_is_piece_crafting( self.current_craftable_pieces[slot] ) )
	{
		return false;
	}

	trigger = craftableSpawn.stub zm_unitrigger::unitrigger_trigger( self );

	if ( craftableSpawn.stub.script_unitrigger_type == "unitrigger_radius_use" )
	{
		torigin = craftableSpawn.stub zm_unitrigger::unitrigger_origin();
		porigin = self GetEye();
		radius_sq = ( 1.5 * 1.5 ) * craftableSpawn.stub.radius * craftableSpawn.stub.radius;

		if ( Distance2DSquared( torigin, porigin ) > radius_sq )
		{
			return false;
		}
	}
	else
	{
		if ( !isdefined( trigger ) || !trigger IsTouching( self ) ) //self IsTouching(trigger))
		{
			return false;
		}
	}

	if ( ( isdefined( craftableSpawn.stub.require_look_at ) && craftableSpawn.stub.require_look_at ) && !self util::is_player_looking_at( trigger.origin, 0.76 ) )
	{
		return false;
	}

	return true;
}

function player_progress_bar_update( start_time, craft_time )
{
	self endon( "entering_last_stand" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "craftable_progress_end" );

	while ( isdefined( self ) && getTime() - start_time < craft_time )
	{
		progress = ( getTime() - start_time ) / craft_time;

		if ( progress < 0 )
		{
			progress = 0;
		}

		if ( progress > 1 )
		{
			progress = 1;
		}

		self.useBar hud::updateBar( progress );
		{wait(.05);};
	}

}

function player_progress_bar( start_time, craft_time )
{
	self.useBar = self hud::createPrimaryProgressBar();
	self.useBarText = self hud::createPrimaryProgressBarText();
	self.useBarText setText( &"ZOMBIE_BUILDING" );

	if ( isdefined( self ) && isdefined( start_time ) && isdefined( craft_time ) )
	{
		self player_progress_bar_update( start_time, craft_time );
	}

	self.useBarText hud::destroyElem();
	self.useBar hud::destroyElem();
}


//
//	self is a unitrigger
function craftable_use_hold_think_internal( player, slot = self.stub.craftableSpawn.inventory_slot )
{
	wait 0.01;

	if ( !isdefined( self ) )
	{
		self notify( "craft_failed" );

		//make sure the audio sounds go away
		if ( isdefined( player.craftableAudio ) )
		{
			player.craftableAudio delete();
			player.craftableAudio = undefined;
		}

		return;
	}

	if ( !isdefined( self.useTime ) )
	{
		self.useTime = int( 3 * 1000 );
	}

	self.craft_time = self.useTime;
	self.craft_start_time = getTime();
	craft_time = self.craft_time;
	craft_start_time = self.craft_start_time;

	if ( craft_time > 0 )
	{
		player zm_utility::disable_player_move_states( true );

		player zm_utility::increment_is_drinking();
		orgweapon = player GetCurrentWeapon();
		build_weapon = GetWeapon( "zombie_builder" );
		player GiveWeapon( build_weapon );
		player SwitchToWeapon( build_weapon );

		if ( isdefined( slot ) )
		{
			self.stub.craftableSpawn craftable_set_piece_crafting( player.current_craftable_pieces[slot] );
		}

		player thread player_progress_bar( craft_start_time, craft_time );

		//check to see if this is the final piece
		if ( isdefined( level.craftable_craft_custom_func ) )
		{
			player thread [[level.craftable_craft_custom_func]]( self.stub );
		}


		while ( isdefined( self ) && player player_continue_crafting( self.stub.craftableSpawn, slot ) && getTime() - self.craft_start_time < self.craft_time )
		{
			{wait(.05);};
		}

		player notify( "craftable_progress_end" );

		player zm_weapons::switch_back_primary_weapon( orgweapon );
		//player SwitchToWeapon( orgweapon );
		player TakeWeapon( build_weapon );

		if ( ( isdefined( player.is_drinking ) && player.is_drinking ) )
		{
			player zm_utility::decrement_is_drinking();
		}

		player zm_utility::enable_player_move_states();
	}

	if ( isdefined( self ) &&
	        player player_continue_crafting( self.stub.craftableSpawn, slot ) &&
	        ( self.craft_time <= 0 || getTime() - self.craft_start_time >= self.craft_time ) )
	{
		if ( isdefined( slot ) )
		{
			self.stub.craftableSpawn craftable_clear_piece_crafting( player.current_craftable_pieces[slot] );
		}

		self notify( "craft_succeed" );
	}
	else
	{
		//make sure the audio sounds go away
		if ( isdefined( player.craftableAudio ) )
		{
			player.craftableAudio delete();
			player.craftableAudio = undefined;
		}

		if ( isdefined( slot ) )
		{
			self.stub.craftableSpawn craftable_clear_piece_crafting( player.current_craftable_pieces[slot] );
		}

		self notify( "craft_failed" );
	}

}

function craftable_play_craft_fx( player )
{
	self endon( "kill_trigger" );
	self endon( "craft_succeed" );
	self endon( "craft_failed" );

	while ( 1 )
	{
		PlayFX( level._effect["building_dust"], player GetPlayerCameraPos(), player.angles );
		//PlayFxOnTag( level._effect["crafting_dust"], player, "tag_camera" );
		wait 0.5;
	}
}

function craftable_use_hold_think( player )
{
	self thread craftable_play_craft_fx( player );
	self thread craftable_use_hold_think_internal( player );
	retval = self util::waittill_any_return( "craft_succeed", "craft_failed" );

	if ( retval == "craft_succeed" )
	{
		return true;
	}

	return false;
}


// Main unitrigger think function for craftable place triggers
// self is a unitrigger
function craftable_place_think()
{
	self notify( "craftable_place_think" );
	self endon( "craftable_place_think" );
	self endon( "kill_trigger" );

	player_crafted = undefined;

	while ( !( isdefined( self.stub.crafted ) && self.stub.crafted ) )
	{
		self waittill( "trigger", player );

		if ( isdefined( level.custom_craftable_validation ) )
		{
			valid = self [[ level.custom_craftable_validation ]]( player );

			if ( !valid )
			{
				continue;
			}
		}

		if ( player != self.parent_player )
		{
			continue;
		}

		if ( isdefined( player.screecher_weapon ) )
		{
			continue;
		}

		if ( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		status = player player_can_craft( self.stub.craftableSpawn );

		if ( !status )
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );

			if ( isdefined( self.stub.onCantUse ) )
			{
				self.stub [[ self.stub.onCantUse ]]( player );
			}
		}
		else
		{
			if ( isdefined( self.stub.onBeginUse ) )
			{
				self.stub [[ self.stub.onBeginUse ]]( player );
			}

			result = self craftable_use_hold_think( player );
			team = player.pers["team"];

			if ( isdefined( self.stub.onEndUse ) )
			{
				self.stub [[ self.stub.onEndUse ]]( team, player, result );
			}

			if ( !result )
			{
				continue;
			}

			if ( isdefined( self.stub.onUse ) )
			{
				self.stub [[ self.stub.onUse ]]( player );
			}

			prompt = player player_craft( self.stub.craftableSpawn );
			player_crafted = player;
			self.stub.hint_string = prompt;
			self SetHintString( self.stub.hint_string );
		}
	}

	// Run a custom function if called for.
	//	If it returns false, then stop processing.
	if ( isdefined( self.stub.craftableStub.onFullyCrafted ) )
	{
		b_result = self.stub [[ self.stub.craftableStub.onFullyCrafted ]]();

		if ( !b_result )
		{
			return;
		}
	}

	if ( isdefined( player_crafted ) )
	{
		//player_crafted playsound( "zmb_buildable_complete" );
	}

	if ( self.stub.persistent == 0 )
	{
		self.stub craftablestub_remove();
		thread zm_unitrigger::unregister_unitrigger( self.stub );
		return;
	}

	if ( self.stub.persistent == 3 )
	{
		stub_uncraft_craftable( self.stub, true );
		return;
	}

	if ( self.stub.persistent == 2 )
	{
		if ( isdefined( player_crafted ) )
		{
			self craftabletrigger_update_prompt( player_crafted );
		}

		if ( !zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self SetHintString( self.stub.hint_string );
			return;
		}

		if ( ( isdefined( self.stub.str_taken ) && self.stub.str_taken ) )
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			self SetHintString( self.stub.hint_string );
			return;
		}

		if ( isdefined( self.stub.model ) )
		{
			self.stub.model NotSolid();
			self.stub.model show();
		}

		while ( self.stub.persistent == 2 )
		{
			self waittill( "trigger", player );

			if ( isdefined( player.screecher_weapon ) )
			{
				continue;
			}

			if ( isdefined( level.custom_craftable_validation ) )
			{
				valid = self [[ level.custom_craftable_validation ]]( player );

				if ( !valid )
				{
					continue;
				}
			}

			if ( !( isdefined( self.stub.crafted ) && self.stub.crafted ) )
			{
				self.stub.hint_string = "";
				self SetHintString( self.stub.hint_string );
				return;
			}

			if ( player != self.parent_player )
			{
				continue;
			}

			if ( !zm_utility::is_player_valid( player ) )
			{
				player thread zm_utility::ignore_triggers( 0.5 );
				continue;
			}

			self.stub.bought = 1;

			if ( isdefined( self.stub.model ) )
			{
				self.stub.model thread model_fly_away( self );
			}

			player zm_weapons::weapon_give( self.stub.weaponname );

			if ( isdefined( level.zombie_include_craftables[ self.stub.equipname ].onBuyWeapon ) )
			{
				self [[level.zombie_include_craftables[ self.stub.equipname ].onBuyWeapon]]( player );
			}

			if ( !zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			}
			else
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			}

			self SetHintString( self.stub.hint_string );

			//stat tracking
			player track_craftables_pickedup( self.stub.craftableSpawn );

		}
	}
	else if ( !isdefined( player_crafted ) || self craftabletrigger_update_prompt( player_crafted ) )
	{
		if ( isdefined( self.stub.model ) )
		{
			self.stub.model NotSolid();
			self.stub.model show();
		}

		while ( self.stub.persistent == 1 )
		{
			self waittill( "trigger", player );

			if ( isdefined( player.screecher_weapon ) )
			{
				continue;
			}

			if ( isdefined( level.custom_craftable_validation ) )
			{
				valid = self [[ level.custom_craftable_validation ]]( player );

				if ( !valid )
				{
					continue;
				}
			}

			if ( !( isdefined( self.stub.crafted ) && self.stub.crafted ) )
			{
				self.stub.hint_string = "";
				self SetHintString( self.stub.hint_string );
				return;
			}

			if ( player != self.parent_player )
			{
				continue;
			}

			if ( !zm_utility::is_player_valid( player ) )
			{
				player thread zm_utility::ignore_triggers( 0.5 );
				continue;
			}

			if ( player zm_equipment::has_player_equipment( self.stub.weaponname ) )
			{
				continue;
			}

			if ( isdefined( level.zombie_craftable_persistent_weapon ) )
			{
				if ( self [[level.zombie_craftable_persistent_weapon]]( player ) )
				{
					continue;
				}
			}

			if ( isdefined( level.zombie_custom_equipment_setup ) )
			{
				if ( self [[level.zombie_custom_equipment_setup]]( player ) )
				{
					continue;
				}
			}

			if ( !zm_equipment::is_limited( self.stub.weaponname ) || !zm_equipment::limited_in_use( self.stub.weaponname ) )
			{
				player zm_equipment::buy( self.stub.weaponname );
				player GiveWeapon( self.stub.weaponname );
				player setWeaponAmmoClip( self.stub.weaponname, 1 );

				if ( isdefined( level.zombie_include_craftables[ self.stub.equipname ].onBuyWeapon ) )
				{
					self [[level.zombie_include_craftables[ self.stub.equipname ].onBuyWeapon]]( player );
				}

				else if ( self.stub.weaponname != "keys_zm" )
				{
					player setactionslot( 1, "weapon", self.stub.weaponname );
				}

				if ( isdefined( level.zombie_craftableStubs[ self.stub.equipname ].str_taken ) )
				{
					self.stub.hint_string = level.zombie_craftableStubs[ self.stub.equipname ].str_taken;
				}
				else
				{
					self.stub.hint_string = "";
				}

				self SetHintString( self.stub.hint_string );

				//stat tracking
				player track_craftables_pickedup( self.stub.craftableSpawn );
			}
			else
			{
				self.stub.hint_string = "";
				self SetHintString( self.stub.hint_string );
			}
		}
	}
}

function model_fly_away( unitrigger )
{
	self moveto( self.origin + ( 0, 0, 40 ), 3 );
	direction = self.origin;
	direction = ( direction[1], direction[0], 0 );

	if ( direction[1] < 0 || ( direction[0] > 0 && direction[1] > 0 ) )
	{
		direction = ( direction[0], direction[1] * -1, 0 );
	}
	else if ( direction[0] < 0 )
	{
		direction = ( direction[0] * -1, direction[1], 0 );
	}

	self Vibrate( direction, 10, 0.5, 4 );
	self waittill( "movedone" );

	self Ghost();

	PlayFX( level._effect["poltergeist"], self.origin );
}


function find_craftable_stub( equipname )
{
	foreach ( stub in level.a_uts_craftables )
	{
		if ( stub.equipname == equipname )
		{
			return stub;
		}
	}

	return undefined;
}

function uncraft_craftable( equipname, return_pieces, origin, angles )
{
	stub = find_craftable_stub( equipname );

	stub_uncraft_craftable( stub, return_pieces, origin, angles );
}

function stub_uncraft_craftable( stub, return_pieces, origin, angles, use_random_start )
{
	if ( isdefined( stub ) )
	{
		craftable = stub.craftableSpawn;
		craftable.crafted = false;
		craftable.stub.crafted = false;
		craftable notify( "uncrafted" );
		level.craftables_crafted[ craftable.craftable_name ] = false;
		level notify( craftable.craftable_name + "_uncrafted" );

		for ( i = 0; i < craftable.a_pieceSpawns.size; i++ )
		{
			craftable.a_pieceSpawns[i].crafted = false;

			if ( isdefined( craftable.a_pieceSpawns[i].tag_name ) )
			{
				craftable.stub.model NotSolid();

				if ( !( isdefined( craftable.a_pieceSpawns[i].crafted ) && craftable.a_pieceSpawns[i].crafted ) )
				{
					craftable.stub.model HidePart( craftable.a_pieceSpawns[i].tag_name );
				}
				else
				{
					craftable.stub.model show();
					craftable.stub.model ShowPart( craftable.a_pieceSpawns[i].tag_name );
				}
			}

			if ( ( isdefined( return_pieces ) && return_pieces ) )
			{
				craftable.a_pieceSpawns[i] piece_spawn_at( origin, angles, use_random_start );
			}
		}

		if ( isdefined( craftable.stub.model ) )
		{
			craftable.stub.model Ghost();
		}
	}
}

function player_explode_craftable( equipname, origin, speed, return_to_spawn, return_time )
{
	self ExplosionDamage( 50, origin );

	stub = find_craftable_stub( equipname );

	if ( isdefined( stub ) )
	{
		craftable = stub.craftableSpawn;
		craftable.crafted = false;
		craftable.stub.crafted = false;
		craftable notify( "uncrafted" );
		level.craftables_crafted[ craftable.craftable_name ] = false;
		level notify( craftable.craftable_name + "_uncrafted" );

		for ( i = 0; i < craftable.a_pieceSpawns.size; i++ )
		{
			craftable.a_pieceSpawns[i].crafted = false;

			if ( isdefined( craftable.a_pieceSpawns[i].tag_name ) )
			{
				craftable.stub.model NotSolid();

				if ( !( isdefined( craftable.a_pieceSpawns[i].crafted ) && craftable.a_pieceSpawns[i].crafted ) )
				{
					craftable.stub.model HidePart( craftable.a_pieceSpawns[i].tag_name );
				}
				else
				{
					craftable.stub.model show();
					craftable.stub.model ShowPart( craftable.a_pieceSpawns[i].tag_name );
				}
			}

			ang = RandomFloat( 360 );
			h = 0.25 + RandomFloat( 0.5 );
			dir = ( Sin( ang ), Cos( ang ), h );
			self thread player_throw_piece( craftable.a_pieceSpawns[i], origin, speed * dir, return_to_spawn, return_time );
		}

		craftable.stub.model Ghost();
	}
}


//
//
function think_craftables()
{
	foreach ( craftable in level.zombie_include_craftables )
	{
		if ( isdefined( craftable.triggerThink ) )
		{
			craftable [[craftable.triggerThink]]();
		}
	}
}


// Add open table craftable triggers
function openTableCraftable()
{
	a_trigs = GetEntArray( "open_craftable_trigger", "targetname" );

	foreach ( trig in a_trigs )
	{
		setup_unitrigger_craftable_internal( trig, "open_table", "", "OPEN_CRAFTABLE", 1, 0 );
	}
}


// self is craftable data (CD)
function craftable_trigger_think( trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	return setup_unitrigger_craftable( trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent );
}

function craftable_trigger_think_array( trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	return setup_unitrigger_craftable_array( trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent );
}



//
//	delete_trigger should probably be KEEP_TRIGGER since the dynamic unitriggers
//	rely on the .origin_parent's origin to determine the trigger's location
function setup_vehicle_unitrigger_craftable( parent, trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	trig = GetEnt( trigger_targetname, "targetname" );

	if ( !isdefined( trig ) )
	{
		return;
	}

	unitrigger_stub = spawnstruct();

	unitrigger_stub.craftableStub = level.zombie_include_craftables[ equipname ];

	unitrigger_stub.link_parent = parent;
	unitrigger_stub.origin_parent = trig;
	unitrigger_stub.trigger_targetname = trigger_targetname;
	unitrigger_stub.originFunc = &anystub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;
	unitrigger_stub.origin = trig.origin;
	unitrigger_stub.angles = trig.angles;
	unitrigger_stub.equipname = equipname;
	unitrigger_stub.weaponname = weaponname;
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.delete_trigger = delete_trigger;
	unitrigger_stub.crafted = false;
	unitrigger_stub.persistent = persistent;
	unitrigger_stub.useTime = int( 3 * 1000 );

	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;

	if ( isdefined( trig.script_length ) )
	{
		unitrigger_stub.script_length = trig.script_length;
	}
	else
	{
		unitrigger_stub.script_length = 24;
	}

	if ( isdefined( trig.script_width ) )
	{
		unitrigger_stub.script_width = trig.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 64;
	}

	if ( isdefined( trig.script_height ) )
	{
		unitrigger_stub.script_height = trig.script_height;
	}
	else
	{
		unitrigger_stub.script_height = 24;
	}

	if ( isdefined( trig.radius ) )
	{
		unitrigger_stub.radius = trig.radius;
	}
	else
	{
		unitrigger_stub.radius = 64;
	}

	unitrigger_stub.target = trig.target;
	unitrigger_stub.targetname = trig.targetname + "_trigger";

	unitrigger_stub.script_noteworthy = trig.script_noteworthy;
	unitrigger_stub.script_parameters = trig.script_parameters;

	unitrigger_stub.cursor_hint = "HINT_NOICON";

	if ( isdefined( level.zombie_craftableStubs[ equipname ].str_to_craft ) )
	{
		unitrigger_stub.hint_string = level.zombie_craftableStubs[ equipname ].str_to_craft;
	}

	unitrigger_stub.script_unitrigger_type  = "unitrigger_radius_use";
	unitrigger_stub.require_look_at = true;

	zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );
	unitrigger_stub.prompt_and_visibility_func = &craftabletrigger_update_prompt;

	//zm_unitrigger::register_static_unitrigger(unitrigger_stub, &craftable_spawn_think);
	zm_unitrigger::register_unitrigger( unitrigger_stub, &craftable_place_think );

	unitrigger_stub.piece_trigger = trig;
	trig.trigger_stub = unitrigger_stub;

	// create craftable pieces
	//unitrigger_stub.craftableSpawn = trig craftable_piece_triggers( equipname, unitrigger_stub.origin );
	unitrigger_stub.craftableSpawn = unitrigger_stub craftable_piece_unitriggers( equipname, unitrigger_stub.origin );

	if ( delete_trigger )
	{
		trig delete();
	}

	level.a_uts_craftables[level.a_uts_craftables.size] = unitrigger_stub;
	return unitrigger_stub;
}


//
//	delete_trigger should probably be KEEP_TRIGGER since the dynamic unitriggers
//	rely on the .origin_parent's origin to determine the trigger's location
//		Also, this function is redundant because it just calls another function with the
//	same arguments.  I'm only leaving it for compatibility reasons (stay similar to buildables).
function vehicle_craftable_trigger_think( vehicle, trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent )
{
	return setup_vehicle_unitrigger_craftable( vehicle, trigger_targetname, equipname, weaponname, trigger_hintstring, delete_trigger, persistent );
}



function onPickupUTS( player )
{
	/#

	if ( isdefined( player ) && isdefined( player.name ) )
	{
		PrintLn( "ZM >> Craftable piece recovered by - " + player.name );
	}

#/
}

function onDropUTS( player )
{
	/#

	if ( isdefined( player ) && isdefined( player.name ) )
	{
		PrintLn( "ZM >> Craftable piece dropped by - " + player.name );
	}

#/
	player notify( "event_ended" );
}

function onBeginUseUTS( player )
{
	/#

	if ( isdefined( player ) && isdefined( player.name ) )
	{
		PrintLn( "ZM >> Craftable piece begin use by - " + player.name );
	}

#/

	if ( isdefined( self.craftableStub.onBeginUse ) )
	{
		self [[ self.craftableStub.onBeginUse ]]( player );
	}

	if ( isdefined( player ) && !isdefined( player.craftableAudio ) )
	{
		player.craftableAudio = spawn( "script_origin", player.origin );
		player.craftableAudio PlayLoopSound( "zmb_craftable_loop" );
	}
}

function onEndUseUTS( team, player, result )
{
	/#

	if ( isdefined( player ) && isdefined( player.name ) )
	{
		PrintLn( "ZM >> Craftable piece end use by - " + player.name );
	}

#/

	if ( !isdefined( player ) )
	{
		return;
	}

	if ( isdefined( player.craftableAudio ) )
	{
		player.craftableAudio delete();
		player.craftableAudio = undefined;
	}

	if ( isdefined( self.craftableStub.onEndUse ) )
	{
		self [[ self.craftableStub.onEndUse ]]( team, player, result );
	}

	player notify( "event_ended" );
}

function onCantUseUTS( player )
{
	/#

	if ( isdefined( player ) && isdefined( player.name ) )
	{
		PrintLn( "ZM >> Craftable piece can't use by - " + player.name );
	}

#/

	if ( isdefined( self.craftableStub.onCantUse ) )
	{
		self [[ self.craftableStub.onCantUse ]]( player );
	}
}

function onUsePlantObjectUTS( player )
{
	/#

	if ( isdefined( player ) && isdefined( player.name ) )
	{
		PrintLn( "ZM >> Craftable piece crafted by - " + player.name );
	}

#/

	if ( isdefined( self.craftableStub.onUsePlantObject ) )
	{
		self [[ self.craftableStub.onUsePlantObject ]]( player );
	}

	//* player playSound( "mpl_sd_bomb_plant" );
	player notify ( "bomb_planted" );

}

function is_craftable()
{
	// No Craftables Set Up In Map
	//----------------------------
	if ( !isdefined( level.zombie_craftableStubs ) )
	{
		return false;
	}

	// WallBuys
	//---------
	if ( isdefined( self.zombie_weapon_upgrade ) && isdefined( level.zombie_craftableStubs[ self.zombie_weapon_upgrade ] ) )
	{
		return true;
	}

	// Machines
	//---------
	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "specialty_weapupgrade" )
	{
		if ( ( isdefined( level.craftables_crafted[ "pap" ] ) && level.craftables_crafted[ "pap" ] ) )
		{
			return false;
		}

		return true;
	}

	return false;
}

function craftable_crafted()
{
	self.a_pieceSpawns--;
}

function craftable_complete()
{
	if ( self.a_pieceSpawns <= 0 )
	{
		return true;
	}

	return false;
}


function get_craftable_hint( craftable_name )
{
	assert( isdefined( level.zombie_craftableStubs[ craftable_name ] ), craftable_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_craftableStubs[ craftable_name ].str_to_craft;
}

function delete_on_disconnect( craftable, self_notify, skip_delete )
{
	craftable endon( "death" );

	self waittill( "disconnect" );

	if ( isdefined( self_notify ) )
	{
		self notify( self_notify );
	}

	if ( !( isdefined( skip_delete ) && skip_delete ) )
	{
		if ( isdefined( craftable.stub ) )
		{
			thread zm_unitrigger::unregister_unitrigger( craftable.stub );
			craftable.stub = undefined;
		}

		if ( isdefined( craftable ) )
		{
			craftable Delete();
		}
	}
}


// Currently unused
//get_craftable_pickup( craftableName, modelName )
//{
//	foreach ( craftablePickUp in level.craftablePickUps )
//	{
//		if ( craftablePickUp[ 0 ].craftableStub.name == craftableName && craftablePickUp[ 0 ].visuals[ 0 ].model == modelName )
//		{
//			return craftablePickUp[ 0 ];
//		}
//	}
//
//	return undefined;
//}


//
//	Returns true if the piece is in the shared inventory or if the player is actually holding it
// self is a player
function is_holding_part( craftable_name, piece_name, slot = 0 )
{
	// Check against what the player is holding
	if ( isdefined( self.current_craftable_pieces ) && isdefined( self.current_craftable_pieces[slot] ) )
	{
		if ( self.current_craftable_pieces[slot].craftablename == craftable_name &&
		        self.current_craftable_pieces[slot].modelname == piece_name )
		{
			return true;
		}
	}

	// See if the part exists
	if ( isdefined( level.a_uts_craftables ) )
	{
		foreach ( craftable_stub in level.a_uts_craftables )
		{
			if ( craftable_stub.craftableStub.name == craftable_name )
			{
				// Search through the pieces to find the part
				foreach ( piece in craftable_stub.craftableSpawn.a_pieceSpawns )
				{
					if ( piece.pieceName == piece_name )
					{
						if ( ( isdefined( piece.in_shared_inventory ) && piece.in_shared_inventory ) )
						{
							return true;
						}
					}
				}
			}
		}
	}

	return false;
}


//
//	Returns true if the part has been applied to the craftable, false otherwise
function is_part_crafted( craftable_name, piece_name )
{
	// See if the part exists and if it has been crafted
	if ( isdefined( level.a_uts_craftables ) )
	{
		foreach ( craftable_stub in level.a_uts_craftables )
		{
			if ( craftable_stub.craftableStub.name == craftable_name )
			{
				// Short circuit
				if ( ( isdefined( craftable_stub.crafted ) && craftable_stub.crafted ) )
				{
					return true;
				}

				// Search through the pieces to find the part
				foreach ( piece in craftable_stub.craftableSpawn.a_pieceSpawns )
				{
					if ( piece.pieceName == piece_name )
					{
						if ( ( isdefined( piece.crafted ) && piece.crafted ) )
						{
							return true;
						}
					}
				}
			}
		}
	}

	return false;
}



//-------------------------------------------------
//STAT TRACKING STUFF
//-------------------------------------------------

function track_craftable_piece_pickedup( piece )
{
	if ( !isdefined( piece ) || !isdefined( piece.craftablename ) )
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_craftable_piece_pickedup() \n"); #/
		return;
	}

	self add_map_craftable_stat( piece.craftablename, "pieces_pickedup", 1 );

	if ( isdefined( piece.piecestub.vox_id ) )
	{
		if ( ( isdefined( piece.piecestub.b_one_time_vo ) && piece.piecestub.b_one_time_vo ) )
		{
			if ( !isdefined( self.a_one_time_piece_pickup_vo ) )
			{
				self.a_one_time_piece_pickup_vo = [];
			}

			if ( ( isdefined( self.dontspeak ) && self.dontspeak ) )
			{
				return;
			}

			if ( IsInArray( self.a_one_time_piece_pickup_vo, piece.piecestub.vox_id ) )
			{
				return;
			}

			self.a_one_time_piece_pickup_vo[self.a_one_time_piece_pickup_vo.size] = piece.piecestub.vox_id;
		}

		self thread zm_utility::do_player_general_vox( "general", piece.piecestub.vox_id + "_pickup"  );
	}
	else
	{
		self thread zm_utility::do_player_general_vox( "general", "build_pickup" );
	}
}

function track_craftable_pieces_crafted( craftable )
{
	if ( !isdefined( craftable ) || !isdefined( craftable.craftable_name ) )
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_craftable_pieces_crafted() \n"); #/
		return;
	}

	bname = craftable.craftable_name;

	if ( isdefined( craftable.stat_name ) )
	{
		bname = craftable.stat_name;
	}

	self add_map_craftable_stat( bname, "pieces_built", 1 );

	if ( !craftable craftable_all_crafted() )
	{
		self thread zm_utility::do_player_general_vox( "general", "build_add" );
	}
}

function track_craftables_crafted( craftable )
{
	if ( !isdefined( craftable ) || !isdefined( craftable.craftable_name ) )
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_craftables_crafted() \n"); #/
		return;
	}

	bname = craftable.craftable_name;

	if ( isdefined( craftable.stat_name ) )
	{
		bname = craftable.stat_name;
	}

	self add_map_craftable_stat( bname, "buildable_built", 1 );
	self zm_stats::increment_client_stat( "buildables_built", false );
	self zm_stats::increment_player_stat( "buildables_built" );

	if ( isdefined( craftable.stub.craftablestub.vox_id ) )
	{
		if ( isdefined( level.zombie_custom_craftable_built_vo ) )
		{
			self thread [[ level.zombie_custom_craftable_built_vo ]]( craftable.stub );
		}

		self thread zm_utility::do_player_general_vox( "general", craftable.stub.craftablestub.vox_id + "_final"  );
	}
}

function track_craftables_pickedup( craftable )
{
	if ( !isdefined( craftable ) )
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_craftables_pickedup() \n"); #/
		return;
	}

	stat_name = get_craftable_stat_name( craftable.craftable_name );

	if ( !isdefined( stat_name ) )
	{
		/# println( "STAT TRACKING FAILURE: NO STAT NAME FOR " + craftable.craftable_name + "\n"); #/
		return;
	}

	self add_map_craftable_stat( stat_name, "buildable_pickedup", 1 );

	if ( isdefined( craftable.stub.craftablestub.vox_id ) )
	{
		self thread zm_utility::do_player_general_vox( "general", craftable.stub.craftablestub.vox_id + "_plc" );
	}

	self say_pickup_craftable_vo( craftable, false );

}

//craftables that are planted on the ground ( turret, turbine, etc )
function track_craftables_planted( equipment )
{
	if ( !isdefined( equipment ) )
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED for track_craftables_planted() \n"); #/
		return;
	}

	craftable_name = undefined;

	if ( isdefined( equipment.name ) )
	{
		craftable_name = get_craftable_stat_name( equipment.name );
	}

	if ( !isdefined( craftable_name ) )
	{
		/# println( "STAT TRACKING FAILURE: NO CRAFTABLE NAME FOR track_craftables_planted() " + equipment.name + "\n"); #/
		return;
	}

	demo::bookmark( "zm_player_buildable_placed", gettime(), self );
	self add_map_craftable_stat( craftable_name, "buildable_placed", 1 );
//
//	vo_name = "craft_plc_" + craftable_name;
//	if(craftable_name == "electric_trap")
//	{
//		vo_name ="craft_plc_trap";
//	}
//
//	if(!IS_TRUE(self.craftable_timer ))
//	{
//		self thread zm_utility::do_player_general_vox("general",vo_name);
//		self thread placed_craftable_vo_timer();
//	}
}

function placed_craftable_vo_timer()
{
	self endon( "disconnect" );
	self.craftable_timer = true;
	wait( 60 );
	self.craftable_timer = false;
}

function craftable_pickedup_timer()
{
	self endon( "disconnect" );
	self.craftable_pickedup_timer = true;
	wait( 60 );
	self.craftable_pickedup_timer = false;
}

//craftables that are planted on the ground ( turret, turbine, etc )
function track_planted_craftables_pickedup( equipment )
{
	if ( !isdefined( equipment ) )
	{
		return;
	}

	if ( equipment == "equip_turbine_zm" || equipment == "equip_turret_zm" || equipment == "equip_electrictrap_zm" || equipment == "riotshield_zm" || equipment == "alcatraz_shield_zm" || equipment == "tomb_shield_zm" )
	{
		self zm_stats::increment_client_stat( "planted_buildables_pickedup", false );
		self zm_stats::increment_player_stat( "planted_buildables_pickedup" );
	}

	if ( !( isdefined( self.craftable_pickedup_timer ) && self.craftable_pickedup_timer ) )
	{
		self say_pickup_craftable_vo( equipment, true );
		self thread craftable_pickedup_timer();
	}
}


//for things attached (stuff on the bus, etc..)
function track_placed_craftables( craftable_name )
{
	if ( !isdefined( craftable_name ) )
	{
		return;
	}

	self add_map_craftable_stat( craftable_name, "buildable_placed", 1 );

	vo_name = undefined;

	if ( craftable_name == level.riotshield_name )
	{
		vo_name = "craft_plc_shield";
	}

	if ( !isdefined( vo_name ) )
	{
		return;
	}

	self thread zm_utility::do_player_general_vox( "general", vo_name );

}


function add_map_craftable_stat( piece_name, stat_name, value )
{
	if ( !isdefined( piece_name ) || ( piece_name == "sq_common" ) || ( piece_name == "keys_zm" ) )
	{
		return;
	}

	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) || ( isdefined( level.zm_disable_recording_buildable_stats ) && level.zm_disable_recording_buildable_stats ) )
	{
		return;
	}

	self AddDStat( "buildables", piece_name, stat_name, value );

}

function say_pickup_craftable_vo( craftable_name, b_world )
{
//	if(IS_TRUE(self.craftable_pickedup_timer))
//	{
//		return;
//	}
//	name = get_craftable_vo_name(craftable_name);
//
//	if(!isdefined(name))
//	{
//		return;
//	}
//
//	vo_name = "craft_pck_b" + name;
//	if(IS_TRUE(b_world))
//	{
//		vo_name = "craft_pck_w" + name;
//	}
//
//	if(!isdefined(level.transit_craftable_vo_override) || !self [[level.transit_craftable_vo_override]](name,b_world) )
//	{
//		self thread zm_utility::do_player_general_vox( "general",vo_name );
//		self thread craftable_pickedup_timer();
//	}
}

function get_craftable_vo_name( craftable_name )
{
//	switch(craftable_name)
//	{
//		case "equip_turbine_zm": return "turbine";
//		case "equip_turret_zm":  return "turret";
//		case "equip_electrictrap_zm": return "trap";
//		case "riotshield_zm": return "shield";
//		case "jetgun_zm": return "jetgun";
//		case "equip_springpad_zm": return "springpad_zm";
//		case "equip_slipgun_zm": return "slipgun_zm";
//
//	}
//	return undefined;
}

function get_craftable_stat_name( craftable_name )
{
	if ( isdefined( craftable_name ) )
	{
		switch ( craftable_name )
		{
			case "equip_riotshield_zm":
				return "riotshield_zm";

			case "equip_turbine_zm":
				return "turbine";

			case "equip_turret_zm":
				return "turret";

			case "equip_electrictrap_zm":
				return "electric_trap";

			case "equip_springpad_zm":
				return "springpad_zm";

			case "equip_slipgun_zm":
				return "slipgun_zm";
		}
	}

	return craftable_name;
}


//
//	Return the model entity on the craftable table, if one exists.
function get_craftable_model( str_craftable )
{
	foreach ( uts_craftable in level.a_uts_craftables )
	{
		if ( uts_craftable.craftableStub.name == str_craftable )
		{
			if ( isdefined( uts_craftable.model ) )
			{
				return uts_craftable.model;
			}

			break;
		}
	}

	return undefined;
}


//
//	Returns the craftable pieceSpawn, if one exists.
function get_craftable_piece( str_craftable, str_piece )
{
	foreach ( uts_craftable in level.a_uts_craftables )
	{
		if ( uts_craftable.craftableStub.name == str_craftable )
		{
			foreach ( pieceSpawn in uts_craftable.craftableSpawn.a_pieceSpawns )
			{
				if ( pieceSpawn.pieceName == str_piece )
				{
					return pieceSpawn;
				}
			}

			break;
		}
	}

	return undefined;
}


//
//	Give the player the piece specified, as if he picked it up
//	self is a player
function player_get_craftable_piece( str_craftable, str_piece )
{
	pieceSpawn = get_craftable_piece( str_craftable, str_piece );

	if ( isdefined( pieceSpawn ) )
	{
		self player_take_piece( pieceSpawn );
	}
}

//
//	Take the specified craftable piece away from the player
//	self is a player
function player_remove_craftable_piece( str_craftable, str_piece )
{
	pieceSpawn = get_craftable_piece( str_craftable, str_piece );

	if ( isdefined( pieceSpawn ) )
	{
		self player_remove_piece( pieceSpawn );
	}
}

// remove piece from player and reset the player's craftable clientfield - only does this, and does NOT spawn the piece back into the world
function player_remove_piece( piece_to_remove )
{
	if(!isdefined(self.current_craftable_pieces))self.current_craftable_pieces=[];

	foreach ( slot, self_piece in self.current_craftable_pieces )
	{
		if( piece_to_remove.pieceName === self_piece.pieceName && piece_to_remove.craftableName === self_piece.craftableName )
		{
			self clientfield::set_to_player( "craftable", 0 );
			self_piece = undefined;
			self notify( "craftable_piece_released" + slot );
		}
	}
}

//
//	Returns the model entity for a craftable, if one exists.
function get_craftable_piece_model( str_craftable, str_piece )
{
	foreach ( uts_craftable in level.a_uts_craftables )
	{
		if ( uts_craftable.craftableStub.name == str_craftable )
		{
			foreach ( pieceSpawn in uts_craftable.craftableSpawn.a_pieceSpawns )
			{
				if ( pieceSpawn.pieceName == str_piece && isdefined( pieceSpawn.model ) )
				{
					return pieceSpawn.model;
				}
			}

			break;
		}
	}

	return undefined;
}

/#

function run_craftables_devgui()
{
	SetDvar( "give_craftable", "" );
	SetDvar( "goto_craftable", "" );
	SetDvar( "goto_craft_table", "" );
	SetDvar( "give_craftable_equipment", "" );

	while ( true )
	{
		craftable_id = GetDvarString( "give_craftable" );

		if ( craftable_id != "" )
		{
			a_toks = StrTok( craftable_id, ":" );
			
			craftable_id = a_toks[0];
			n_player = ( isdefined( a_toks[1] ) ? Int( a_toks[1] ): 0 );
			
			piece_spawn = level.cheat_craftables[craftable_id].piecespawn;

			if ( isdefined( piece_spawn ) )
			{
				player = level.players[ n_player ];
				
				if ( isdefined( player ) )
				{				
					player thread player_take_piece( piece_spawn );
				}
			}

			SetDvar( "give_craftable", "" );
		}

		equipment_id = GetDvarString( "give_craftable_equipment" );

		if ( equipment_id != "" )
		{
			foreach ( player in GetPlayers() )
			{
				if ( zm_equipment::is_included( equipment_id ) )
				{
					player zm_equipment::buy( equipment_id );
				}
			}

			SetDvar( "give_craftable_equipment", "" );
		}

		craftable_id = GetDvarString( "goto_craftable", "" );

		if ( craftable_id != "" )
		{
			piece_spawn = level.cheat_craftables[craftable_id].piecespawn;
			
			if ( isdefined( piece_spawn.model ) )
			{
				v_pos = piece_spawn.model.origin;
			}
			else
			{
				v_pos = piece_spawn.start_origin;
			}

			queryResult = PositionQuery_Source_Navigation( v_pos, 100, 200, 200, 15 );

			if ( queryResult.data.size )
			{
				point = array::get_closest( v_pos, queryResult.data );

				level.players[0] SetOrigin( point.origin );
				level.players[0] SetPlayerAngles( VectorToAngles( v_pos - point.origin ) );
			}
			else
			{
				iPrintLnBold( "Error finding spot near piece. No navmesh?" );
			}

			SetDvar( "goto_craftable", "" );
		}
		
		craftable_id = GetDvarString( "goto_craft_table", "" );

		if ( craftable_id != "" )
		{
			a_tables = [];
			foreach ( unitrigger_stub in level.a_uts_craftables )
			{
				if ( unitrigger_stub.equipname === craftable_id )
				{
					if ( !isdefined( a_tables ) ) a_tables = []; else if ( !IsArray( a_tables ) ) a_tables = array( a_tables ); a_tables[a_tables.size]=unitrigger_stub;;
				}
			}
			
			if ( a_tables.size )
			{
				v_pos = array::get_closest( level.players[0].origin, a_tables ).origin;
	
				queryResult = PositionQuery_Source_Navigation( v_pos, 100, 200, 200, 15 );
	
				if ( queryResult.data.size )
				{
					point = array::get_closest( v_pos, queryResult.data );
	
					level.players[0] SetOrigin( point.origin );
					level.players[0] SetPlayerAngles( VectorToAngles( v_pos - point.origin ) );
				}
				else
				{
					iPrintLnBold( "Error finding spot near piece. No navmesh?" );
				}
	
				SetDvar( "goto_craft_table", "" );
			}
		}

		wait 0.05;
	}
}

#/

/#

function add_craftable_cheat( craftable )
{
	{wait(.05);};
	level flag::wait_till( "start_zombie_round_logic" );
	{wait(.05);};

	if ( !isdefined( level.cheat_craftables ) )
	{
		level.cheat_craftables = [];
	}

	if ( isdefined( craftable.weaponname ) )
	{
		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/Give:0\" \"set give_craftable_equipment " + craftable.weaponname + "\"\n";
		AddDebugCommand( str_cmd );
	}

	// No pieces?  No devgui.
	//
	if ( !isdefined( craftable.a_piecestubs ) )
	{
		return;
	}

	foreach ( s_piece in craftable.a_piecestubs )
	{
		id_string = undefined;
		client_field_val = undefined;

		if ( isdefined( s_piece.client_field_id ) )
		{
			id_string = s_piece.client_field_id;
			client_field_val = id_string;
		}
		else if ( isdefined( s_piece.piecename ) )
		{
			id_string = s_piece.piecename;
			client_field_val = s_piece.piecename;
		}
		else if ( isdefined( s_piece.client_field_state ) )
		{
			id_string = "gem";
			client_field_val = s_piece.client_field_state;
		}
		else
		{
			continue;
		}

		tokens = StrTok( id_string, "_" );

		display_string = "piece";

		foreach ( token in tokens )
		{
			// Shorten the name so it'll fit correctly into the devgui.
			if ( token != "piece" && token != "zm" )
			{
				display_string = display_string + "_" + token;
			}
		}

		level.cheat_craftables[ "" + client_field_val ] = s_piece;

		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/" + display_string + "/Give Piece/Player 1\" \"give_craftable " + client_field_val + ":0\"\n";
		AddDebugCommand( str_cmd );
		
		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/" + display_string + "/Give Piece/Player 2\" \"give_craftable " + client_field_val + ":1\"\n";
		AddDebugCommand( str_cmd );
		
		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/" + display_string + "/Give Piece/Player 3\" \"give_craftable " + client_field_val + ":2\"\n";
		AddDebugCommand( str_cmd );
		
		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/" + display_string + "/Give Piece/Player 4\" \"give_craftable " + client_field_val + ":3\"\n";
		AddDebugCommand( str_cmd );
		

		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/" + display_string + "/GOTO Piece\" \"goto_craftable " + client_field_val + "\"\n";
		AddDebugCommand( str_cmd );
		
		str_cmd = "devgui_cmd \"ZM/Craftables/" + craftable.name + "/" + display_string + "/GOTO Table\" \"goto_craft_table " + s_piece.craftablename + "\"\n";
		AddDebugCommand( str_cmd );

		s_piece.waste = "waste";
	}
}

#/
