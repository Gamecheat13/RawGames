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
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             
                                                                                       	                                
                                                                                                                               

#precache( "string", "ZOMBIE_BUILDING" );
#precache( "string", "ZOMBIE_BUILD_PIECE_MISSING" );
#precache( "string", "ZOMBIE_BUILD_PIECE_GRAB" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_buildable_assemble_dust" );

#namespace zm_buildables;

function autoexec __init__sytem__() {     system::register("zm_buildables",&__init__,&__main__,undefined);    }

function __init__()
{
	// Allow Players To Swap Carry Pieces
	//-----------------------------------
	level.gameObjSwapping = true;
	
	zombie_buildables_callbacks = [];

	level.buildablePickUps = [];
	level.buildables_built = [];
	level.buildable_stubs = [];
	level.zombie_include_buildables = [];
	level.zombie_buildables = [];
	
	level.buildable_piece_count = 0; // it's value will be set in level specific gsc file, like zm_transit_buildables.gsc;

	level._effect["building_dust"]				= "_t6/maps/zombie/fx_zmb_buildable_assemble_dust";
}

function __main__()
{	
	// DT 101314 Zombies have difficulty attacking players that are clipping into large buildable pieces
	if (isdefined(level.use_swipe_protection))
	{
		callback::on_connect( &buildables_watch_swipes );
	}
	
	level thread think_buildables();	
}

function anystub_update_prompt( player )
{
	//no buildable trigger can be used while in last stand or if you could be reviving someone
	if ( player laststand::player_is_in_laststand() || player zm_utility::in_revive_trigger())
	{
		self.hint_string = "";
		return false;
	}
	if( player isThrowingGrenade() )
	{
		self.hint_string = "";
		return false;
	}
	if( isdefined(player.is_drinking) && ( player.is_drinking > 0 ) )
	{
		self.hint_string = "";
		return false;
	}
	return true;
} 

function anystub_get_unitrigger_origin()
{
	if (isdefined(self.origin_parent))
		return self.origin_parent.origin;
	return self.origin;
}

function anystub_on_spawn_trigger( trigger )
{
	if ( isdefined(self.link_parent))
	{
		trigger EnableLinkTo();
		trigger LinkTo( self.link_parent );
		trigger SetMovingPlatformEnabled( true );
	}
}

function buildables_watch_swipes()
{
	self endon("disconnect");
	self notify("buildables_watch_swipes");
	self endon("buildables_watch_swipes");
	
	while(1)
	{
		self waittill("melee_swipe", zombie);
		if (distancesquared(zombie.origin,self.origin) > zombie.meleeattackdist*zombie.meleeattackdist )
			continue; // just flailing at nothing
		trigger = level._unitriggers.trigger_pool[self GetEntityNumber()];
		if (isdefined(trigger) && isdefined(trigger.stub.piece))
		{
			piece = trigger.stub.piece;
			if (!isdefined(piece.damage))
				piece.damage = 0;
			piece.damage++;
			if (piece.damage > 12)
			{
				thread zm_equipment::disappear_fx( trigger.stub zm_unitrigger::unitrigger_origin() );
				piece zm_buildables::piece_unspawn();
				self zm_stats::increment_client_stat( "cheat_total",false );
				if( IsAlive( self ) )
				{
					self playlocalsound( level.zmb_laugh_alias );
				}
			}
	
		}
	}

}


function ExplosionDamage( damage, pos )
{
	/# println( "ZM BUILDABLE Explode do "+damage+" damage to "+self.name+"\n"); #/
	self DoDamage( damage, pos ); 
}


function add( buildable_name, hint, building, bought )
{
	if( IsDefined( level.zombie_include_buildables ) && !IsDefined( level.zombie_include_buildables[ buildable_name ] ) )
	{
		return;
	}

	buildable_struct = level.zombie_include_buildables[ buildable_name ];

	buildable_struct.hint = hint;
	buildable_struct.building = building;
	buildable_struct.bought = bought;

/#	PrintLn( "ZM >> Looking for buildable - " + buildable_struct.name );	#/

	level.zombie_buildables[ buildable_struct.name ] = buildable_struct;

	if ( level.zombie_buildables.size == 1 )
	{
		register_clientfields();
	}
}

function register_clientfields()
{
	if (IsDefined(level.buildable_slot_count))
	{
		for (i=0; i<level.buildable_slot_count; i++)
		{
			bits = GetMinBitCountForNum(level.buildable_piece_counts[i]);
			clientfield::register( "toplayer", level.buildable_clientfields[i], 1, bits, "int" );
		}
	}
	else
	{
		bits = GetMinBitCountForNum(level.buildable_piece_count);
		clientfield::register( "toplayer", "buildable", 1, bits, "int" );
	}
}

function set_buildable_clientfield( slot, newvalue )
{
	if ( level.zombie_buildables.size == 0 )
	{
		return;
	}

	if (IsDefined(level.buildable_slot_count))
	{
		self clientfield::set_to_player( level.buildable_clientfields[slot], newvalue );
	}
	else
	{
		self clientfield::set_to_player( "buildable", newvalue );
	}
}

function clear_buildable_clientfield( slot )
{
	if ( level.zombie_buildables.size == 0 )
	{
		return;
	}
	
	self set_buildable_clientfield( slot, 0 ); 
}

function get_all_included_buildables()
{
	return level.zombie_include_buildables;
}

function get_included_buildable( name )
{
	if ( IsDefined( level.zombie_include_buildables ) && IsDefined( level.zombie_include_buildables[ name ] ) )
	{
		return level.zombie_include_buildables[ name ];
	}
	return undefined;
}

function include( buildable_struct )
{
	if ( !IsDefined( level.zombie_include_buildables ) )
	{
		level.zombie_include_buildables = [];
	}

/#	PrintLn( "ZM >> Including buildable - " + buildable_struct.name );		#/

	level.zombie_include_buildables[ buildable_struct.name ] = buildable_struct;
}

function generate_zombie_buildable_piece( buildablename, modelName, radius, height, drop_offset, hud_icon, onPickup, onDrop, use_spawn_num, part_name, can_reuse, client_field_state, buildable_slot )
{
	piece = spawnstruct();

	buildable_pieces = [];

	buildable_pieces_structs = struct::get_array( buildablename + "_" + modelName, "targetname" );

	/#
	if ( buildable_pieces_structs.size < 1 )
	{
		println("ERROR: Missing buildable piece <"+buildablename+"> <"+modelName+">\n");
	}
	#/
	
	foreach( index, struct in buildable_pieces_structs )
	{
		buildable_pieces[ index ] = struct;
		buildable_pieces[ index ].hasSpawned = false;
	}

	piece.spawns = buildable_pieces;
	
	piece.buildableName = buildableName;
	piece.modelName = modelName;
	piece.hud_icon = hud_icon;
	piece.radius = radius;
	piece.height = height;
	piece.part_name = part_name;
	piece.can_reuse = can_reuse;
	piece.drop_offset = drop_offset;
	piece.max_instances = 256;
	if (IsDefined(buildable_slot))
		piece.buildable_slot = buildable_slot;
	else
		piece.buildable_slot = 0;
	
	piece.onPickup = onPickup;
	piece.onDrop = onDrop;
	piece.use_spawn_num = use_spawn_num;
	piece.client_field_state = client_field_state;

	return piece;
}

function manage_multiple_pieces( max_instances, min_instances )
{
	self.max_instances = max_instances;
	self.min_instances = min_instances;
	self.managing_pieces = true; 
	self.piece_allocated = [];
}

// When the buildable spawns in, use this script struct for the spawn location (if defined)
function buildable_set_force_spawn_location( str_kvp, str_name  )
{
	self.str_force_spawn_kvp = str_kvp;
	self.str_force_spawn_name = str_name;
}

// Do we want to clcle through the possible spawn locations for the buildable piece?
function buildable_use_cyclic_spawns( randomize_start_location )
{
	self.use_cyclic_spawns = true;
	self.randomize_cyclic_index = randomize_start_location;
}

function combine_buildable_pieces( piece1, piece2, piece3 )
{
	spawns1 = piece1.spawns;
	spawns2 = piece2.spawns;

	spawns = ArrayCombine( spawns1, spawns2, true, false );

	if (isdefined(piece3))
	{
		spawns3 = piece3.spawns;
		spawns = ArrayCombine( spawns, spawns3, true, false );
		spawns = array::randomize( spawns );
		
		// add piece 4 here if needed
		
		piece3.spawns = spawns;
	}
	else
		spawns = array::randomize( spawns );

	piece1.spawns = spawns;
	piece2.spawns = spawns;
}

function add_piece( piece, part_name, can_reuse )
{
	if ( !IsDefined( self.buildablePieces ) )
	{
		self.buildablePieces = [];
	}

	//self.buildablePieces = ArrayCombine( self.buildablePieces, piece.spawns, true, false );
	if (isdefined(part_name))
		piece.part_name = part_name;
	if (isdefined(can_reuse))
		piece.can_reuse = can_reuse;
	self.buildablePieces[self.buildablePieces.size] = piece;
	if (!IsDefined(self.buildable_slot))
	{
		self.buildable_slot = piece.buildable_slot;
	}
	else
	{
	/#
		assert(self.buildable_slot == piece.buildable_slot);
	#/
	}
}

function create_piece( modelName, radius, height, hud_icon )
{
	/#	println( "ZM >> create_zombie_buildable_piece = " + modelName );	#/
	piece = generate_zombie_buildable_piece( self.name, modelName, radius, height, hud_icon );
	self add_piece( piece );
}


function onPlayerLastStand()
{
	pieces = self player_get_buildable_pieces();
	spawn_pos = [];
	spawn_pos[0] = self.origin;
	if ( pieces.size >= 2 )
	{
		nodes = GetNodesInRadiusSorted( self.origin + (0,0,30), 120, 30, 72, "path", 5 );
		for ( i =0; i<pieces.size; i++ )
		{
			if (i<nodes.size && zm_utility::check_point_in_playable_area( nodes[i].origin ) )
				spawn_pos[i] = nodes[i].origin;
			else
				spawn_pos[i] = self.origin+(5,5,0);
		}
	}
		
	spawnidx = 0;
	foreach( piece in pieces)
	{
		slot = piece.buildable_slot;
		if (isdefined(piece))
		{
			/*
			speed = 125;
			ang = RandomFloat(360);
			h = 0.25 + RandomFloat(0.5);
			dir = ( Sin(ang), Cos(ang), h );
			self thread player_throw_piece( piece, self.origin, speed * dir, true, 120, (0,0,0));
			*/
		
			return_to_start_pos = false;
		
			if (isdefined(level.safe_place_for_buildable_piece))
			{
				if (! self [[level.safe_place_for_buildable_piece]]( piece ) )
					return_to_start_pos = true;
			}
		
			if ( return_to_start_pos )
				piece piece_spawn_at();
			else if (pieces.size <2)
				piece piece_spawn_at(self.origin+(5,5,0),self.angles);
			else
				piece piece_spawn_at(spawn_pos[spawnidx],self.angles);
				
			if ( IsDefined( piece.onDrop ) )
				piece [[ piece.onDrop ]]( self );
		
			self clear_buildable_clientfield( slot );
			spawnidx++;
		}
		self player_set_buildable_piece( undefined, slot );
		self notify("piece_released" + slot);
	}
}

// place the unitrigger a few inches above the origin to avoid LOS issues with the ground


function piecestub_get_unitrigger_origin()
{
	if (isdefined(self.origin_parent))
		return self.origin_parent.origin + (0,0,12);
	return self.origin;
}

function generate_piece_unitrigger( classname, origin, angles, flags, radius, script_height, moving )
{
	if(!isdefined(radius))
	{
		radius = 64;
	}
	
	if(!isdefined(script_height))
	{
		script_height = 64;
	}
	
	script_width = script_height;
	if(!isdefined(script_width))
	{
		script_width = 64;
	}

	script_length = script_height;
	if(!isdefined(script_length))
	{
		script_length = 64;
	}


	unitrigger_stub = spawnstruct();

	unitrigger_stub.origin = origin;
	//unitrigger_stub.angles = trig.angles;

	if(isdefined(script_length))
	{
		unitrigger_stub.script_length = script_length;
	}
	else
	{
		unitrigger_stub.script_length = 13.5;
	}
		
	if(isdefined(script_width))
	{
		unitrigger_stub.script_width = script_width;
	}
	else
	{
		unitrigger_stub.script_width = 27.5;
	}
		
	if(isdefined(script_height))
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
	unitrigger_stub.hint_string = &"ZOMBIE_BUILD_PIECE_GRAB";
		
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = true; 

	switch(classname)
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

	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, true);
	unitrigger_stub.prompt_and_visibility_func = &piecetrigger_update_prompt;
	unitrigger_stub.originFunc = &piecestub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;

	if (( isdefined( moving ) && moving ))
		zm_unitrigger::register_unitrigger(unitrigger_stub, &piece_unitrigger_think);
	else
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &piece_unitrigger_think);

	return unitrigger_stub;
}


function piecetrigger_update_prompt( player )
{
	can_use = self.stub piecestub_update_prompt( player );
	self setInvisibleToPlayer( player, !can_use );
	if(isdefined(self.stub.hint_parm1))
	{
		self SetHintString( self.stub.hint_string, self.stub.hint_parm1 );
	}
	else
	{
		self SetHintString( self.stub.hint_string );
	}
	if(isdefined(self.stub.cursor_hint))
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && IsDefined(self.stub.cursor_hint_weapon) )
			self SetCursorHint(self.stub.cursor_hint,self.stub.cursor_hint_weapon);	
		else
			self SetCursorHint(self.stub.cursor_hint);	
	}
	return can_use;
}

function piecestub_update_prompt( player )
{
	if (!self anystub_update_prompt( player ))
	{
		self.cursor_hint = "HINT_NOICON";
		return false;
	}
	if (isdefined(player player_get_buildable_piece(self.piece.buildable_slot)))
	{
		spiece = self.piece; 
		cpiece = player player_get_buildable_piece(self.piece.buildable_slot);
		if ( spiece.modelname == cpiece.modelname && spiece.buildablename == cpiece.buildablename && ( !IsDefined(spiece.script_noteworthy) || !IsDefined(cpiece.script_noteworthy) || spiece.script_noteworthy == cpiece.script_noteworthy ) )
		{
			self.hint_string = "";
			return false;
		}
		if ( isdefined(spiece.hint_swap) )
		{
			self.hint_string = spiece.hint_swap;
			self.hint_parm1 = self.piece.hint_swap_parm1;
		}
		else
			self.hint_string = &"ZOMBIE_BUILD_PIECE_SWITCH";
		if ( isdefined(self.piece.cursor_hint) )
			self.cursor_hint = self.piece.cursor_hint;
		if ( isdefined(self.piece.cursor_hint_weapon) )
			self.cursor_hint_weapon = self.piece.cursor_hint_weapon;
	}
	else
	{
		if ( isdefined(self.piece.hint_grab) )
		{
			self.hint_string = self.piece.hint_grab;
			self.hint_parm1 = self.piece.hint_grab_parm1;
		}
		else
			self.hint_string = &"ZOMBIE_BUILD_PIECE_GRAB";
		if ( isdefined(self.piece.cursor_hint) )
			self.cursor_hint = self.piece.cursor_hint;
		if ( isdefined(self.piece.cursor_hint_weapon) )
			self.cursor_hint_weapon = self.piece.cursor_hint_weapon;
	}
	return true;
} 

function piece_unitrigger_think()
{
	self endon("kill_trigger");

	while ( 1 )
	{
		self waittill( "trigger", player );
	
		if (player != self.parent_player)
			continue; 
		
		if( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		status = player player_can_take_piece(self.stub.piece);

		if (!status)
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );
		}
		else
		{
			player thread player_take_piece(self.stub.piece);
			// player_take_piece will end this thread
		}
	}
}

function player_get_buildable_pieces()
{
	if (!IsDefined(self.current_buildable_pieces))
		self.current_buildable_pieces=[];
	return self.current_buildable_pieces;
}

function player_get_buildable_piece( slot = 0 )
{
	if (!IsDefined(self.current_buildable_pieces))
		self.current_buildable_pieces=[];
	return self.current_buildable_pieces[slot];
}

function player_set_buildable_piece( piece, slot = 0 )
{
	/#
	if (IsDefined(slot) && IsDefined(piece) && IsDefined(piece.buildable_slot))
	{
		assert(slot == piece.buildable_slot);
	}
	#/
	if (!IsDefined(self.current_buildable_pieces))
		self.current_buildable_pieces=[];
	self.current_buildable_pieces[slot] = piece;
}

function player_can_take_piece( piece )
{
	if (!isdefined(piece))
		return 0; 

	// okay to take
	return 1;
}

/#
function DBLine( from, to )
{
	time = 20; 
	while (time > 0)
	{
		Line( from, to, (0,0,1), false, 1);
		time -= 0.05;
		{wait(.05);};
	}
}
#/


function player_throw_piece( piece, origin, dir, return_to_spawn, return_time, endangles )
{
	assert(isdefined(piece));
	if (isdefined(piece))
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
			if (!isdefined(altmodel))
			{
				altmodel = spawn( "script_model", grenade.origin );
				altmodel SetModel( piece.modelName );
			}
			altmodel.origin = grenade.angles;
			altmodel.angles = grenade.angles;
			altmodel linkTo( grenade,"",(0,0,0),(0,0,0) );
			grenade.altmodel = altmodel;
			
			grenade waittill("stationary");
		
			grenade_origin = grenade.origin;
			grenade_angles = grenade.angles;
			
			landed_on = grenade GetGroundEnt();
			
			grenade delete();
			
			if ( IsDefined(landed_on) && landed_on == level )
			{
				done = 1;
			}
			else
			{
				origin = grenade_origin;
				dir = (-dir[0]/10,-dir[1]/10,-1);
				pass++;
			}
		}
		
		if (!isdefined(endangles))
			endangles = grenade_angles;
		piece piece_spawn_at(grenade_origin, endangles); 
		if (isdefined(altmodel))
			altmodel delete();
		if ( IsDefined( piece.onDrop ) )
			piece [[ piece.onDrop ]]( self );
		if (( isdefined( return_to_spawn ) && return_to_spawn ))
			piece piece_wait_and_return( return_time );
	}
}

function watch_hit_players()
{
	self endon("death");
	self endon("stationary");
	while(isdefined(self))
	{
		self waittill("grenade_bounce",pos,normal,ent);
		if (IsPlayer(ent))
		{
			ent ExplosionDamage( 25, pos );
		}
	}
}



function piece_wait_and_return( return_time )
{
	self endon("pickup");
	wait 0.15;
	if (isdefined(level.exploding_jetgun_fx))
		PlayFxOnTag( level.exploding_jetgun_fx, self.model, "tag_origin" );
	else	
		PlayFxOnTag( level._effect["powerup_on"], self.model, "tag_origin" );
	wait return_time-6;
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
	self notify("respawn");
	self piece_unspawn();
	self piece_spawn_at();
}

function player_return_piece_to_original_spawn( slot = 0 )
{
	self notify("piece_released" + slot);
	piece = self player_get_buildable_piece(slot);
	self player_set_buildable_piece( undefined, slot );
	if (isdefined(piece))
	{
		piece piece_spawn_at();

		self clear_buildable_clientfield( slot );
		
	}
}

function player_drop_piece_on_death( slot )
{
	self notify("piece_released"+slot);
	self endon("piece_released"+slot);

	origin = self.origin;
	angles = self.angles;
	piece = self player_get_buildable_piece(slot);
	self waittill("death_or_disconnect");
	piece piece_spawn_at(origin,angles);
	if (isdefined(self))
		self clear_buildable_clientfield( slot );
	if ( IsDefined( piece.onDrop ) )
		piece [[ piece.onDrop ]]( self );
}


function player_drop_piece( piece, slot = 0 )
{
	if (!isdefined(piece))
		piece = self player_get_buildable_piece(slot);
	else
		slot = piece.buildable_slot;
	if (isdefined(piece))
	{
		origin = self.origin;
		
		// Ensure piece is dropped to the ground
		originTrace = GroundTrace( origin + ( 0, 0, 5 ), origin - ( 0, 0, 999999 ), false, self );
		
		// Second trace if player is already standing on top of a buildable piece
		if ( IsDefined( originTrace[ "entity" ] ) )
		{
			originTrace = GroundTrace( originTrace[ "entity" ].origin, originTrace[ "entity" ].origin - ( 0, 0, 999999 ), false, originTrace[ "entity" ] );
		}
		
		// Set the buildable piece to spawn at ground level
		if ( IsDefined( originTrace[ "position" ] ) )
		{
			origin = originTrace[ "position" ];
		}
		
		piece.damage = 0;
		piece piece_spawn_at(origin,self.angles);

		if ( isplayer( self ) )
			self clear_buildable_clientfield( slot );

		if ( IsDefined( piece.onDrop ) )
			piece [[ piece.onDrop ]]( self );
	}
	self player_set_buildable_piece( undefined, slot );
	self notify("piece_released" + slot);
}

function player_take_piece( piece )
{
	piece_slot = piece.buildable_slot;
	damage = piece.damage;
	if (isdefined(self player_get_buildable_piece(piece_slot)))
	{
		other_piece = self player_get_buildable_piece(piece_slot);
		self player_drop_piece(self player_get_buildable_piece(piece_slot), piece_slot);
		other_piece.damage = damage;
		self zm_utility::do_player_general_vox("general","build_swap");
	}
	if ( IsDefined( piece.onPickup ) )
		piece [[ piece.onPickup ]]( self );

	piece piece_unspawn();
	piece notify("pickup");

	if ( isplayer( self ) )
	{
		if ( IsDefined(piece.client_field_state) )
		{
			self set_buildable_clientfield( piece_slot, piece.client_field_state );
		}
	
		self player_set_buildable_piece( piece, piece_slot );
		self thread player_drop_piece_on_death(piece_slot);
	
		// Stat tracking
		self track_buildable_piece_pickedup(piece);
	}
}

function player_destroy_piece( piece )
{
	if (!isdefined(piece))
	{
		piece = self player_get_buildable_piece();
	}

	if ( isplayer( self ) )
	{
		slot = piece.buildable_slot;
		if (isdefined(piece))
		{	
			piece piece_destroy();
			self clear_buildable_clientfield( slot );
		}

		self player_set_buildable_piece(undefined, slot);
		self notify("piece_released" + slot);
	}
}


function claim_location( location )
{
	if (!isdefined(level.buildable_claimed_locations))
		level.buildable_claimed_locations=[];
	if (!isdefined(level.buildable_claimed_locations[location]))
	{
		level.buildable_claimed_locations[location] = true;
		return true;
	}
	return false;
}

// This is VERY expensive - use sparingly 

function is_point_in_build_trigger( point )
{
	//active_zone_names = level.active_zone_names;//zm_zonemgr::get_active_zone_names();
	
	candidate_list = [];
	
	foreach (zone in level.zones)
	{
		if(isdefined(zone.unitrigger_stubs))
		{
			candidate_list = ArrayCombine(candidate_list, zone.unitrigger_stubs, true, false);
		}
	}

	// we don't care about the dynamic unitriggers	
	//candidate_list = ArrayCombine(candidate_list, level._unitriggers.dynamic_stubs, true, false);		
	valid_range = 128;

	closest = zm_unitrigger::get_closest_unitriggers( point, candidate_list, valid_range );

	index = 0; 
	
	while (index < closest.size)
	{
		if (( isdefined( closest[index].registered ) && closest[index].registered ) && IsDefined(closest[index].piece))
			return true;
		index++;
	}

	return false;	
}


function piece_allocate_spawn(piecespawn)
{
	self.current_spawn = 0;
	self.managed_spawn = true;
	self.piecespawn = piecespawn;

	// Do we want to force the spawn location entity?
	if( IsDefined(piecespawn.str_force_spawn_kvp) )
	{
		s_struct = struct::get( piecespawn.str_force_spawn_name, piecespawn.str_force_spawn_kvp );
		if( IsDefined(s_struct) )
		{
			for( i=0; i<self.spawns.size; i++ )
			{
				if( s_struct == self.spawns[i] )
				{
					self.current_spawn = i;
					piecespawn.piece_allocated[self.current_spawn] = true;
					piecespawn.str_force_spawn_kvp = undefined;
					piecespawn.str_force_spawn_name = undefined;
					return;	
				}
			}
		}
	}

	// Do we want to use cyclic spawns?
	if( IsDefined(piecespawn.use_cyclic_spawns) )
	{
		piece_allocate_cyclic( piecespawn );
		return;
	}
	
	// Pick a weighted location, note can pick same location as last try
	if ( self.spawns.size >= 1 && self.spawns.size > 1 )
	{
		any_good = false; 
		any_okay = false; 
		totalweight = 0; 
		spawnweights = [];
		for (i = 0; i<self.spawns.size; i++)
		{
			if ( ( isdefined( piecespawn.piece_allocated[i] ) && piecespawn.piece_allocated[i] ) )
			{
				spawnweights[i] = 0;
			}
			else if ( ( isdefined( self.spawns[i].script_forcespawn ) && self.spawns[i].script_forcespawn ) )
			{
				switch ( self.spawns[i].script_forcespawn )
				{
					case 4:
						spawnweights[i] = 0.0;
						break;
					case 1: 
						self.spawns[i].script_forcespawn = 0;
						//fall through
					case 2:
						self.current_spawn = i;
						piecespawn.piece_allocated[self.current_spawn] = true;
						return;	
					case 3:
						self.spawns[i].script_forcespawn = 4;
						self.current_spawn = i;
						piecespawn.piece_allocated[self.current_spawn] = true;
						return;	
					default: 
						// unknown force spawn flag
						any_okay = true; 
						spawnweights[i] = 0.01;
						break;
				}
			}
			else if( is_point_in_build_trigger( self.spawns[i].origin ) )
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
		
		if (any_good)
		{
			totalweight = float(int(totalweight));
		}
		r = RandomFloat( totalweight ); 
		for (i = 0; i<self.spawns.size; i++)
		{
			if( !any_good || spawnweights[i] >= 1.0 )
			{
				r -= spawnweights[i];
				if( r < 0 )
				{
					self.current_spawn = i;
					piecespawn.piece_allocated[self.current_spawn] = true;
					return;	
				}
			}
		}
		
		// should never get here
		self.current_spawn = RandomInt( self.spawns.size );
		piecespawn.piece_allocated[self.current_spawn] = true;
	}
}

function piece_allocate_cyclic( piecespawn )
{
	if( self.spawns.size > 1 )
	{
		// Randomzie the start index?
		if( IsDefined(piecespawn.randomize_cyclic_index) )
		{
			piecespawn.randomize_cyclic_index = undefined;
			piecespawn.cyclic_index = randomint( self.spawns.size );
		}
		// Make sure its initialized if we don;t want to randomize the start index
		if( !IsDefined(piecespawn.cyclic_index) )
		{
			piecespawn.cyclic_index = 0;
		}
		// Move to next location
		piecespawn.cyclic_index++;
		if( piecespawn.cyclic_index >= self.spawns.size )
		{
			piecespawn.cyclic_index = 0;
		}
	}
	else
	{
		piecespawn.cyclic_index = 0;
	}
	
	self.current_spawn = piecespawn.cyclic_index;
	piecespawn.piece_allocated[self.current_spawn] = true;
}

function piece_deallocate_spawn()
{
	if ( IsDefined(self.current_spawn) )
	{
		self.piecespawn.piece_allocated[self.current_spawn] = false;
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
		while ( isdefined(self.spawns[self.current_spawn].claim_location) && 
				!claim_location( self.spawns[self.current_spawn].claim_location ))
		{
			ArrayRemoveIndex( self.spawns, self.current_spawn );
			if ( self.spawns.size < 1 )
			{
				self.current_spawn = 0;
				/# println( "ERROR: All buildable spawn locations claimed" ); #/
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
		self.current_spawn = int(min(num,self.spawns.size-1));
	}
}

function piece_spawn_in(piecespawn)
{
	if (self.spawns.size < 1) 
		return;
	
	if (( isdefined( self.managed_spawn ) && self.managed_spawn ))
	{
		if (!isdefined(self.current_spawn))
			self piece_allocate_spawn(self.piecespawn);
	}
	
	if (!isdefined(self.current_spawn))
		self.current_spawn = 0;

	spawndef = self.spawns[self.current_spawn];
	self.script_noteworthy = spawndef.script_noteworthy;
	self.script_parameters = spawndef.script_parameters;

	self.unitrigger = generate_piece_unitrigger( "trigger_radius_use", spawndef.origin + (0,0,12), spawndef.angles, 0, piecespawn.radius, piecespawn.height, false );
	self.unitrigger.piece = self;

	self.buildable_slot = piecespawn.buildable_slot;	
	self.radius = piecespawn.radius;	
	self.height = piecespawn.height;	
	self.buildableName = piecespawn.buildableName;	
	self.modelName = piecespawn.modelName;	
	self.hud_icon = piecespawn.hud_icon;	
	self.part_name = piecespawn.part_name;
	self.drop_offset = piecespawn.drop_offset;
	self.start_origin = spawndef.origin;
	self.start_angles = spawndef.angles;
	self.client_field_state = piecespawn.client_field_state;
	self.hint_grab = piecespawn.hint_grab;
	self.hint_swap = piecespawn.hint_swap;
		
	self.model = Spawn( "script_model", self.start_origin );
	if (isdefined(self.start_angles))
		self.model.angles = self.start_angles;
	self.model SetModel( piecespawn.modelName );
	
	self.model GhostInDemo();
	self.model.hud_icon = piecespawn.hud_icon;
	self.piecespawn = piecespawn;

	self.unitrigger.origin_parent = self.model;
	
	self.building = undefined;
	// Cleanup the spawn structs? It would be nice
	//self.spawns = undefined;
	
	self.onUnSpawn = piecespawn.onUnSpawn;
	self.onDestroy = piecespawn.onDestroy;
	if ( IsDefined( piecespawn.onSpawn ) )
	{
		self.onSpawn = piecespawn.onSpawn;
		self [[ piecespawn.onSpawn ]]();
	}
}

function piece_spawn_at_with_notify_delay( origin, angles, str_notify, unbuild_respawn_fn )
{
	level waittill( str_notify );

	piece_spawn_at( origin, angles );

	if( IsDefined(unbuild_respawn_fn) )
	{
		self [[ unbuild_respawn_fn ]]();
	}
}

function piece_spawn_at(origin,angles)
{
	if (self.spawns.size < 1) 
		return;
	
	if (( isdefined( self.managed_spawn ) && self.managed_spawn ))
	{
		if (!isdefined(self.current_spawn) && !isdefined(origin) )
		{
			self piece_allocate_spawn(self.piecespawn);
			spawndef = self.spawns[self.current_spawn];
			self.start_origin = spawndef.origin;
			self.start_angles = spawndef.angles;
		}
	}
	else if (!isdefined(self.current_spawn))
		self.current_spawn = 0;

	unitrigger_offset = (0,0,12);
	
	if (!isdefined(origin))
		origin = self.start_origin;
	else
	{
		origin = origin + (0,0,self.drop_offset);
		unitrigger_offset -= (0,0,self.drop_offset);
	}
	if (!isdefined(angles))
		angles = self.start_angles;
	/#
		if (!isdefined(level.drop_offset))
			level.drop_offset=0;
		origin = origin + (0,0,level.drop_offset);
		unitrigger_offset -= (0,0,level.drop_offset);
	#/
	
		
		
	self.model = Spawn( "script_model", origin );
	if (isdefined(angles))
		self.model.angles = angles;
	self.model SetModel( self.modelName );
	
	if (isdefined(level.equipment_safe_to_drop))
	{
		if (! [[level.equipment_safe_to_drop]](self.model) )
		{
			origin = self.start_origin;
			angles = self.start_angles;
			self.model.origin = origin;
			self.model.angles = angles;
		}
	}
	
	self.unitrigger = generate_piece_unitrigger( "trigger_radius_use", origin + unitrigger_offset, angles, 0, self.radius, self.height, ( isdefined( self.model.canMove ) && self.model.canMove ) );
	self.unitrigger.piece = self;

	self.model.hud_icon = self.hud_icon;

	self.unitrigger.origin_parent = self.model;
	
	self.building = undefined;
	
	if ( IsDefined( self.onSpawn ) )
	{
		self [[ self.onSpawn ]]();
	}
}

function piece_unspawn()
{
	if ( IsDefined( self.onUnSpawn ) )
	{
		self [[ self.onUnSpawn ]]();
	}
	if (( isdefined( self.managed_spawn ) && self.managed_spawn ))
		self piece_deallocate_spawn();
	if (isdefined(self.model))
		self.model delete();
	self.model=undefined;
	if (isdefined(self.unitrigger))
		thread zm_unitrigger::unregister_unitrigger(self.unitrigger);
	self.unitrigger = undefined;
}

function piece_hide()
{	
	if (isdefined(self.model))
		self.model Ghost();
}

function piece_show()
{
	if (isdefined(self.model))
		self.model Show();
}

// the piece is not actually destroyed - it's just never available again
function piece_destroy()
{
	if ( IsDefined( self.onDestroy ) )
	{
		self [[ self.onDestroy ]]();
	}
}


function generate_piece( buildable_piece_spawns )
{
	piece = spawnstruct();
	piece.spawns = buildable_piece_spawns.spawns;

	if ( ( isdefined( buildable_piece_spawns.managing_pieces ) && buildable_piece_spawns.managing_pieces ) )
		piece piece_allocate_spawn( buildable_piece_spawns );
	else if ( isdefined(buildable_piece_spawns.use_spawn_num) )
		piece piece_set_spawn( buildable_piece_spawns.use_spawn_num );
	else
		piece piece_pick_random_spawn();
	piece piece_spawn_in(buildable_piece_spawns);
	if (piece.spawns.size >= 1) 
		piece.hud_icon = buildable_piece_spawns.hud_icon;
	if (isdefined(buildable_piece_spawns.onPickup))
		piece.onPickup = buildable_piece_spawns.onPickup;
	else
		piece.onPickup = &onPickupUTS;
	if (isdefined(buildable_piece_spawns.onDrop))
		piece.onDrop = buildable_piece_spawns.onDrop;
	else
		piece.onDrop = &onDropUTS;
	return piece;
}





function buildable_piece_unitriggers( buildable_name, origin )
{

	Assert( IsDefined( buildable_name ) );
	Assert( IsDefined( level.zombie_buildables[ buildable_name ] ), "Called buildable_think() without including the buildable - " + buildable_name );

	// Grab Buildable
	//---------------
	buildable = level.zombie_buildables[ buildable_name ];
	
	if ( !isdefined(buildable.buildablePieces) )
		buildable.buildablePieces=[];

	// Need To Wait For Some Scripts To Be Set Up Before Proceeding, Best Case Notify
	//-------------------------------------------------------------------------------
	level flag::wait_till( "start_zombie_round_logic" );
	
	buildableZone = spawnstruct();

	buildableZone.buildable_name = buildable_name;
	buildableZone.buildable_slot = buildable.buildable_slot;

	if (!isdefined(buildableZone.pieces))
		buildableZone.pieces=[];

	// Create A Carry Objects (One Per Each Type Currently)
	//----------------------------------------------------
	buildablePickUps = [];
	
	//foreach( buildablePieceModelArray in buildable.buildablePieces )
	foreach( buildablePiece in buildable.buildablePieces )
	{
		if (!IsDefined(buildablePiece.generated_instances))
			buildablePiece.generated_instances=0;
		// If this buildable is re-using parts from another buildable, use the previously generated piece
		if ( isdefined( buildablePiece.generated_piece ) && ( isdefined( buildablePiece.can_reuse ) && buildablePiece.can_reuse ) )
		{
			piece = buildablePiece.generated_piece;
		}
		else if ( buildablePiece.generated_instances >= buildablePiece.max_instances )
		{
			piece = buildablePiece.generated_piece;
		}
		else
		{
			piece = generate_piece( buildablePiece );
			buildablePiece.generated_piece=piece;
			buildablePiece.generated_instances++;
			if (isdefined(buildablePiece.min_instances))
			{
				while ( buildablePiece.generated_instances < buildablePiece.min_instances )
				{
					piece = generate_piece( buildablePiece );
					buildablePiece.generated_piece=piece;
					buildablePiece.generated_instances++;
				}
			}
		}

		buildableZone.pieces[buildableZone.pieces.size]=piece;
	}

	buildableZone.stub = self;
	
	return buildableZone;
}

function hide_buildable_table_model(trigger_targetname)
{
	trig = GetEnt( trigger_targetname, "targetname" );
	if ( !IsDefined( trig ) )
	{
		return;
	}
	if (isdefined(trig.target))
	{
		model = getent( trig.target, "targetname" ); 
		if(isdefined(model))
		{
			model hide(); 
			model NotSolid(); 
		}
	}
}

function setup_unitrigger_buildable( trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	trig = GetEnt( trigger_targetname, "targetname" );
	if ( !IsDefined( trig ) )
	{
		return;
	}
	return setup_unitrigger_buildable_internal( trig, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent );
}

function setup_unitrigger_buildable_array( trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	triggers = GetEntArray( trigger_targetname, "targetname" );
	stubs = [];
	foreach( trig in triggers )
	{
		stubs[stubs.size] = setup_unitrigger_buildable_internal( trig, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent );
	}
	return stubs;
}
	
	
function setup_unitrigger_buildable_internal( trig, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	if ( !IsDefined( trig ) )
	{
		return;
	}
	unitrigger_stub = spawnstruct();

	unitrigger_stub.buildableStruct = level.zombie_include_buildables[ buildable_name ]; //	level.zombie_buildables[ buildable_name ]

	angles = trig.script_angles;
	
	if(!isdefined(angles))
	{
		angles = (0,0,0);
	}
	
	unitrigger_stub.origin = trig.origin + (anglestoright(angles) * -6);
	
	unitrigger_stub.angles = trig.angles;
	if ( isdefined(trig.script_angles) )
		unitrigger_stub.angles = trig.script_angles;
	unitrigger_stub.buildable_name = buildable_name;
	unitrigger_stub.equipment = GetWeapon( equipment_name );
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.delete_trigger = delete_trigger;
	unitrigger_stub.built = false;
	unitrigger_stub.persistent = persistent;
	unitrigger_stub.useTime = int( 3 * 1000 );

	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;

	if(isdefined(trig.script_length))
	{
		unitrigger_stub.script_length = trig.script_length;
	}
	else
	{
		unitrigger_stub.script_length = 32; //24;
	}
		
	if(isdefined(trig.script_width))
	{
		unitrigger_stub.script_width = trig.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 100;
	}
		
	if(isdefined(trig.script_height))
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
	if (isdefined(level.zombie_buildables[ buildable_name ].hint))
		unitrigger_stub.hint_string = level.zombie_buildables[ buildable_name ].hint;
		
	unitrigger_stub.script_unitrigger_type  = "unitrigger_box_use";
	unitrigger_stub.require_look_at = true;

	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, true);
	unitrigger_stub.prompt_and_visibility_func = &buildabletrigger_update_prompt;

	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &buildable_place_think);
		
	unitrigger_stub.piece_trigger = trig;
	trig.trigger_stub = unitrigger_stub;

	unitrigger_stub.weapon = trig.weapon;
	if (isdefined(unitrigger_stub.target))
	{
		unitrigger_stub.model = getent( unitrigger_stub.target, "targetname" ); 
		if(isdefined(unitrigger_stub.model))
		{
			if (isdefined(unitrigger_stub.weapon))
				unitrigger_stub.model useweaponhidetags( unitrigger_stub.weapon );
			unitrigger_stub.model hide(); 
			unitrigger_stub.model NotSolid(); 
		}
	}


	// create buildable pieces
	unitrigger_stub.buildableZone = unitrigger_stub buildable_piece_unitriggers( buildable_name, unitrigger_stub.origin );
	
	if ( delete_trigger )
		trig delete();

	level.buildable_stubs[level.buildable_stubs.size]=unitrigger_stub;
	return unitrigger_stub;
}

function buildable_has_piece( piece )
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
			return true;
	return false;
}

function buildable_set_piece_built( piece )
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
		{
			self.pieces[i].built = true;
		}
}

function buildable_set_piece_building( piece )
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
		{
			self.pieces[i] = piece;
			self.pieces[i].building = true;
		}
}

function buildable_clear_piece_building( piece )
{
	/*
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
		{
			if ( self.pieces[i] == piece )
				self.pieces[i].building = false;
		}
		*/
	if (isdefined(piece))
		piece.building = false;
}

function buildable_is_piece_built( piece )
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
		{
			return ( isdefined( self.pieces[i].built ) && self.pieces[i].built );
		}
	return false;
}

function buildable_is_piece_building( piece )
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
		{
			return ( isdefined( self.pieces[i].building ) && self.pieces[i].building ) && self.pieces[i]==piece;
		}
	return false;
}

function buildable_is_piece_built_or_building( piece )
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( self.pieces[i].modelname == piece.modelname && self.pieces[i].buildablename == piece.buildablename )
		{
			return ( isdefined( self.pieces[i].built ) && self.pieces[i].built ) || ( isdefined( self.pieces[i].building ) && self.pieces[i].building );
		}
	return false;
}

function buildable_all_built()
{
	for ( i=0; i<self.pieces.size; i++ )
		if ( !( isdefined( self.pieces[i].built ) && self.pieces[i].built ) )
			return false;
	return true;
}

function player_can_build( buildable, continuing )
{
	if (!isdefined(buildable))
		return 0;
	
	if (!isdefined(self player_get_buildable_piece(buildable.buildable_slot)))
		return 0;
	
	if (!buildable buildable_has_piece(self player_get_buildable_piece(buildable.buildable_slot)))
		return 0;

	if (( isdefined( continuing ) && continuing ))
	{
		if ( buildable buildable_is_piece_built(self player_get_buildable_piece(buildable.buildable_slot)))
		return 0;
	}
	else
	{
		if (buildable buildable_is_piece_built_or_building(self player_get_buildable_piece(buildable.buildable_slot)))
			return 0;
	}
	
	if ( IsDefined( buildable.stub ) && IsDefined( buildable.stub.custom_buildablestub_update_prompt ) && IsDefined( buildable.stub.playertrigger[0] ) && IsDefined( buildable.stub.playertrigger[0].stub ) && ! buildable.stub.playertrigger[ 0 ].stub [[ buildable.stub.custom_buildablestub_update_prompt ]]( self, true, buildable.stub.playertrigger[ 0 ] ) )
		return 0;
	
	// okay to build
	return 1;
}

function player_build( buildable, pieces )
{
	if ( isdefined( pieces ) )
	{
		for ( i = 0; i < pieces.size; i++ )
		{
			buildable buildable_set_piece_built( pieces[i] );
			player_destroy_piece( pieces[i] );
		}
	}
	else
	{
		buildable buildable_set_piece_built( self player_get_buildable_piece(buildable.buildable_slot) );
		player_destroy_piece( self player_get_buildable_piece(buildable.buildable_slot) );
	}

	if(isdefined(buildable.stub.model))
	{
		for ( i=0; i<buildable.pieces.size; i++ )
			if (isdefined( buildable.pieces[i].part_name ) )
			{
				buildable.stub.model NotSolid(); 
				if ( !( isdefined( buildable.pieces[i].built ) && buildable.pieces[i].built ) )
				{
					buildable.stub.model HidePart( buildable.pieces[i].part_name ); 
				}
				else
				{
					buildable.stub.model show(); 
					buildable.stub.model ShowPart( buildable.pieces[i].part_name ); 
				}
			}
	}
	
	if ( isplayer( self ) )
	{
		//stat tracking
		self track_buildable_pieces_built(buildable);
	}
	
	if (buildable buildable_all_built())
	{
		self player_finish_buildable(buildable);
		buildable.stub buildablestub_finish_build(self);
		
		if ( isplayer( self ) )
		{
			//stat tracking
			self track_buildables_built(buildable);
		}
		
		//SQ
		if(isDefined(level.buildable_built_custom_func))
		{
			self thread [[level.buildable_built_custom_func]](buildable);
		}
		
		alias = sndBuildableCompleteAlias(buildable.buildable_name);
		
		self playsound( alias );
		
		// at this point either the trigger will be deleted or the prompt will be changed to the buy prompt so the built prompt will never appear in practice
		//assert (isdefined(level.zombie_buildables[ buildable.buildable_name ].built), "Missing built hint" );
		//if (isdefined(level.zombie_buildables[ buildable.buildable_name ].built))
		//	return level.zombie_buildables[ buildable.buildable_name ].built;
	}
	else
	{
		self playsound( "zmb_buildable_piece_add" );
		
		assert (isdefined(level.zombie_buildables[ buildable.buildable_name ].building), "Missing builing hint" );
		if (isdefined(level.zombie_buildables[ buildable.buildable_name ].building))
			return level.zombie_buildables[ buildable.buildable_name ].building;
	}
	return "";
}
function sndBuildableCompleteAlias(name)
{
	alias = undefined;
	
	switch(name)
	{
		case "chalk": alias = "zmb_chalk_complete"; break;
		default: alias = "zmb_buildable_complete"; break;
	}
	
	return alias;
}

function player_finish_buildable(buildable)
{
	buildable.built=true;
	buildable.stub.built=true;
	buildable notify( "built", self );
	level.buildables_built[ buildable.buildable_name ] = true;
	level notify( buildable.buildable_name+"_built", self );
	
}

function buildablestub_finish_build(player)
{
	player player_finish_buildable(self.buildableZone);
}

function buildablestub_remove()
{
	ArrayRemoveValue(level.buildable_stubs,self);
}

function buildabletrigger_update_prompt( player )
{
	can_use = self.stub buildablestub_update_prompt( player );
	self SetHintString( self.stub.hint_string );
	if(isdefined(self.stub.cursor_hint))
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && IsDefined(self.stub.cursor_hint_weapon) )
			self SetCursorHint(self.stub.cursor_hint,self.stub.cursor_hint_weapon);	
		else
			self SetCursorHint(self.stub.cursor_hint);	
	}
	return can_use;
}

function buildablestub_update_prompt( player )
{
	if (!self anystub_update_prompt( player ))
		return false;
	can_use = true;
	
	if( IsDefined(self.buildablestub_reject_func) )
	{
		rval = self [[ self.buildablestub_reject_func ]]( player );
		if( rval )
		{
			return( false );
		}
	}

	if ( IsDefined( self.custom_buildablestub_update_prompt ) && ! self [[ self.custom_buildablestub_update_prompt ]]( player ) )
	{
		return false;
	}
	
	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if (!( isdefined( self.built ) && self.built ))
	{	
		slot = self.buildablestruct.buildable_slot;
		if (!isdefined(player player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint_more))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint_more;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			return false;
		}
		else if (!self.buildableZone buildable_has_piece(player player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint_wrong))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint_wrong;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
			return false;
		}
		else
		{
			assert (isdefined(level.zombie_buildables[ self.buildable_name ].hint), "Missing buildable hint" );
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint;
			else
				self.hint_string = "Missing buildable hint";
		}
	}
	else if ( self.persistent == 1 )
	{
		if ( zm_equipment::is_limited(self.equipment) &&
			 zm_equipment::limited_in_use(self.equipment) )
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
			return false;
		}
		if (player zm_equipment::has_player_equipment( self.equipment ))
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
			return false;
		}

		self.cursor_hint = "HINT_WEAPON";
		self.cursor_hint_weapon = self.equipment;
		self.hint_string = self.trigger_hintstring;
	}
	else if ( self.persistent == 2 )
	{
		if ( !zm_weapons::limited_weapon_below_quota( self.equipment, undefined ) )
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			return false;
		}
		else if (( isdefined( self.bought ) && self.bought ))
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

function player_continue_building( buildableZone, build_stub = buildableZone.stub )
{
	if ( self laststand::player_is_in_laststand() || self zm_utility::in_revive_trigger())
		return false;
	if( self isThrowingGrenade() )
		return false;
	if (!(self player_can_build(buildableZone,true)))
		return false;
	if (!self UseButtonPressed())
		return false;
	slot = build_stub.buildablestruct.buildable_slot;
	if (!buildableZone buildable_is_piece_building( self player_get_buildable_piece(slot) ))
		return false;
	trigger = build_stub zm_unitrigger::unitrigger_trigger( self );
	if ( build_stub.script_unitrigger_type == "unitrigger_radius_use" )
	{
		torigin = build_stub zm_unitrigger::unitrigger_origin();
		porigin = self GetEye();
		radius_sq = (1.5*1.5) * build_stub.test_radius_sq;
		if ( Distance2DSquared( torigin, porigin ) > radius_sq )
			return false;
	}
	else
	{
		if (!isdefined(trigger) || !trigger IsTouching(self)) //self IsTouching(trigger))
			return false;
	}
	if ( ( isdefined( build_stub.require_look_at ) && build_stub.require_look_at ) && !self zm_utility::is_player_looking_at( trigger.origin, 0.4 ) )
	    return false;
	return true;
}

function player_progress_bar_update( start_time, build_time )
{
	self endon("entering_last_stand");
	self endon("death");
	self endon("disconnect");
	self endon("buildable_progress_end");
	
	while ( IsDefined(self) && getTime()-start_time < build_time )
	{
		progress = (getTime()-start_time) / build_time;
		if (progress < 0)
			progress = 0;
		if (progress > 1)
			progress = 1;
		self.useBar hud::updateBar( progress );
		{wait(.05);}; 
	}
	
}

function player_progress_bar( start_time, build_time, building_prompt )
{
	self.useBar = self hud::createPrimaryProgressBar();
	self.useBarText = self hud::createPrimaryProgressBarText();
	if (IsDefined(building_prompt))
		self.useBarText setText( building_prompt );
	else
		self.useBarText setText( &"ZOMBIE_BUILDING" );

	if ( IsDefined(self) && IsDefined(start_time) && IsDefined(build_time) )
		self player_progress_bar_update( start_time, build_time );
	
	self.useBarText hud::destroyElem();
	self.useBar hud::destroyElem();
}


function buildable_use_hold_think_internal( player, bind_stub=self.stub )
{
	wait 0.01;
	if (!isdefined(self))
	{
		self notify("build_failed");
		
		//make sure the audio sounds go away
		if(isDefined( player.buildableAudio ) )
		{
			player.buildableAudio delete();
			player.buildableAudio = undefined;
		}
		return;
	}
	if (!isdefined(self.useTime))
		self.useTime = int( 3 * 1000 );
	self.build_time = self.useTime;
	self.build_start_time = getTime();
	build_time = self.build_time;
	build_start_time = self.build_start_time;
	
	player zm_utility::disable_player_move_states(true);

	player zm_utility::increment_is_drinking();
	orgweapon = player GetCurrentWeapon(); 
	build_weapon = GetWeapon( "zombie_builder" );
	if (IsDefined(bind_stub.build_weapon))
		build_weapon = bind_stub.build_weapon;
	player GiveWeapon( build_weapon );
	player SwitchToWeapon( build_weapon );

	slot = bind_stub.buildablestruct.buildable_slot;
	bind_stub.buildableZone buildable_set_piece_building( player player_get_buildable_piece(slot) );
		
	player thread player_progress_bar( build_start_time, build_time, bind_stub.building_prompt );
	
	//check to see if this is the final piece
	if(isDefined(level.buildable_build_custom_func))
	{
		player thread [[level.buildable_build_custom_func]]( self.stub );
	}
	
	
	while( isdefined(self) && player player_continue_building( bind_stub.buildableZone, self.stub ) && getTime()-self.build_start_time < self.build_time )
	{
		{wait(.05);};
	}

	player notify("buildable_progress_end");
	
	player zm_weapons::switch_back_primary_weapon(orgweapon);
	//player SwitchToWeapon( orgweapon );
	player TakeWeapon( build_weapon );
	if (( isdefined( player.is_drinking ) && player.is_drinking ))
		player zm_utility::decrement_is_drinking();
	
	player zm_utility::enable_player_move_states();

	if ( isdefined(self) && player player_continue_building( bind_stub.buildableZone, self.stub ) && getTime()-self.build_start_time >= self.build_time )
	{
		buildable_clear_piece_building( player player_get_buildable_piece(slot) );
	
		self notify("build_succeed");
	}
	else
	{
			//make sure the audio sounds go away
		if(isDefined( player.buildableAudio ) )
		{
			player.buildableAudio delete();
			player.buildableAudio = undefined;
		}
		buildable_clear_piece_building( player player_get_buildable_piece(slot) );
	
		self notify("build_failed");
	}
	
}

function buildable_play_build_fx( player )
{
	self endon("kill_trigger");
	self endon("build_succeed");
	self endon("build_failed");
	while (1)
	{
		PlayFX(level._effect["building_dust"], player GetPlayerCameraPos(), player.angles);
		//PlayFxOnTag( level._effect["building_dust"], player, "tag_camera" );
		wait 0.5;	
	}
}

function buildable_use_hold_think( player, bind_stub=self.stub )
{
	self thread buildable_play_build_fx( player );
	self thread buildable_use_hold_think_internal( player, bind_stub );
	retval = self util::waittill_any_return("build_succeed","build_failed");
	if ( retval == "build_succeed")
		return true;
	return false;
}


// Main unitrigger think function for buildable place triggers

function buildable_place_think()
{
	self endon("kill_trigger");

	player_built = undefined;
	while(!( isdefined( self.stub.built ) && self.stub.built ))
	{	
		self waittill( "trigger", player );
	
		if (player != self.parent_player)
			continue; 
		
		if( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		status = player player_can_build( self.stub.buildableZone );
		if ( !status )
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );
			if ( IsDefined( self.stub.onCantUse ) )
			{
				self.stub [[ self.stub.onCantUse ]]( player );
			}
		}
		else
		{
			if ( IsDefined( self.stub.onBeginUse ) )
				self.stub [[ self.stub.onBeginUse ]]( player );

			result = self buildable_use_hold_think( player );
			team = player.pers["team"];
			
			if ( IsDefined( self.stub.onEndUse ) )
				self.stub [[ self.stub.onEndUse ]]( team, player, result );

			if ( !result )
				continue;
			
			if ( IsDefined( self.stub.onUse ) )
			{
				self.stub [[ self.stub.onUse ]]( player );
			}

			slot = self.stub.buildablestruct.buildable_slot;
			if (IsDefined(player player_get_buildable_piece(slot)))
			{
				prompt = player player_build( self.stub.buildableZone );
				player_built = player;
				self.stub.hint_string = prompt;
			}
			self SetHintString( self.stub.hint_string );
		}
	}
	
	if( isdefined( player_built ) )
	{
		//player_built playsound( "zmb_buildable_complete" );
	}

	switch ( self.stub.persistent )
	{
		case 1:
			self bptrigger_think_persistent( player_built ); break;
		case 0:
			self bptrigger_think_one_time( player_built ); break;
		case 3:
			self bptrigger_think_unbuild( player_built ); break;
		case 2:
			self bptrigger_think_one_use_and_fly( player_built ); break;
		case 4:
			self [[self.stub.custom_completion_callback]]( player_built ); break;
	}
	
}

// one time build
function bptrigger_think_one_time( player_built )
{
	self.stub buildablestub_remove();
	thread zm_unitrigger::unregister_unitrigger(self.stub);
}

// unbuild and start over
function bptrigger_think_unbuild( player_built )
{
	/*
	if ( isdefined(player_built) )
		stub_unbuild_buildable( self.stub, true, player_built.origin, player_built.angles );
	else
	*/
	stub_unbuild_buildable( self.stub, true );
}

// one use and fly bench
function bptrigger_think_one_use_and_fly( player_built )
{
	if ( isdefined(player_built) )
			self buildabletrigger_update_prompt( player_built );
	if ( !zm_weapons::limited_weapon_below_quota( self.stub.equipment, undefined ) )
	{
		self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
		self SetHintString( self.stub.hint_string );
		return;
	}
	if (( isdefined( self.stub.bought ) && self.stub.bought ))
	{
		self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
		self SetHintString( self.stub.hint_string );
		return;
	}
	if(isdefined(self.stub.model))
	{
		self.stub.model NotSolid(); 
		self.stub.model show(); 
	} 
	while ( self.stub.persistent == 2 )
	{
		self waittill( "trigger", player );

		if ( !zm_weapons::limited_weapon_below_quota( self.stub.equipment, undefined ) )
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self SetHintString( self.stub.hint_string );
			return;
		}
		if(!( isdefined( self.stub.built ) && self.stub.built ))
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );
			return;
		}
		if (player != self.parent_player)
			continue; 
	
		if( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		self.stub.bought=1; 
		if(isdefined(self.stub.model))
		{
			self.stub.model thread model_fly_away();
		} 
		
		player zm_weapons::weapon_give( self.stub.equipment );
		if (isdefined(level.zombie_include_buildables[ self.stub.buildable_name ].onBuyWeapon))
			self [[level.zombie_include_buildables[ self.stub.buildable_name ].onBuyWeapon]]( player );
		
		if ( !zm_weapons::limited_weapon_below_quota( self.stub.equipment, undefined ) )
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
		}
		else
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
		}
		self SetHintString( self.stub.hint_string );
		
		//stat tracking
		player track_buildables_pickedup(self.stub.equipment);

	}
}
	
// persistent bench
function bptrigger_think_persistent( player_built )
{
	if ( !isdefined(player_built) || self [[self.stub.prompt_and_visibility_func]]( player_built ) )
	{
		if(isdefined(self.stub.model))
		{
			self.stub.model NotSolid(); 
			self.stub.model show(); 
		} 
		while ( self.stub.persistent == 1 )
		{
			self waittill( "trigger", player );
	
			if(!( isdefined( self.stub.built ) && self.stub.built ))
			{
				self.stub.hint_string = "";
				self SetHintString( self.stub.hint_string );
				self SetCursorHint("HINT_NOICON");
				return;
			}
			if (player != self.parent_player)
				continue; 
		
			if( !zm_utility::is_player_valid( player ) )
			{
				player thread zm_utility::ignore_triggers( 0.5 );
				continue;
			}
			
			if (player zm_equipment::has_player_equipment( self.stub.equipment ))
			{
				continue;
			}
			
	
			if ( IsDefined( self.stub.buildableStruct.OnBought ) )
			{
				self [[ self.stub.buildableStruct.OnBought ]]( player );
			}
			else if ( !zm_equipment::is_limited(self.stub.equipment) ||
				 !zm_equipment::limited_in_use(self.stub.equipment) )
			{
				player zm_equipment::buy( self.stub.equipment );
				player GiveWeapon( self.stub.equipment );
				//player setWeaponAmmoClip( self.stub.equipment, 1 );
				player zm_equipment::start_ammo( self.stub.equipment );
				if (isdefined(level.zombie_include_buildables[ self.stub.buildable_name ].onBuyWeapon))
					self [[level.zombie_include_buildables[ self.stub.buildable_name ].onBuyWeapon]]( player );

				if( self.stub.equipment.name != "keys" )
				{
					player setactionslot( 1, "weapon", self.stub.equipment );
				}

				self.stub.cursor_hint = "HINT_NOICON";
				self.stub.cursor_hint_weapon = undefined;
				self SetCursorHint(self.stub.cursor_hint);
				if (isdefined(level.zombie_buildables[ self.stub.buildable_name ].bought))
					self.stub.hint_string = level.zombie_buildables[ self.stub.buildable_name ].bought;
				else
					self.stub.hint_string = "";
				self SetHintString( self.stub.hint_string );
				
				//stat tracking
				player track_buildables_pickedup(self.stub.equipment);
			}
			else
			{
				self.stub.hint_string = "";
				self SetHintString( self.stub.hint_string );
				self.stub.cursor_hint = "HINT_NOICON";
				self.stub.cursor_hint_weapon = undefined;
				self SetCursorHint(self.stub.cursor_hint);
			}

		}
	}
}

// custom completion callback
function bptrigger_think_unbuild_no_return( player )
{
	stub_unbuild_buildable( self.stub, false );
}

function bpstub_set_custom_think_callback( callback )
{
	self.persistent = 4;
	self.custom_completion_callback = callback; 
}

function model_fly_away()
{
	self moveto( self.origin + (0,0,40),3);
	direction = self.origin;
	direction = (direction[1], direction[0], 0);
	   
   	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
   	{
        direction = (direction[0], direction[1] * -1, 0);
   	}
   	else if(direction[0] < 0)
   	{
        direction = (direction[0] * -1, direction[1], 0);
   	}
	   
    self Vibrate( direction, 10, 0.5, 4);
    self waittill("movedone");		
	
	self hide();
	
	PlayFX(level._effect["poltergeist"], self.origin);
}


function find_buildable_stub( buildable_name )
{
	foreach( stub in level.buildable_stubs )
	{
		if (stub.buildable_name == buildable_name)
			return stub;
	}
	return undefined;
}

function unbuild_buildable( buildable_name, return_pieces, origin, angles )
{
	stub = find_buildable_stub( buildable_name );
	
	stub_unbuild_buildable( stub, return_pieces, origin, angles );
}

function stub_unbuild_buildable( stub, return_pieces, origin, angles )
{
	if (isdefined(stub))
	{
		buildable = stub.buildableZone;
		buildable.built=false;
		buildable.stub.built=false;
		buildable notify( "unbuilt" );
		level.buildables_built[ buildable.buildable_name ] = false;
		level notify( buildable.buildable_name+"_unbuilt" );
		for ( i=0; i<buildable.pieces.size; i++ )
		{
			buildable.pieces[i].built = false;
			if (isdefined( buildable.pieces[i].part_name ) )
			{
				buildable.stub.model NotSolid(); 
				if ( !( isdefined( buildable.pieces[i].built ) && buildable.pieces[i].built ) )
				{
					buildable.stub.model HidePart( buildable.pieces[i].part_name ); 
				}
				else
				{
					buildable.stub.model show(); 
					buildable.stub.model ShowPart( buildable.pieces[i].part_name ); 
				}
			}
			if (( isdefined( return_pieces ) && return_pieces ))
			{
				if( IsDefined(buildable.stub.str_unbuild_notify) )
				{
					buildable.pieces[i] thread piece_spawn_at_with_notify_delay( origin, angles, buildable.stub.str_unbuild_notify, buildable.stub.unbuild_respawn_fn );
				}
				else
				{
					buildable.pieces[i] piece_spawn_at( origin, angles );
				}
			}
		}
		
		if ( IsDefined( buildable.stub.model ) )
		{
			buildable.stub.model hide(); 
		}
	}
}

function player_explode_buildable( buildable_name, origin, speed, return_to_spawn, return_time )
{
	self ExplosionDamage( 50, origin ); 

	stub = find_buildable_stub( buildable_name );
	
	if (isdefined(stub))
	{
		buildable = stub.buildableZone;
		buildable.built=false;
		buildable.stub.built=false;
		buildable notify( "unbuilt" );
		level.buildables_built[ buildable.buildable_name ] = false;
		level notify( buildable.buildable_name+"_unbuilt" );
		for ( i=0; i<buildable.pieces.size; i++ )
		{
			buildable.pieces[i].built = false;
			if (isdefined( buildable.pieces[i].part_name ) )
			{
				buildable.stub.model NotSolid(); 
				if ( !( isdefined( buildable.pieces[i].built ) && buildable.pieces[i].built ) )
				{
					buildable.stub.model HidePart( buildable.pieces[i].part_name ); 
				}
				else
				{
					buildable.stub.model show(); 
					buildable.stub.model ShowPart( buildable.pieces[i].part_name ); 
				}
			}
			ang = RandomFloat(360);
			h = 0.25 + RandomFloat(0.5);
			dir = ( Sin(ang), Cos(ang), h );
			self thread player_throw_piece( buildable.pieces[i], origin, speed * dir, return_to_spawn, return_time );
		}
		buildable.stub.model hide(); 
	}
}



function think_buildables()
{
	foreach ( buildable in level.zombie_include_buildables )
	{
		if (IsDefined(buildable.triggerThink))
		{
			level [[buildable.triggerThink]]();
			util::wait_network_frame();
		}			
	}

	level notify( "buildables_setup" );
}

function buildable_trigger_think( trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	return setup_unitrigger_buildable( trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent );
}

function buildable_trigger_think_array( trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	return setup_unitrigger_buildable_array( trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent );
}


//*****************************************************************************
//*****************************************************************************

function buildable_set_unbuild_notify_delay( str_buildable_name, str_unbuild_notify, unbuild_respawn_fn )
{
	stub = find_buildable_stub( str_buildable_name );
	stub.str_unbuild_notify = str_unbuild_notify;
	stub.unbuild_respawn_fn = unbuild_respawn_fn;
}


//*****************************************************************************
//*****************************************************************************

function setup_vehicle_unitrigger_buildable( parent, trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	trig = GetEnt( trigger_targetname, "targetname" );
	if ( !IsDefined( trig ) )
	{
		return;
	}
	unitrigger_stub = spawnstruct();

	unitrigger_stub.buildableStruct = level.zombie_include_buildables[ buildable_name ];

	unitrigger_stub.link_parent = parent;
	unitrigger_stub.origin_parent = trig;
	unitrigger_stub.trigger_targetname = trigger_targetname;
	unitrigger_stub.originFunc = &anystub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;
	unitrigger_stub.origin = trig.origin;
	unitrigger_stub.angles = trig.angles;
	unitrigger_stub.buildable_name = buildable_name;
	unitrigger_stub.equipment = GetWeapon( equipment_name );
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.delete_trigger = delete_trigger;
	unitrigger_stub.built = false;
	unitrigger_stub.persistent = persistent;
	unitrigger_stub.useTime = int( 3 * 1000 );

	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;

	if(isdefined(trig.script_length))
	{
		unitrigger_stub.script_length = trig.script_length;
	}
	else
	{
		unitrigger_stub.script_length = 24;
	}
		
	if(isdefined(trig.script_width))
	{
		unitrigger_stub.script_width = trig.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 64;
	}
		
	if(isdefined(trig.script_height))
	{
		unitrigger_stub.script_height = trig.script_height;
	}
	else
	{
		unitrigger_stub.script_height = 24;
	}
		
	if(isdefined(trig.radius))
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
	if (isdefined(level.zombie_buildables[ buildable_name ].hint))
		unitrigger_stub.hint_string = level.zombie_buildables[ buildable_name ].hint;
		
	unitrigger_stub.script_unitrigger_type  = "unitrigger_radius_use";
	unitrigger_stub.require_look_at = true;

	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, true);
	unitrigger_stub.prompt_and_visibility_func = &buildabletrigger_update_prompt;

	//zm_unitrigger::register_static_unitrigger(unitrigger_stub, &buildable_spawn_think);
	zm_unitrigger::register_unitrigger(unitrigger_stub, &buildable_place_think);
		
	unitrigger_stub.piece_trigger = trig;
	trig.trigger_stub = unitrigger_stub;

	// create buildable pieces
	//unitrigger_stub.buildableZone = trig buildable_piece_triggers( buildable_name, unitrigger_stub.origin );
	unitrigger_stub.buildableZone = unitrigger_stub buildable_piece_unitriggers( buildable_name, unitrigger_stub.origin );
	
	if (delete_trigger)
		trig delete();
	
	level.buildable_stubs[level.buildable_stubs.size]=unitrigger_stub;
	return unitrigger_stub;
}

function vehicle_buildable_trigger_think( vehicle, trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent )
{
	return setup_vehicle_unitrigger_buildable( vehicle, trigger_targetname, buildable_name, equipment_name, trigger_hintstring, delete_trigger, persistent );
}

function ai_buildable_trigger_think( parent, buildable_name, equipment_name, trigger_hintstring, persistent )
{
	unitrigger_stub = spawnstruct();

	unitrigger_stub.buildableStruct = level.zombie_include_buildables[ buildable_name ];

	unitrigger_stub.link_parent = parent;
	unitrigger_stub.origin_parent = parent;
	unitrigger_stub.originFunc = &anystub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &anystub_on_spawn_trigger;
	unitrigger_stub.origin = parent.origin;
	unitrigger_stub.angles = parent.angles;
	unitrigger_stub.buildable_name = buildable_name;
	unitrigger_stub.equipment = GetWeapon( equipment_name );
	unitrigger_stub.trigger_hintstring = trigger_hintstring;
	unitrigger_stub.delete_trigger = true;
	unitrigger_stub.built = false;
	unitrigger_stub.persistent = persistent;
	unitrigger_stub.useTime = int( 3 * 1000 );

	unitrigger_stub.onBeginUse = &onBeginUseUTS;
	unitrigger_stub.onEndUse = &onEndUseUTS;
	unitrigger_stub.onUse = &onUsePlantObjectUTS;
	unitrigger_stub.onCantUse = &onCantUseUTS;

	unitrigger_stub.script_length = 64;
	unitrigger_stub.script_width = 64;
	unitrigger_stub.script_height = 54;
		
	unitrigger_stub.radius = 64;
		
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	if (isdefined(level.zombie_buildables[ buildable_name ].hint))
		unitrigger_stub.hint_string = level.zombie_buildables[ buildable_name ].hint;
		
	unitrigger_stub.script_unitrigger_type  = "unitrigger_radius_use";
	unitrigger_stub.require_look_at = false;

	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, true);
	unitrigger_stub.prompt_and_visibility_func = &buildabletrigger_update_prompt;

	zm_unitrigger::register_unitrigger(unitrigger_stub, &buildable_place_think);
		
	unitrigger_stub.buildableZone = unitrigger_stub buildable_piece_unitriggers( buildable_name, unitrigger_stub.origin );
	
	level.buildable_stubs[level.buildable_stubs.size]=unitrigger_stub;
	return unitrigger_stub;
}



function onPickupUTS( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece recovered by - " + player.name );
	}
	#/ 
}

function onDropUTS( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece dropped by - " + player.name );
	}
	#/
	player notify( "event_ended" );
}

function onBeginUseUTS( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece begin use by - " + player.name );
	}
	#/
	
	if ( IsDefined( self.buildableStruct.onBeginUse ) )
	{
		self [[ self.buildableStruct.onBeginUse ]]( player );
	}

	if( isdefined( player ) && !isdefined( player.buildableAudio ) )
	{	
		alias = sndBuildableUseAlias( self.targetname );
		player.buildableAudio = spawn( "script_origin", player.origin );
		player.buildableAudio PlayLoopSound( alias );
	}
}
function sndBuildableUseAlias( name )
{
	alias = undefined;
	
	switch(name)
	{
		case "cell_door_trigger": alias = "zmb_jail_buildable"; break;
		case "generator_use_trigger": alias = "zmb_generator_buildable"; break;
		case "chalk_buildable_trigger": alias = "zmb_chalk_loop"; break;
		default: alias = "zmb_buildable_loop"; break;
	}
	
	return alias;
}

function onEndUseUTS( team, player, result )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece end use by - " + player.name );
	}
	#/

	if ( !IsDefined( player ) )
	{
		return;
	}
	
	if( isdefined( player.buildableAudio ) )
	{
		player.buildableAudio delete();
		player.buildableAudio = undefined;
	}

	if ( IsDefined( self.buildableStruct.onEndUse ) )
	{
		self [[ self.buildableStruct.onEndUse ]]( team, player, result );
	}

	player notify( "event_ended" );
}

function onCantUseUTS( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece can't use by - " + player.name );
	}
	#/
	
	if ( IsDefined( self.buildableStruct.onCantUse ) )
	{
		self [[ self.buildableStruct.onCantUse ]]( player );
	}
}

function onUsePlantObjectUTS( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece crafted by - " + player.name );
	}
	#/
	
	if ( IsDefined( self.buildableStruct.onUsePlantObject ) )
	{
		self [[ self.buildableStruct.onUsePlantObject ]]( player );
	}

	//* player playSound( "mpl_sd_bomb_plant" );
	player notify ( "bomb_planted" );

}

function add_zombie_buildable_vox_category( buildable_name, vox_id )
{
	buildable_struct = level.zombie_include_buildables[ buildable_name ];
	
	buildable_struct.vox_id = vox_id;
}

function add_zombie_buildable_piece_vox_category( buildable_name, vox_id, timer )
{
	buildable_struct = level.zombie_include_buildables[ buildable_name ];
	
	buildable_struct.piece_vox_id = vox_id;
	
	buildable_struct.piece_vox_timer = timer;
}

function is_buildable()
{
	// No Buildables Set Up In Map
	//----------------------------
	if ( !IsDefined( level.zombie_buildables ) )
	{
		return false;
	}
	
	// WallBuys
	//---------
	if ( IsDefined( self.zombie_weapon_upgrade ) && IsDefined( level.zombie_buildables[ self.zombie_weapon_upgrade ] ) )
	{
		return true;
	}
	
	// Machines
	//---------
	if ( self zm_pap_util::is_pap_trigger() )
	{
		if ( ( isdefined( level.buildables_built[ "pap" ] ) && level.buildables_built[ "pap" ] ) )
		{
			return false;
		}

		return true;
	}

	return false;
}

function buildable_crafted()
{
	self.pieces--;
}

function buildable_complete()
{
	if ( self.pieces <= 0 )
	{
		return true;
	}

	return false;
}


function get_buildable_hint( buildable_name )
{
	assert( IsDefined( level.zombie_buildables[ buildable_name ] ), buildable_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_buildables[ buildable_name ].hint;
}

function delete_on_disconnect( buildable, self_notify, skip_delete )
{
	buildable endon( "death" );
	
	self waittill( "disconnect" );
	
	if ( IsDefined( self_notify ) )
	{
		self notify( self_notify );
	}
	
	if ( !( isdefined( skip_delete ) && skip_delete ) )
	{
		if (isdefined(buildable.stub))
		{
			thread zm_unitrigger::unregister_unitrigger(buildable.stub);
			buildable.stub=undefined;
		}

		if ( IsDefined( buildable ) )
		{
			buildable Delete();
		}
	}
}

function get_buildable_pickup( buildableName, modelName )
{
	foreach ( buildablePickUp in level.buildablePickUps )
	{
		if ( buildablePickUp[ 0 ].buildableStruct.name == buildableName && buildablePickUp[ 0 ].visuals[ 0 ].model == modelName )
		{
			return buildablePickUp[ 0 ];
		}
	}
	
	return undefined;
}


//-------------------------------------------------
//STAT TRACKING STUFF
//-------------------------------------------------

function track_buildable_piece_pickedup(piece)
{
	if(!isDefined(piece) || !isDefined(piece.buildablename))
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_buildable_piece_pickedup() \n"); #/
		return;
	}
	self add_map_buildable_stat(piece.buildablename,"pieces_pickedup",1);
	
	// VO
	buildable_struct = level.zombie_include_buildables[ piece.buildablename ];
	if( IsDefined( buildable_struct.piece_vox_id ) )
	{
		// Handle Cooldown
		
		if( IsDefined( self.a_buildable_piece_pickedup_vox_cooldown ) && IsInArray( self.a_buildable_piece_pickedup_vox_cooldown, buildable_struct.piece_vox_id ) )
		{
			// This category is on cooldown for this character, so return without playing VO
			return;
		}
		
		self thread zm_utility::do_player_general_vox( "general", buildable_struct.piece_vox_id + "_pickup" );
		if( IsDefined( buildable_struct.piece_vox_timer ) )
		{
			self thread buildable_piece_pickedup_vox_cooldown( buildable_struct.piece_vox_id, buildable_struct.piece_vox_timer );
		}	
	}
	else
	{
		self thread zm_utility::do_player_general_vox("general","build_pickup");	
	}
}

function buildable_piece_pickedup_vox_cooldown( piece_vox_id, timer ) // self = player
{
	self endon( "disconnect" );
	
	if( !IsDefined( self.a_buildable_piece_pickedup_vox_cooldown ) )
	{
		self.a_buildable_piece_pickedup_vox_cooldown = [];
	}
	
	self.a_buildable_piece_pickedup_vox_cooldown[ self.a_buildable_piece_pickedup_vox_cooldown.size] = piece_vox_id;
	
	wait timer;
	
	ArrayRemoveValue( self.a_buildable_piece_pickedup_vox_cooldown, piece_vox_id );
}

function track_buildable_pieces_built(buildable)
{
	if(!isDefined(buildable) || !isDefined(buildable.buildable_name))
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_buildable_pieces_built() \n"); #/
		return;
	}
	bname = buildable.buildable_name; 
	if (isdefined(buildable.stat_name))
		bname = buildable.stat_name; 
	self add_map_buildable_stat(bname,"pieces_built",1);
	if( !buildable buildable_all_built() )
	{
		if ( IsDefined( level.zombie_include_buildables[ buildable.buildable_name ] ) &&
		    IsDefined( level.zombie_include_buildables[ buildable.buildable_name ].snd_build_add_vo_override ) )
		{
			self thread [[ level.zombie_include_buildables[ buildable.buildable_name ].snd_build_add_vo_override ]]();
		}
		else
		{
			self thread zm_utility::do_player_general_vox("general","build_add");
		}
	}
}

function track_buildables_built(buildable)
{
	if(!isDefined(buildable) || !isDefined(buildable.buildable_name))
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_buildables_built() \n"); #/		
		return;
	}
	bname = buildable.buildable_name; 
	if (isdefined(buildable.stat_name))
		bname = buildable.stat_name; 
	self add_map_buildable_stat(bname,"buildable_built",1);
	self zm_stats::increment_client_stat( "buildables_built", false );
	self zm_stats::increment_player_stat( "buildables_built");
	
	if( IsDefined( buildable.stub.buildablestruct.vox_id ) )
	{
		self thread zm_utility::do_player_general_vox( "general", "build_" + buildable.stub.buildablestruct.vox_id + "_final"  );
	}
}

function track_buildables_pickedup(buildable)
{
	if(!isDefined(buildable))
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED IN track_buildables_pickedup() \n"); #/
		return;
	}
	
	stat_name = get_stat_name(buildable);
	if(!isDefined(stat_name))
	{
		/# println( "STAT TRACKING FAILURE: NO STAT NAME FOR " + buildable.name + "\n"); #/
		return;		
	}
	
	self add_map_buildable_stat(stat_name,"buildable_pickedup",1);
	
	self say_pickup_buildable_vo(buildable, false );
	
}

//buildables that are planted on the ground ( turret, turbine, etc )
function track_buildables_planted(equipment_instance) 
{
	if(!isDefined(equipment_instance))
	{
		/# println( "STAT TRACKING FAILURE: NOT DEFINED for track_buildables_planted() \n"); #/
		return;
	}

	buildable_name = get_stat_name(equipment_instance.weapon);
	if(!isDefined(buildable_name))
	{
		/# println( "STAT TRACKING FAILURE: NO BUILDABLE NAME FOR track_buildables_planted() " + equipment_instance.weapon.name + "\n"); #/
		return;
	}
	
	demo::bookmark( "zm_player_buildable_placed", gettime(), self );		
	self add_map_buildable_stat(buildable_name,"buildable_placed",1);
	
	vo_name = "build_plc_" + buildable_name;
	if(buildable_name == "electric_trap")
	{
		vo_name ="build_plc_trap";
	}
	
	if(!( isdefined( self.buildable_timer ) && self.buildable_timer ))
	{
		self thread zm_utility::do_player_general_vox("general",vo_name);
		self thread placed_buildable_vo_timer();
	}
}

function placed_buildable_vo_timer()
{
	self endon("disconnect");
	self.buildable_timer = true;
	wait(60);
	self.buildable_timer = false;
}

function buildable_pickedup_timer()
{
	self endon("disconnect");
	self.buildable_pickedup_timer = true;
	wait(60);
	self.buildable_pickedup_timer = false;	
}

//buildables that are planted on the ground ( turret, turbine, etc )
function track_planted_buildables_pickedup(equipment) 
{
	if(!isDefined(equipment))
	{
		return;
	}
	
	equipment_name = equipment.name;
	if(equipment_name == "equip_turbine" || equipment_name == "equip_turret" || equipment_name == "equip_electrictrap" || equipment == level.weaponRiotshield )
	{		
		self zm_stats::increment_client_stat( "planted_buildables_pickedup", false );
		self zm_stats::increment_player_stat( "planted_buildables_pickedup");
	}
	if(!( isdefined( self.buildable_pickedup_timer ) && self.buildable_pickedup_timer ))
	{	
		self say_pickup_buildable_vo(equipment, true );
		self thread buildable_pickedup_timer();
	}
}


//for things attached (stuff on the bus, etc..)
function track_placed_buildables(equipment)
{
	self add_map_buildable_stat( equipment.name,"buildable_placed", 1 );
	
	vo_name = undefined;
	if ( equipment == level.weaponRiotshield )
	{
		vo_name = "build_plc_shield";
	}

	if ( !isDefined( vo_name ) )
	{
		return;
	}

	self thread zm_utility::do_player_general_vox( "general",vo_name );
}


function add_map_buildable_stat(piece_name,stat_name, value )
{
	if( !IsDefined(piece_name) || (piece_name == "sq_common") || (piece_name == "keys") || (piece_name == "oillamp") )
	{
		return;
	}

	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) || ( isdefined( level.zm_disable_recording_buildable_stats ) && level.zm_disable_recording_buildable_stats ) )
	{
		return;
	}

	self AddDStat( "buildables", piece_name, stat_name, value );
}

function say_pickup_buildable_vo( buildable, _world )
{
	if(( isdefined( self.buildable_pickedup_timer ) && self.buildable_pickedup_timer ))
	{
		return;
	}
	name = get_vo_name( buildable );
	
	if(!isDefined(name))
	{
		return;
	}
	
	vo_name = "build_pck_b" + name;
	if(( isdefined( _world ) && _world ))
	{
		vo_name = "build_pck_w" + name;
	}
	
	if(!isDefined(level.transit_buildable_vo_override) || !self [[level.transit_buildable_vo_override]](name,_world) )
	{
		self thread zm_utility::do_player_general_vox( "general",vo_name );
		self thread buildable_pickedup_timer();
	}
}

function get_vo_name( buildable )
{
	switch ( buildable.name )
	{
		case "equip_turbine": return "turbine";
		case "equip_turret":  return "turret";
		case "equip_electrictrap": return "trap";
		case "riotshield": return "shield";
		case "jetgun": return "jetgun";
		case "equip_springpad": return "springpad";
		case "equip_slipgun": return "slipgun";
		case "equip_headchopper": return "headchopper";
		case "equip_subwoofer": return "subwoofer";
	
	}
	return undefined;
}

function get_stat_name(buildable)
{
	if ( isDefined( buildable ) )
	{
		switch ( buildable.name )
		{
		case "equip_turbine": return "turbine";
		
		case "equip_turret":	return "turret";
		
		case "equip_electrictrap": return "electric_trap";
		
		case "equip_springpad": return "springpad";
		
		case "equip_slipgun": return "slipgun";
		
		case "equip_headchopper": return "headchopper";
		
		case "equip_subwoofer": return "subwoofer";
		
		}
		return undefined;
	}
}

function is_buildable_included( name )
{
	if ( IsDefined( level.zombie_include_buildables[ name ] ) )
		return true;
	return false;
}

function wait_for_buildable( buildable_name )
{
	level waittill( buildable_name+"_built", player );
	return player;
}
