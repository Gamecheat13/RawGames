#include common_scripts\utility;
#include maps\_utility;

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
		
		if ( level.script == "la_1" || level.script == "la_1b" || level.script == "la_2" )
		{
			// TODO: TEMP for GL
			s_info.b_show_message = false;
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
	
	for ( i = 0; i < level.objective_queue.size; i++ )
	{
		level.objective_queue[ i ] = level.objective_queue[ i + 1 ];
	}
	
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
	str_type = undefined;
	pos = undefined;
	n_targets = undefined;
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
				Objective_Add( n_objective, "current", "", undefined, undefined, level.b_show_objective_message );
				level.a_obj_addstate[ n_objective ] = 1;
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
				if ( n_current_obj != n_objective )
				{
					level.n_target_id = 0;
					
					if ( IsVec( level.objective_pos ) )
					{
						if ( level.a_obj_addstate[ n_objective ] != 1 )
						{
							Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], undefined, undefined, level.b_show_objective_message );
							level.a_obj_addstate[ n_objective ] = 1;
							
							if ( IsDefined( level.n_objective_targets ) )
							{
								Objective_AdditionalPosition( n_objective, level.n_target_id, level.objective_pos );
								set_vectarget_id( level.objective_pos, level.n_target_id );
							}
							else
							{
								Objective_Position( n_objective, level.objective_pos );
								//level.objective_pos.is_breadcrumb = true;
							}
						}
					}						
					else if ( IsSentient( level.objective_pos ) || IS_VEHICLE( level.objective_pos ) )
					{
						if ( level.a_obj_addstate[ n_objective ] != 1 )
						{
							Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], undefined, undefined, level.b_show_objective_message );
							level.a_obj_addstate[ n_objective ] = 1;
							
							if ( IsDefined( level.n_objective_targets ) )
							{
								Objective_AdditionalPosition( n_objective, level.n_target_id, level.objective_pos );
								level.objective_pos thread set_target_id( level.n_target_id );
							}
							else
							{
								Objective_Position( n_objective, level.objective_pos );
								level.objective_pos.is_breadcrumb = true;
							}
						}
					}
					else if ( IsDefined( level.objective_pos.classname ) && ( level.objective_pos.classname == "script_model" ) )
					{
						if ( level.a_obj_addstate[ n_objective ] != 1 )
						{
							Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], undefined, undefined, level.b_show_objective_message );
							level.a_obj_addstate[ n_objective ] = 1;
							
							if ( IsDefined( level.n_objective_targets ) )
							{
								Objective_AdditionalPosition( n_objective, level.n_target_id, level.objective_pos );
								level.objective_pos thread set_target_id( level.n_target_id );
							}
							else
							{
								Objective_Position( n_objective, level.objective_pos );
								level.objective_pos.is_breadcrumb = true;
							}
						}
					}
					else
					{
						if ( level.a_obj_addstate[ n_objective ] != 1 )
						{
							Objective_Add( n_objective, "current", level.a_objectives[ n_objective ], level.objective_pos.origin, undefined, level.b_show_objective_message );
							level.a_obj_addstate[ n_objective ] = 1;
							level.objective_pos thread set_target_id( level.n_target_id );
						}
					}
				}
				else
				{
					if ( IsDefined( level.n_target_id ) && IsDefined( level.n_objective_targets ) )
					{
						level.n_target_id++;
					}
					
					if ( IsVec( level.objective_pos ) )
					{
						if ( IsDefined( level.n_objective_targets ) )
						{
							Objective_AdditionalPosition( n_objective, level.n_target_id, level.objective_pos );
							set_vectarget_id( level.objective_pos, level.n_target_id );
						}
						else
						{
							Objective_Position( n_objective, level.objective_pos );
							//level.objective_pos.is_breadcrumb = true;
						}
					}
					else if ( IsSentient( level.objective_pos ) || IS_VEHICLE( level.objective_pos ) )
					{
						if ( IsDefined( level.n_objective_targets ) )
						{
							Objective_AdditionalPosition( n_objective, level.n_target_id, level.objective_pos );
							level.objective_pos thread set_target_id( level.n_target_id );
						}
						else
						{
							Objective_Position( n_objective, level.objective_pos );
							level.objective_pos.is_breadcrumb = true;
						}
					}
					else if ( IsDefined( level.objective_pos.classname ) && ( level.objective_pos.classname == "script_model" ) )
					{
						if ( IsDefined( level.n_objective_targets ) )
						{
							Objective_AdditionalPosition( n_objective, level.n_target_id, level.objective_pos );
							level.objective_pos thread set_target_id( level.n_target_id );
						}
						else
						{
							Objective_Position( n_objective, level.objective_pos );
							level.objective_pos.is_breadcrumb = true;
						}
					}
					else
					{
						if ( IsDefined( level.n_objective_targets ) )
						{
							Objective_AdditionalPosition( n_current_obj, level.n_target_id, level.objective_pos.origin );
							level.objective_pos thread set_target_id( level.n_target_id );
						}
						else
						{
							Objective_Position( n_objective, level.objective_pos.origin );
							level.objective_pos.is_breadcrumb = true;
						}
					}
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
		
		if ( IsDefined( level.objective_pos ) )
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
		str_type = level.str_objective_type;
		n_targets = level.n_objective_targets;
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
		case "breach":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_BREACH" );
			break;

		case "disable":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_DISABLE" );
			break;

		case "melee":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_MELEE" );
			break;

		case "rappel":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_RAPPEL" );
			break;
			
		case "destroy":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_DESTROY" );
			break;
			
		case "defend":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_DEFEND" );
			Objective_SetFlag( n_objective, "fadeoutonscreen", true );
			break;
			
		case "enter":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_ENTER" );
			break;
			
		case "follow":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_FOLLOW" );
			Objective_SetFlag( n_objective, "fadeoutonscreen", true );
			break;
			
		case "kill":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_KILL" );
			break;
			
		case "pickup":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_PICKUP" );
			break;
			
		case "protect":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_PROTECT" );
			break;
			
		case "shoot":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_SHOOT" );
			break;
			
		case "support":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_SUPPORT" );
			break;
			
		case "target":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_TARGET" );
			break;
			
		case "use":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_USE" );
			break;
			
		case "regroup":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_REGROUP" );
			break;
			
		case "jump":
			objective_set3d_prethink( n_objective, true, "default", &"SP_OBJECTIVES_JUMP" );
			break;
			
		case "interact":
			objective_set3d_prethink( n_objective, true, "blue", &"SP_OBJECTIVES_INTERACT" );
			SetDvar( "objectiveIndicatorPerkFarFadeDist", 1024 );
			Objective_SetFlag( n_objective, "perk", true );
			break;
		
		// Each case below is reserved by the system.
		case "":
			objective_set3d_prethink( n_objective, true, "default" );
			break;
			
		case "breadcrumb":
			objective_set3d_prethink( n_objective, true, "default" );
			break;
		
		case "done":
			Objective_State( n_objective, "done", level.b_show_objective_message );
			break;
		
		case "delete":
			Objective_Delete( n_objective );
			break;
			
		case "remove":
			if ( IsDefined( level.objective_pos )  && IsDefined( level.objective_pos.target_id ) )
			{
				Objective_AdditionalPosition( n_objective, level.objective_pos.target_id, ( 0, 0, 0 ) );
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
			
		case "active":
			Objective_Add( n_objective, "current", "", undefined, undefined, level.b_show_objective_message );
			break;
			
		default: AssertMsg( "Unsupported objective type: '" + level.str_objective_type + "'." );
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
"Name: objective_breadcrumb( <n_obj_index>, <str_first_trig_name> )"
"Summary: Automatically advances a chain of triggered objective structs."
"Module: Objectives"
"CallOn: Level"
"Example: maps\_objectives::init();"
"SPMP: singleplayer"
@/
objective_breadcrumb( n_obj_index, str_first_trig_name )
{
	trigger_wait( str_first_trig_name );
	
	b_last_breadcrumb = false;
	t_current = GetEnt( str_first_trig_name, "targetname" );
	s_current = getstruct( t_current.target, "targetname" );
	
	while ( !b_last_breadcrumb )
	{
		t_next = GetEnt( t_current.target, "targetname" );
		s_current = getstruct( t_current.target, "targetname" );
		if ( IsDefined( s_current ) )
		{
			set_objective( n_obj_index, s_current, "breadcrumb" );
		}
		else
		{
			set_objective( n_obj_index, t_next, "breadcrumb" );
		}
		
		t_next waittill( "trigger" );
		
		if( !IsDefined( t_next.target ) )
		{
			b_last_breadcrumb = true;
		}
		else
		{
			t_current = t_next;
		}
	}
}

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
			switch( level.objective_pos.vehicletype )
			{
				case "horse":
				case "horse_player":
					position_offset = ( 0, 0, 72 );
					break;
				case "tank_t62":
					position_offset = ( 0, 0, 132 );
					break;
			}
		}
	}
	
	Objective_Set3D( objective_number, use3D, color, alternate_text, -1, position_offset );      
}


