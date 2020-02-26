#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/@
"Name: init( str_objective )"
"Summary: Handles initalization of level variable required by _objective."
"Module: Objectives"
"CallOn: Level"
"Example: maps\_objectives::init();"
"SPMP: singleplayer"
@/
init()
{
	level.a_objectives = [];	// Declares an array of objectives to hold the objective strings.
	level.n_obj_index = 0;	// This is the objective number associated with the objective strings.

	level thread objectives();
}


/@
"Name: register_objective( str_objective )"
"Summary: Handles the setup of objectives."
"Module: Objectives"
"CallOn: Level"
"Example: level.OBJ_FOLLOW_WOODS = register_objective( &"MODULE_OBJECTIVES_OBJ_FOLLOW_WOODS" );"
"SPMP: singleplayer"
@/
register_objective( str_objective )
{
	if ( !IsDefined( level.a_objectives ) )
	{
		level.a_objectives = [];
		level.n_obj_index = 0;
	}
	
	assert(level.n_obj_index < 32, "Too many objectives. Max limit is 32.");
	
	n_index = level.n_obj_index;
	
	level.a_objectives[ n_index ] = str_objective;
	
	level.n_obj_index++;
	
	level.a_obj_addstate[ n_index ] = 0;

	//level.a_objectives notify("objective_register");

	return n_index;
}


/@
"Name: set_objective( <n_objective>, [ent_or_pos], [str_obj_type], [n_targets] )"
"Summary: Used for all objective-related tasks."
"CallOn: NA"
"OptionalArg:  [ent_or_pos] - An entity or vector where you want to place the 3D indicator such as, "follow."
"OptionalArg:  [str_obj_type] - Type of 3D indicator such as, "follow", "destroy" or "breadcrumb."
"OptionalArg:  [n_targets] - The variable that holds the number of targets destroyed when "objective_string" is required.  Add -1 if placing a 3D marker on a target when
multiple markers are simultaneously displayed.
"OptionalArg:  [b_show_objective_message] Set to false to suppress update message."
"Example: set_objective( level.OBJ_FOLLOW_WOODS, level.ai_woods, "follow" );"
"SPMP: singleplayer"
@/
set_objective( n_objective, ent_or_pos, str_obj_type, n_targets, b_show_message )
{
	if ( IsDefined( n_objective ) )
	{
	   	if ( !IsDefined( level.objective_queue ) )
		{
			level.objective_queue = [];
		}
	   	
	   	if ( !IsDefined( b_show_message ) )
	   	{
	   		b_show_message = true;
	   	}
		
		s_info = SpawnStruct();
		s_info.n_objective = n_objective;
		s_info.objective_pos = ent_or_pos;
		s_info.str_objective_type = str_obj_type;
		s_info.n_objective_targets = n_targets;
		s_info.b_show_message = b_show_message;
				
		if ( IsDefined( ent_or_pos ) && !IsVec( ent_or_pos ) )
		{
			s_info.target_id = ent_or_pos.target_id;
		}
				
		level.objective_queue[ level.objective_queue.size ] = s_info;
	}
	else
	{
		AssertMsg( "Undefined objective number. Make sure the objective is registered and a valid objective is passed into set_objective()." );
	}
}

/@
"Name: skip_objective( <n_objective> )"
"Summary: Used for skiptos to skip objectives and mark them as done."
"CallOn: NA"
"Example: set_objective( level.OBJ_FOLLOW_WOODS );"
"SPMP: singleplayer"
@/
skip_objective( n_objective )
{
	set_objective( n_objective, undefined, undefined, undefined, false );
	set_objective( n_objective, undefined, "done", undefined, false );
}

_pop_objective()
{
	while ( !IsDefined( level.objective_queue ) || !IsDefined( level.objective_queue[0] ) )
	{
		wait .05;
	}
	
	s_info = level.objective_queue[0];
	ArrayRemoveIndex(level.objective_queue,0);
	
	return s_info;
}

/@
"Name: objectives()"
"Summary: Handles the adding and updating of objectives."
"Module: Objectives"
"CallOn: Level"
"Example: level thread maps\_objectives::objectives();"
"SPMP: singleplayer"
@/
objectives()
{
	while ( level.a_objectives.size == 0 )
	{
		wait 0.05;
	}

	n_current_obj = -1;
	pos = undefined;
	level.a_obj_addstate = [];
	level.a_obj_structs = [];	
	
	for ( i = 0; i < level.a_objectives.size; i++ )
	{
		level.a_obj_addstate[ i ] = 0;
	}

	while ( true )
	{
		s_info = _pop_objective();
		
		level.n_objective = s_info.n_objective;
		level.objective_pos = s_info.objective_pos;
		level.target_id = s_info.target_id;
		level.str_objective_type = s_info.str_objective_type;
		level.n_objective_targets = s_info.n_objective_targets;
		level.b_show_objective_message = s_info.b_show_message;
		
		if ( !IsDefined( level.n_target_id ) )
		{
			level.n_target_id = 0;
		}
		
		n_objective = level.n_objective;
		
		// this is for multiple objectives such as in destroy three tanks
		if ( IsDefined( level.n_objective_targets ) && level.n_objective_targets != -1 )
		{
			if ( n_current_obj != n_objective )
			{
				Objective_Add( n_objective, "current", (isDefineD(level.str_objective_type)?level.str_objective_type:""), (isDefined(level.objective_pos)?level.objective_pos:undefined), undefined, level.b_show_objective_message );
				level.a_obj_addstate[ n_objective ] = 1;
			}
			else
			{
				if(isDefined(level.objective_pos))
				{
					Objective_Position( n_objective,level.objective_pos );
				}
			}
			// JoannaL (8/18/2011): set the description string for an objective only if the objective has a string
			if ( level.a_objectives[ n_objective ] != &"" )
			{
				Objective_String( n_objective, level.a_objectives[ n_objective ], level.n_objective_targets );
			}
		}
		// if the current objective is the same as new one, then only update set3D and dont add a new objective
		else if ( n_current_obj != n_objective || !is_objective_pos_the_same( level.objective_pos, pos ) )
		{
			// don't add another marker to the objective_pos if "remove" is specified
			// don't add the objective again if it's made the "active" objective
			if ( IsDefined( level.objective_pos )
			    && ( !IsString( level.str_objective_type )
			    || ( ( level.str_objective_type != "remove" ) && ( level.str_objective_type != "active" ) ) ) )
			{
				b_use_pos_origin = true;	// Should we use objective_pos itself or just its .origin?
				// if level.objective_pos is a vector, Sentient, vehicle or script_model then use it as is
				if ( 
				    IsVec( level.objective_pos ) ||
					IsSentient( level.objective_pos ) || 
					IS_VEHICLE( level.objective_pos ) ||
					( IsDefined( level.objective_pos.classname ) && ( level.objective_pos.classname == "script_model" ) )
				)
				{
					b_use_pos_origin = false;
				}
				
				if ( n_current_obj != n_objective )
				{
					level.n_target_id = 0;
					// New objective?
					if ( level.a_obj_addstate[ n_objective ] != 1 )
					{
						if ( !b_use_pos_origin )
						{
							Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], undefined, undefined, level.b_show_objective_message );
							level.a_obj_addstate[ n_objective ] = 1;
						}
						else
						{
							Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], level.objective_pos.origin, undefined, level.b_show_objective_message );
							level.a_obj_addstate[ n_objective ] = 1;
							level.objective_pos thread set_target_id( level.n_target_id );
						}
						_objective_set_position( b_use_pos_origin );
					}
					else
					{
						// Objective already exists, so we just need to set this as the current objective and update the position
						Objective_Current( n_objective );
						_objective_set_position( b_use_pos_origin );
					}
				}
				else
				{
					if ( IsDefined( level.n_target_id ) && IsDefined( level.n_objective_targets ) )
					{
						level.n_targets_objective = n_objective;
						level.n_target_id++;
					}
					
					_objective_set_position( b_use_pos_origin );
				}
			}				
			else if ( n_current_obj != n_objective )
			{
				if ( IsDefined( level.str_objective_type ) )
				{
					objective_type();
				}
				else if ( level.a_obj_addstate[ n_objective ] != 1 )
				{
					Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], undefined, undefined, level.b_show_objective_message );
					level.a_obj_addstate[ n_objective ] = 1;
				}
			}		
		}
		
		if ( IsDefined( level.objective_pos ) || IsDefined( level.target_id ) )
		{
			if ( IsDefined( level.str_objective_type ) )
			{
				objective_type();
			}
			else
			{
				objective_set3d_prethink( n_objective, true, (1, 1, 1) );
			}
		}
		// if only updating the number of targets via objective_string, don't turn off 3d markers
		else if ( !IsDefined( level.n_objective_targets ) )
		{
			objective_set3d_prethink( n_objective, false );
			
			if ( IsDefined( level.str_objective_type ) )
			{
				//level notify( "set3d_objective" );
				objective_type();
			}
		}

		n_current_obj = n_objective;
		pos = level.objective_pos;
	
		wait_network_frame();
	}
}


/@
"Name: set_vectarget_id( <v_obj_pos>, <n_target_id> )"
"Summary: Handles the adding of the index in Objective_AdditionalPosition for vectors"
"Module: Objectives"
"CallOn: Level"
"Example: set_vectarget_id( obj_target.origin, 1 );"
"SPMP: singleplayer"
@/
set_vectarget_id( v_obj_pos, n_target_id )
{
	level.a_obj_structs[level.a_obj_structs.size] = spawnStruct();
	level.a_obj_structs[level.a_obj_structs.size].origin = v_obj_pos;
	level.a_obj_structs[level.a_obj_structs.size].target_id = n_target_id;
}


/@
"Name: get_target_id( <v_obj_pos> )"
"Summary: Returns the index in Objective_AdditionalPosition for vectors"
"Module: Objectives"
"CallOn: Level"
"Example: get_target_id( obj_target.origin );"
"SPMP: singleplayer"
@/
get_target_id( v_obj_pos )
{
	for( i=0; i< level.a_obj_structs.size; i++ )
	{
		if ( level.a_obj_structs[level.a_obj_structs.size].origin == v_obj_pos )
		{
			return ( level.a_obj_structs[level.a_obj_structs.size].target_id );
		}			
	}
}


/@
"Name: objective_type()"
"Summary: Handles the setting of 3d markers on objectives."
"Module: Objectives"
"CallOn: Level"
"Example: level thread objective_type();"
"SPMP: singleplayer"
@/
objective_type()
{
	n_objective = level.n_objective;
		
	if ( !IsString( level.str_objective_type ) )
	{
		// Assume level.str_objective_type is a custom localized string reference
		objective_set3d_prethink( n_objective, true, "default", level.str_objective_type );
		return;
	}
	
	switch ( level.str_objective_type )
	{
		case "active":
			Objective_Add( n_objective, "current", "", undefined, undefined, level.b_show_objective_message );
			break;
		
		case "done":
			Objective_State( n_objective, "done", level.b_show_objective_message );
			
			// Clear additional targets count
			if ( IsDefined( level.n_targets_objective ) && ( level.n_targets_objective == n_objective ) )
			{
				level.n_target_id = 0;
			}
			break;
			
		case "failed":
			Objective_State( n_objective, "failed", level.b_show_objective_message );
			break;
		
		case "delete":
			Objective_Delete( n_objective );
			break;
			
		case "remove":
			if ( IsDefined( level.target_id ) )
			{
				Objective_AdditionalPosition( n_objective, level.target_id, ( 0, 0, 0 ) );
			}
			else if ( IsDefined( level.objective_pos ) && IsDefined( level.objective_pos.is_breadcrumb ) )
			{
				objective_set3d_prethink( n_objective, false );
			}
			else if ( IsDefined( level.objective_pos ) && IsVec( level.objective_pos ) )
			{
				Objective_AdditionalPosition( n_objective, get_target_id( level.objective_pos ), ( 0, 0, 0 ) );
			}
			else
			{
				objective_set3d_prethink( n_objective, false );
			}
			break;
			
		case "interact":
			objective_set3d_prethink( n_objective, true, "white", &"SP_OBJECTIVES_INTERACT" );
			SetDvar( "objectiveIndicatorPerkFarFadeDist", 1024 );
			Objective_SetFlag( n_objective, "perk", true );
			break;
		
		case "defend":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_DEFEND" );
			Objective_SetFlag( n_objective, "fadeoutonscreen", true );
			break;
			
		case "follow":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_FOLLOW" );
			Objective_SetFlag( n_objective, "fadeoutonscreen", true );
			break;
			
		case "*":	// a single space
			objective_set3d_prethink( n_objective, true, "default", "*" );
			break;
			
		// Each case below is reserved by the system.
		case "":
		case "breadcrumb":
			objective_set3d_prethink( n_objective, true, "default" );
			break;
			
		default:
			objString = "SP_OBJECTIVES_"+ ToUpper(level.str_objective_type);
			objective_set3d_prethink( n_objective, true, "default", istring(objString) );
		break;
	}
}




/@
"Name: set_target_id( <n_target_id> )"
"Summary: Sets the index for Objective_AdditionalPosition for each objective target."
"Module: Objectives"
"CallOn: Level"
"Example: set_target_id( n_target_id );"
"SPMP: singleplayer"
@/
set_target_id( n_target_id )
{
	if ( !IsDefined( self.target_id ) )
	{
		self.target_id = n_target_id;
	}
}


/@
"Name: is_objective_pos_the_same( <pos1>, <pos2> )"
"Summary: Checks if the objective passed into set_objective is at the same position as the previous one."
"Module: Objectives"
"CallOn: Level"
"Example: is_objective_pos_the_same( level.objective_pos, pos );"
"SPMP: singleplayer"
@/
is_objective_pos_the_same(pos1, pos2)
{
	if (!IsDefined(pos1) && !IsDefined(pos2))
	{
		return true;
	}
	else if (IsDefined(pos1) && !IsDefined(pos2))
	{
		return false;
	}
	else if (!IsDefined(pos1) && IsDefined(pos2))
	{
		return false;
	}
	else if (IsSentient(pos1) && !IsSentient(pos2))
	{
		return false;
	}
	else if (!IsSentient(pos1) && IsSentient(pos2))
	{
		return false;
	}
	else if ( IsVec( pos1 ) && !IsVec( pos2 ) )
	{
		return false;
	}
	else if ( !IsVec( pos1 ) && IsVec( pos2 ) )
	{
		return false;
	}
	else if (pos1 != pos2)
	{
		return false;
	}

	return true;
}


/@
"Name: objective_breadcrumb( <n_obj_index>, <str_trig_targetname> )"
"Summary: Automatically advances a chain of triggered objective structs."
"Module: Objectives"
"CallOn: Level"
"Example: maps\_objectives::init();"
"SPMP: singleplayer"
@/
objective_breadcrumb( n_obj_index, str_trig_targetname )
{
	do
	{
		t_current = GetEnt( str_trig_targetname, "targetname" );
		
		if ( IsDefined( t_current ) )
		{		
			if ( IsDefined( t_current.target ) )
			{
				s_current = getstruct( t_current.target, "targetname" );
				
				if ( IsDefined( s_current ) )
				{
					set_objective( n_obj_index, s_current, "breadcrumb" );
				}
				else
				{
					set_objective( n_obj_index, t_current, "breadcrumb" );
				}
			}
			else
			{
				set_objective( n_obj_index, t_current, "breadcrumb" );
			}
			
			str_trig_targetname = t_current.target;
			t_current trigger_wait();
		}
		else
		{
			str_trig_targetname = undefined;
		}
	}
	while ( IsDefined( str_trig_targetname ) );
}


/@
"Name: objective_breadcrumb_area( <n_obj_index>, <str_area_name>, <str_endon> )"
"Summary: Automatically advances a chain of triggered objective structs based on your currently occupied area."
"Module: Objectives"
"CallOn: The entity to check against (e.g. Player or vehicle)"
"MandatoryArg: <n_obj_index> The index of the objective to update"
"MandatoryArg: <str_area_name> The targetname of the volumes or triggers to check against"
"MandatoryArg: <str_endon> The notify to end on."
"Example: level.vh_spiderbot thread maps\_objectives::objective_breadcrumb_area( level.OBJ_ENTER_CRC, "breadcrumb_spiderbot", "spiderbot_entered_crc" );"
"SPMP: singleplayer"
@/
//
//	This allows an objective marker to be specified while the player is within a certain area.
//	As the player travels forwards or backwards, a relevant destination will be shown.
//
//	self is either the player or the thing that should be touching (like a vehicle).
objective_breadcrumb_area( n_obj_index, str_area_name, str_endon )
{
	level endon( str_endon );

	assert( self != level, "objective_breadcrumb_area:: self needs to be the entity to check against, such as the player or a vehicle" );

	a_e_areas = GetEntArray( str_area_name, "targetname" );	// array of areas or triggers for this objective
	assert( a_e_areas.size > 1, "objective_breadcrumb_area:: there should be at least 2 areas to use this function" );

	e_curr_area = undefined;	// current active area
	e_last_area = undefined;	// last active area
	b_area_updated = false;		// do we need to update the current objective position?
	n_curr_obj = level.n_obj_index;

	// keep doing this until we've cleared the objective
	while( n_curr_obj == level.n_obj_index )
	{
		foreach( e_area in a_e_areas )
		{
			// If e_area is our current area, just skip it.
			// If the player is touching the area AND
			//	is not touching the last active area then make this area our new active area
			if ( IsDefined( e_curr_area ) && e_area == e_curr_area )
			{
				if ( !self IsTouching( e_curr_area ) )
				{
					e_curr_area = undefined;
					e_last_area = undefined;
				}
				continue;
			}
			
			// We need to keep track of the last area we were in, but only as long as we're still inside of it
			//	since it changed.  This is done to prevent the zones from flip-flopping in case there is some
			//	overlap in the areas.  Otherwise, you'd have to be very precise in your area placement.
			if ( IsDefined( e_last_area ) && e_area == e_last_area )
			{
				if ( !self IsTouching( e_last_area ) )
				{
					e_last_area = undefined;
				}
				continue;
			}
			
			// Otherwise, make the new area we're touching the new one.				
			if ( self IsTouching( e_area ) )
			{
				e_last_area = e_curr_area;
				e_curr_area = e_area;
				b_area_updated = true;
				break;
			}
		}

		// Update the current objective marker
		if ( b_area_updated )
		{
			b_area_updated = false;
			// point our objective to the current area's target objective
			s_dest = getstruct( e_curr_area.target, "targetname" );
			if ( IsDefined( s_dest ) )
			{
				set_objective( n_obj_index, s_dest, "breadcrumb" );
			}
			else
			{
				e_dest = GetEnt( e_curr_area.target, "targetname" );
				if ( IsDefined( e_dest ) )
				{
					set_objective( n_obj_index, e_dest, "breadcrumb" );
				}
			}
		}

		wait( 0.1 );
	}
}


//
//
objective_set3d_prethink( objective_number, use3D, color, alternate_text )
{
	//if the objective is not 3D we don't need to check for an offset
	if ( !use3D )
	{
		Objective_Set3D( objective_number, use3D );
		return;
	}
	
	if ( !IsDefined( color ) )
	{
		color = "default";
	}
	
	if( !IsDefined( alternate_text ) )
	{
		alternate_text = "";
	}
	
	position_offset = ( 0, 0, 0 );
	
	//if the 3D objective is an entity
	if( IsDefined( level.objective_pos ) && !IsVec( level.objective_pos ) )
	{
		if ( IS_VEHICLE( level.objective_pos ) )
		{
			switch ( level.objective_pos.vehicletype )
			{
				case "horse":
				case "horse_player":
				case "horse_player_low":
				case "horse_low":
					position_offset = ( 0, 0, 72 );
					break;
				case "tank_t62":
				case "tank_t62_nophysics":
				case "heli_hip":
				case "heli_hind_afghan":
				case "heli_hind_angola":					
				case "truck_rts_convoy":
					position_offset = ( 0, 0, 132 );
					break;
				case "apc_btr60":
					position_offset = ( -24, 0, 108 );
					break;
				case "plane_x78":
					position_offset = ( 96, 48, -75 );
					break;
				case "apc_cougar_gun_turret":
				case "apc_cougar_gun_turret_low":
				case "civ_van_sprinter_la2":
				case "civ_ambulance":
					position_offset = ( 0, 0, 225 );
					break;					
				case "plane_f35_fast_la2":
				case "plane_f35_fast_nocockpit":
					position_offset = ( 0, 0, 512 );
					break;							
				case "drone_metalstorm":
				case "drone_metalstorm_karma":
				case "drone_metalstorm_rts":
					position_offset = ( 0, 0, 65 );
			}
		}
		else if ( IS_EQUAL( level.objective_pos.classname, "trigger_radius" ) )
		{
			position_offset = ( 0, 0, level.objective_pos.height / 2 );
		}
		
		if(IsDefined(level.objective_pos.use_obj_offset))
		{
			position_offset = level.objective_pos.use_obj_offset;	
		}
	}
	
	Objective_Set3D( objective_number, use3D, color, alternate_text, -1, position_offset );      
}


//
//	Update Objective position or add an additional one
_objective_set_position( b_use_pos_origin )
{
	// Do we need to use the objective_pos itself or only its origin?
	if ( b_use_pos_origin )
	{
		objective_pos = level.objective_pos.origin;
	}
	else
	{
		objective_pos = level.objective_pos;
	}

	// Update position	
	if ( IsDefined( level.n_objective_targets ) )
	{
		if ( IsDefined( level.a_freed_obj_id ) ) //Used when you will have more than 8 targets - most of the logic lies in the level script
		{
			n_target_id = undefined;
			
			for( i = 0; i < level.a_freed_obj_id.size; i++ )
			{
				if ( !level.a_freed_obj_id[i] )
				{
					n_target_id = i;
				}
			}
			
			Assert( IsDefined( n_target_id ), "Ran out of positions for a new objective in _objective_set_position()" );
			
			if ( !isVec( objective_pos ) )
			{
				objective_pos.n_obj_id = n_target_id;	
			}
			else
			{
				level notify( "multi_objective_set", n_target_id );
			}
		}
		else
		{
			n_target_id = level.n_target_id;
		}
		
		Objective_AdditionalPosition( level.n_objective, n_target_id, objective_pos );
		level.objective_pos thread set_target_id( n_target_id );
			
	}
	else
	{
		// If objective_pos is an ent, it will update continuously, otherwise if it's a vector, it won't.
		Objective_Position( level.n_objective, objective_pos );
		if ( !IsVec( level.objective_pos ) )
		{
			level.objective_pos.is_breadcrumb = true;
		}
	}
}
