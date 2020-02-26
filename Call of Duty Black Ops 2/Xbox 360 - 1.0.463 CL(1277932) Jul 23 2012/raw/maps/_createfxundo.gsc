#include common_scripts\utility;
#include maps\_utility;
#include maps\_createfx;
#include maps\_createfxMenu;

// level.cfx_undo_states[] - an array of ents, each containing an undo state array.
// level.cfx_redo_states[] - an array of ents, each containing an redo state array.

// TODO: Pasting a bunch of ents, then selecting by fxid, then moving those selected effects,
//	then deleting them produces a state error.  The deletion will undo just fine, but 
//	the translation does not seem to be recorded and all the states get messed up before then.

// TODO: Are states being skipped sometimes? Or placed out of order when undoing or redoing? Check if this is happening!

// Stores the current state of ents.  Should only be called just before a change is made 
// that differs from the last change made (rotation change to a translation change, property 
// change to a rotation change, etc.), or upon deletion (with the deleted ents), or upon 
// addition (with the added ents).
//
// PARAMETERS
// change_type - "edit", "add", or "delete".  Represents the operation to be undone.
// ents - an array of ent structs containing pre-change info.

/#
store_undo_state(change_type, ents)
{
	if ( !isdefined( level.cfx_undo_states ) )
	{
		level.cfx_undo_states = [];
		level.cfx_redo_states = [];
		level.cfx_limbo_state = SpawnStruct();
		level.cfx_max_states = 10;
	}
	if ( !isArray(ents) )
	{
		ents = array(ents);
	}
	temp_array = [];
	for (i=0; i < ents.size; i++)
	{
		temp_array[i] = copy_fx_ent( ents[i] );
	}
	state = SpawnStruct();
	state.operation = change_type;
	state.last_action = level.cfx_last_action;
	state.ent_array = temp_array;
	
	if ( level.cfx_undo_states.size >= level.cfx_max_states )
	{
		level.cfx_undo_states = array_drop( level.cfx_undo_states);
	}
	level.cfx_undo_states[level.cfx_undo_states.size] = state;
	level.cfx_redo_states = [];
	level.cfx_limbo_state = undefined;
	
	debug_print_latest_state( "undo" );
}

undo()
{
	if ( !isdefined( level.createFXent) || !isdefined( level.cfx_undo_states ) || level.cfx_undo_states.size < 1 )
	{
		return;
	}
	revert_state = level.cfx_undo_states[level.cfx_undo_states.size-1];
	
	if ( level.cfx_last_action != "none" )	// store pending actions so we can redo back to them
	{
		store_undo_state("edit", level.selected_fx_ents);
		move_undo_state_to_redo();
		clear_entity_selection("skip_undo");
		apply_state_change( "undo", revert_state );
		move_undo_state_to_limbo();
		level.cfx_last_action = "none";
	}
	else	// there are no pending actions
	{
		clear_entity_selection("skip_undo");
		
		if ( revert_state.operation != "edit" )	// "add" and "delete" undos are handled differently
		{
			apply_state_change( "undo", revert_state );
			move_undo_state_to_redo();
			level.cfx_last_action = "none";
			//level.cfx_limbo_state = undefined;	// performed in apply_state_change()
		}
		else
		{
			if ( isdefined (level.cfx_limbo_state) )
			{
				move_limbo_state_to_redo();
				apply_state_change( "undo", revert_state );
				move_undo_state_to_limbo();
				level.cfx_last_action = "none";
			}
			else
			{
				if ( level.cfx_undo_states.size > 1 )	// need two undo states to do this
				{
					move_undo_state_to_redo();
					revert_state = level.cfx_undo_states[level.cfx_undo_states.size-1];
				}
				apply_state_change( "undo", revert_state );
				move_undo_state_to_limbo();
			}
		}
	}
	//level.cfx_last_action = "none";
}

// Applies revert_state (which should be an ent) to the current state.
// type should be "undo" or "redo", whichever action has been initiated by the user.
apply_state_change( type, revert_state )
{
	if ( type == "undo" )
	{
		println("^2CreateFX: Undo operation: " + revert_state.operation + ":" + revert_state.last_action);
		
		if ( revert_state.operation == "edit" )
		{
			undo_edit( revert_state.ent_array );
		}
		else if ( revert_state.operation == "add" )
		{
			undo_add( revert_state.ent_array );
		}
		else if ( revert_state.operation == "delete" )
		{
			undo_delete( revert_state.ent_array );
		}
	}
	else // if type == "redo"
	{
		println("^2CreateFX: Redo operation: " + revert_state.operation + ":" + revert_state.last_action);
		
		if ( revert_state.operation == "edit" )
		{
			undo_edit( revert_state.ent_array );
		}
		else if ( revert_state.operation == "add" )
		{
			undo_delete( revert_state.ent_array );
		}
		else if ( revert_state.operation == "delete" )
		{
			undo_add( revert_state.ent_array );
		}
	}
}

// Pop the last undo state and plop it onto the redo stack
move_undo_state_to_redo()
{
	if ( level.cfx_redo_states.size >= level.cfx_max_states )
	{
		level.cfx_redo_states = array_drop(level.cfx_redo_states);
	}
	level.cfx_redo_states[level.cfx_redo_states.size] = level.cfx_undo_states[level.cfx_undo_states.size-1];
	level.cfx_undo_states = array_pop(level.cfx_undo_states);
	
	debug_print_latest_state( "undo" );
	debug_print_latest_state( "redo" );
}

// Pop the last redo state and plop it onto the undo stack
move_redo_state_to_undo()
{
	if ( level.cfx_undo_states.size >= level.cfx_max_states )
	{
		level.cfx_undo_states = array_drop(level.cfx_undo_states);
	}
	level.cfx_undo_states[level.cfx_undo_states.size] = level.cfx_redo_states[level.cfx_redo_states.size-1];
	level.cfx_redo_states = array_pop(level.cfx_redo_states);
	
	debug_print_latest_state( "undo" );
	debug_print_latest_state( "redo" );
}

move_undo_state_to_limbo()
{
	level.cfx_limbo_state = level.cfx_undo_states[level.cfx_undo_states.size-1];
	level.cfx_undo_states = array_pop(level.cfx_undo_states);
	
	debug_print_latest_state( "undo" );
	debug_print_latest_state( "limbo" );
}

move_redo_state_to_limbo()
{
	level.cfx_limbo_state = level.cfx_redo_states[level.cfx_redo_states.size-1];
	level.cfx_redo_states = array_pop(level.cfx_redo_states);
	
	debug_print_latest_state( "redo" );
	debug_print_latest_state( "limbo" );
}

move_limbo_state_to_undo()
{
	if ( level.cfx_undo_states.size >= level.cfx_max_states )
	{
		level.cfx_undo_states = array_drop(level.cfx_undo_states);
	}
	level.cfx_undo_states[level.cfx_undo_states.size] = level.cfx_limbo_state;
	level.cfx_limbo_state = undefined;
	//level.cfx_undo_states = array_pop(level.cfx_undo_states);
	
	debug_print_latest_state( "undo" );
	debug_print_latest_state( "limbo" );
}

move_limbo_state_to_redo()
{
	if ( level.cfx_redo_states.size >= level.cfx_max_states )
	{
		level.cfx_redo_states = array_drop(level.cfx_redo_states);
	}
	level.cfx_redo_states[level.cfx_redo_states.size] = level.cfx_limbo_state;
	level.cfx_limbo_state = undefined;
	//level.cfx_redo_states = array_pop(level.cfx_redo_states);
	
	debug_print_latest_state( "redo" );
}

// Writes over ents in createFXent[] with the values in ent_array[]
undo_edit( ent_array )
{
	ent_array = reorder_ent_array_by_uniqueid( ent_array );
	
	debug_print_ent_array( ent_array, "ent_array[]" );
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
	
	last_id = ent_array[ent_array.size-1].uniqueid;
	
	if ( last_id > level.createFXent.size-1 )
	{
		last_id = level.createFXent.size-1;
	}
	j = ent_array.size-1;
	source_ent = ent_array[j];
	
	for ( i=last_id; i >= 0; i-- )
	{
		target_ent = level.createFXent[i];
		if ( source_ent.uniqueid == target_ent.uniqueid )
		{
			// Since default ent assignment operation is to copy by reference, force copy by value.
			// Otherwise, weird things happen.
			copy_values_between_fx_ents( source_ent, target_ent );
			select_entity( i, target_ent, "skip_undo" );
			j--;
			if ( j < 0 )
			{
				break;
			}
			source_ent = ent_array[j];
		}
	}
	update_selected_entities();

	println("^1CreateFX: Finished edit");
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
}

// Removes by index (stored in the ents themselves) ents from level.createFXent[].
undo_add( ent_array )
{
	ent_array = reorder_ent_array_by_uniqueid( ent_array );
	
	debug_print_ent_array( ent_array, "ent_array[]" );
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
	
	last_id = ent_array[ent_array.size-1].uniqueid;
	
	if ( last_id > level.createFXent.size-1 )
	{
		last_id = level.createFXent.size-1;
	}
	j = ent_array.size-1;
	source_ent = ent_array[j];
	
	for ( i=last_id; i >= 0; i-- )
	{
		target_ent = level.createFXent[i];
		if ( source_ent.uniqueid == target_ent.uniqueid )
		{
			if (isdefined(target_ent.looper))
			{
				target_ent.looper delete();
			}
			target_ent notify( "stop_loop" );
			level.createFXent[i] = undefined;
			j--;
			if ( j < 0 )
			{
				break;
			}
			source_ent = ent_array[j];
		}
	}
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
	println("createfx: Starting array_remove_undefined()");
	
	ArrayRemoveValue( level.createFXent, undefined );
	
	println("^1CreateFX: Finished undo add.");
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
	clear_fx_hudElements();
	
//	for (i = 0; i < ent_array.size; i++)
//	{
//		ent = level.createFXent[ent_array[i].last_fx_index];
//		
//		if (isdefined(ent.looper))
//		{
//			ent.looper delete();
//		}
//		ent notify( "stop_loop" );
//		//level.createFXent[ent_array[i].last_fx_index] = undefined;
//		// Have to remove an index at a time to deal with the array.size issue
//		ArrayRemoveIndex(level.createFXent, ent_array[i].last_fx_index);
//	}
//	clear_fx_hudElements();
//	fix_createfxent_index();
}

// Inserts ent_array[] ents into level.createFXent[].
// TODO: does not re-add ents in the proper order
undo_delete( ent_array )
{
	debug_print_ent_array( ent_array, "ent_array in undo_delete()" );
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
	
	ent_array = reorder_ent_array_by_uniqueid( ent_array );
	
	if ( level.createFXent.size == 0 )
	{
		for ( i=0; i < ent_array.size; i++ )
		{
			level.createFXent[i] = copy_fx_ent( ent_array[i] );
		}
	}
	else
	{
		temp_array = [];
		
//		while ( i < ent_array.size && ent_array[i].uniqueid < level.createFXent[0].uniqueid )
//		{
//			temp_array[temp_array.size] = copy_fx_ent( ent_array[i] );
//			i++;
//		}
		i = 0;
		for ( j=0; j < level.createFXent.size; j++ )
		{
			target_ent = level.createFXent[j];
			
			if ( i >= ent_array.size )
			{
				temp_array[temp_array.size] = target_ent;
				continue;
			}
			source_ent = ent_array[i];
			
			if ( target_ent.uniqueid < source_ent.uniqueid )
			{
				temp_array[temp_array.size] = target_ent;
			}
			else
			{
				temp_array[temp_array.size] = copy_fx_ent( source_ent );
				j--;
				i++;
			}
		}
		for ( ; i < ent_array.size; i++ )	// check to make sure the rest of ent_array is undeleted
		{
			temp_array[temp_array.size] = ent_array[i];
		}
		level.createFXent = temp_array;
	}
		
//		for ( ; i < ent_array.size; i++ )
//		{
//			source_ent = ent_array[i];
//			
//			for ( ; j < level.createFXent.size; j++ )
//			{
//				target_ent = level.createFXent[j];
//				
//				if ( target_ent.uniqueid < source_ent.uniqueid )
//				{
//					temp_array[temp_array.size] = target_ent;
//				}
//				else
//				{
//					temp_array[temp_array.size] = copy_fx_ent( source_ent );
//					j++;
//					break;
//				}
//			}
//		}
//		for ( ; j < level.createFXent.size; j++ )	// check to make sure all ents are copied over to temp_array[]
//		{
//			temp_array[temp_array.size] = level.createFXent[j];
//		}
	
	println("^1Createfx: Finished undoing delete, pre-selection");
	debug_print_ent_array( level.createFXent, "level.createFXent[]" );
	
	
	// Now, select the ents that were just added. This is just in case doing it while generating 
	// temp_array[] would cause issues.
	last_id = ent_array[ent_array.size-1].uniqueid;
	
	if ( last_id > level.createFXent.size-1 )
	{
		last_id = level.createFXent.size-1;
	}
	j = ent_array.size-1;
	source_ent = ent_array[j];
	
	for ( i=last_id; i >= 0; i-- )
	{
		target_ent = level.createFXent[i];
		if ( source_ent.uniqueid == target_ent.uniqueid )
		{
			target_ent post_entity_creation_function();
			select_entity( i, target_ent, "skip_undo" );
			j--;
			if ( j < 0 )
			{
				break;
			}
			source_ent = ent_array[j];
		}
	}
	update_selected_entities();
}

// Restores a future state.
redo()
{
	if ( !isdefined( level.createFXent) || !isdefined( level.cfx_redo_states ) || level.cfx_redo_states.size < 1 )
	{
		return;
	}
	clear_entity_selection("skip_undo");
	
	if ( isdefined(level.cfx_limbo_state ) )
	{
		move_limbo_state_to_undo();
		move_redo_state_to_limbo();
		apply_state_change( "redo", level.cfx_limbo_state );
		//array_pop( level.cfx_redo_states );
	}
	else	// last operation was an undo or redo of an add or delete
	{
		revert_state = level.cfx_redo_states[level.cfx_redo_states.size-1];
		apply_state_change( "redo", revert_state );
		
		if ( revert_state.operation == "edit" )
		{
			move_redo_state_to_limbo();
		}
		else
		{
			move_redo_state_to_undo();
		}
	}
	level.cfx_last_action = "none";
	
//	if ( level.cfx_last_action != "none" )	// store pending actions so we can undo back to them
//	{
//		store_undo_state("edit", level.selected_fx_ents);
//		level.cfx_last_action = "none";
//	}
//	
//	revert_state = level.cfx_redo_states[level.cfx_redo_states.size-1];
//	level.cfx_last_action = revert_state.last_undo_state;
//	clear_entity_selection("skip_undo");
//	
//	apply_state_change( "redo", revert_state );
//	move_redo_state_to_undo();
}

//fix_createfxent_index()
//{
//	for ( i=0; i < level.createFXent.size; i++ )
//	{
//		level.createFXent[i].last_fx_index = i;
//	}
//}

// reorders fx ents by uniqueid from lowest to highest
reorder_ent_array_by_uniqueid( ent_array )
{
	if ( ent_array.size <= 1 )
	{
		return ent_array;
	}
	array_size = ent_array.size;
	for ( i=0; i < array_size-1; i++ )
	{
		for ( j=i+1; j < array_size; j++ )
		{
			if ( ent_array[i].uniqueid > ent_array[j].uniqueid )
			{
				temp_ent = ent_array[i];
				ent_array[i] = ent_array[j];
				ent_array[j] = temp_ent;
			}
		}
	}
	return ent_array;
}

// Duplicates an fx ent to (kind of) pass it by value.
copy_fx_ent( ent )
{
	temp_ent = SpawnStruct();
	temp_ent.drawn = ent.drawn;
	temp_ent.drawn_axis_model = ent.drawn_axis_model;
	//temp_ent.looper = ent.looper;
	temp_ent.last_fx_index = ent.last_fx_index;
	temp_ent.textalpha = ent.textalpha;
	temp_ent.uniqueid = ent.uniqueid;
	temp_ent.v = ent.v;
	return temp_ent;
}

// Copies values from one ent to another without creating a new ent.
copy_values_between_fx_ents( source, dest )
{
	dest.drawn = source.drawn;
	dest.drawn_axis_model = source.drawn_axis_model;
	//dest.looper = source.looper;	// duplicating this creates duplicate effects, so don't do it
	dest.last_fx_index = source.last_fx_index;
	dest.textalpha = source.textalpha;
	dest.v = source.v;
	return dest;
}

// Removes the last element from the given array and returns the new array.
array_pop( array )
{
	array_size = array.size - 1;
	temp_array = [];
	
	if ( array_size <= 0 )
	{
		return temp_array;
	}
	
	for ( i=0; i < array_size; i++ )
	{
		temp_array[i] = array[i];
	}
	array = temp_array;
	return array;
}

// Removes the first element from the given array and returns the new array.
array_drop( array )
{
	if ( array.size > 0 )
	{
		temp_array = [];
		
		for ( i=1; i < array.size; i++ )
		{
			temp_array[i-1] = array[i];
		}
		array = temp_array;
	}
	return array;
}

// ---------------------------DEBUG STUFF------------------------------- //
debug_print_ent_array( array, name )
{
	if (isdefined(name))
	{
		println("Printing out " + name);
	}
	else
	{
		println("Printing out some array");
	}

	for (i=0; i < array.size; i++)
	{
		if ( !isdefined( array[i] ) )
		{
			println ( "" + i + ": deleted effect" );
			continue;
		}
		println( "" + i + ": uniqueid: " + array[i].uniqueid + "  fxid: " + array[i].v["fxid"] );
	}
}

debug_print_latest_state( type )
{
	println("^3Saving " + type + " state");
	
	if ( type == "undo" )
	{
		if ( !isdefined(level.cfx_undo_states[level.cfx_undo_states.size-1]) )
		{
			println("There are no undo states.");
			return;
		}
		state = level.cfx_undo_states[level.cfx_undo_states.size-1];
		size = level.cfx_undo_states.size-1;
	}
	else if ( type == "redo" )
	{
		if ( !isdefined(level.cfx_redo_states[level.cfx_redo_states.size-1]) )
		{
			println("There are no redo states.");
			return;
		}
		state = level.cfx_redo_states[level.cfx_redo_states.size-1];
		size = level.cfx_redo_states.size-1;
	}
	else
	{
		if ( !isdefined(level.cfx_limbo_state) )
		{
			println("There is no limbo state.");
			return;
		}
		state = level.cfx_limbo_state;
		size = 0;
	}
	println( "State " + size + " - " + state.operation + ": " + state.last_action );
	debug_print_ent_array( state.ent_array, "save state ent_array" );
}
#/