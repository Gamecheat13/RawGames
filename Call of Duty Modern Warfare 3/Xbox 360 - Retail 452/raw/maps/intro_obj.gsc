#include common_scripts\utility;
#include maps\_utility;

intro_objectives()
{
	flag_init( "obj_take_position_on_balcony");
	flag_init( "obj_watch_courtyard" );
	flag_init( "obj_exit_hotel" );
	flag_init( "obj_get_to_helicopter" );
	flag_init( "obj_destroy_ugv" );
	flag_init( "obj_control_ugv" );
	flag_init( "obj_clear_helicopter_area" );
	flag_init( "obj_clear_helicopter_area_complete" );

	wait 1;
	waittillframeend;
	
	// add/remove lines here to add/remove objectives.
	// [ objective name, objective string, objective function, override_objective_id ]
	objective_table = [];
	//objective_table[ objective_table.size ] = [ "obj_balcony", "Take up a position on the balcony.", ::objective_take_position_on_balcony, 0 ];
	objective_table[ objective_table.size ] = [ "obj_defend_courtyard", &"INTRO_OBJ_DEFEND_COURTYARD", ::objective_defend_courtyard, 0 ];
	objective_table[ objective_table.size ] = [ "obj_help_soap", &"INTRO_OBJ_HELP_SOAP", ::objective_help_soap ];
	objective_table[ objective_table.size ] = [ "obj_exit_hotel", &"INTRO_OBJ_EXIT_HOTEL", ::objective_exit_hotel ];
	objective_table[ objective_table.size ] = [ "obj_weapons_cache", &"INTRO_OBJ_WEAPON_CACHE", ::objective_control_ugv ];
	objective_table[ objective_table.size ] = [ "obj_control_ugv", &"INTRO_OBJ_CONTROL_UGV", ::objective_take_control_of_ugv ];
	objective_table[ objective_table.size ] = [ "obj_clear_helicopter_area", &"INTRO_OBJ_CLEAR_HELICOPTER", ::objective_clear_helicopter_area ];
	objective_table[ objective_table.size ] = [ "obj_get_to_helicopter", &"INTRO_OBJ_HELICOPTER", ::objective_get_to_helicopter ];
	
	// objectives based on start point
	starting_objective = [];
	starting_objective[ "default" ] = "obj_defend_courtyard";
	starting_objective[ "intro" ] = "obj_defend_courtyard";
	starting_objective[ "intro transition" ] = "obj_defend_courtyard";
	starting_objective[ "courtyard" ] = "obj_defend_courtyard";
	starting_objective[ "escort" ] = "obj_help_soap";
	starting_objective[ "regroup" ] = "obj_weapons_cache";
	starting_objective[ "maars shed" ] = "obj_weapons_cache";
	starting_objective[ "maars control" ] = "obj_control_ugv";
	starting_objective[ "slide" ] = "obj_get_to_helicopter";
	
	// create objectives
	objective_id = 1;
	is_complete = true;
	foreach ( objective in objective_table )
	{
		is_complete = ( is_complete && ( !IsDefined( starting_objective[ level.start_point ] ) || starting_objective[ level.start_point ] != objective[0] ) );
		
		// allow objective id's to be overridden, then it will count up from the last overridden objective id
		if ( IsDefined( objective[3] ) )
		{
			objective_id = objective[3];
		}
		
		create_intro_objective( objective_id, objective[1], objective[2], is_complete );
		objective_id++;
	}
}

objective_take_position_on_balcony( objective_id, objective_text )
{
	flag_wait( "obj_take_position_on_balcony" );
	
	if( !flag( "courtyard_player_on_balcony" ) )
	{
		Objective_Add( objective_id, "current", objective_text );
		
		objective_pos = getstruct( "courtyard_balcony_objective", "targetname" );
		if ( IsDefined( objective_pos ) )
		{
			Objective_Position( objective_id, objective_pos.origin );
		}
		
		flag_wait( "courtyard_player_on_balcony" );
		
		objective_complete( objective_id );
	}
}

objective_defend_courtyard( objective_id, objective_text )
{
	flag_wait( "obj_watch_courtyard" );
	
	Objective_Add( objective_id, "current", objective_text );

/*
	breach_door_position = GetStruct( "breach_door_position", "targetname" );
	if ( IsDefined( breach_door_position ) )
	{
		flag_wait( "courtyard_doors_breach");
		Objective_Position( objective_id, breach_door_position.origin );
	}
	*/
	
	//flag_wait( "courtyard_doors_breach");
//	Objective_Position( objective_id, ( 0,0,0 ) );
	
	flag_wait( "escort_doc_down_mi28_fire" );
	objective_complete( objective_id );
}

objective_help_soap( objective_id, objective_text )
{
	flag_wait( "escort_player_help_soap" );
	
	Objective_Add( objective_id, "current", objective_text );

	obj_pos = GetStruct( "escort_help_soap_obj", "targetname" );
	if ( IsDefined( obj_pos ) )
	{
		//objective_onentity( objective_id, level.price );
		Objective_Position( objective_id, obj_pos.origin );
		objective_setpointertextoverride( objective_id, &"INTRO_HELP" );
	}
	
	flag_wait( "escort_help_soap_complete" );
	objective_complete( objective_id );
}

objective_exit_hotel( objective_id, objective_text )
{
	flag_wait( "obj_exit_hotel" );
	
	Objective_Add( objective_id, "current", objective_text );

	breach_door_position = GetStruct( "breach_door_position", "targetname" );
	if ( IsDefined( breach_door_position ) )
	{
		objective_onentity( objective_id, level.price );
		//Objective_Position( objective_id, breach_door_position.origin );
	}
	
	flag_wait( "obj_exit_hotel_complete" );
	objective_complete( objective_id );
}


objective_control_ugv( objective_id, objective_text )
{
	flag_wait( "obj_control_ugv" );
	
	Objective_Add( objective_id, "current", objective_text );
	
	obj_position = GetStruct( "regroup_objective_alley", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	flag_wait( "regroup_player_moving_down_alleyway" );
	
	
	obj_position = GetStruct( "obj_alley_gate", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	flag_wait( "regroup_player_at_gate" );
	
	Objective_Position( objective_id, ( 0, 0, 0 ) );
	
	flag_wait( "regroup_ending_follow_price" );
	
	objective_onentity( objective_id, level.price );
	
	flag_wait( "maars_control_start_intro" );
	
	obj_position = GetStruct( "obj_ugv_room", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	objective_complete( objective_id );
}


objective_take_control_of_ugv( objective_id, objective_text )
{
	flag_wait( "player_to_maars_control" );
	
	Objective_Add( objective_id, "current", objective_text );
	
	obj_position = GetStruct( "obj_control_ugv", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	flag_wait( "maars_control_player_controlling_maars");
	Objective_Position( objective_id, ( 0, 0, 0 ) );
	flag_wait( "maars_loaded" );
	objective_complete( objective_id );
}




objective_clear_helicopter_area( objective_id, objective_text )
{
	flag_wait( "obj_clear_helicopter_area" );
	
	Objective_Add( objective_id, "current", objective_text );

	obj_position = GetStruct( "obj_get_to_helicopter", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	flag_wait( "maars_control_player_at_helicopter" );
	obj_position = GetStruct( "obj_protect_helicopter", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
		objective_setpointertextoverride( objective_id, &"INTRO_PROTECT"  );
	}
	
	flag_wait( "obj_clear_helicopter_area_complete");
	objective_complete( objective_id );
}

objective_get_to_helicopter( objective_id, objective_text )
{
	flag_wait( "obj_clear_helicopter_area_complete" );
	
	Objective_Add( objective_id, "current", objective_text );


	obj_position = GetStruct( "obj_get_to_helicopter", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	/*
	obj_position = GetStruct( "obj_run1", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	flag_wait( "obj_run2" );
	
	obj_position = GetStruct( "obj_run2", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	
	flag_wait( "obj_run3" );
	
	obj_position = GetStruct( "obj_run3", "targetname" );
	if ( IsDefined( obj_position ) )
	{
		Objective_Position( objective_id, obj_position.origin );
	}
	*/
	flag_wait( "building_slide_pickup" );
	objective_complete( objective_id );
}


create_intro_objective( objective_id, objective_text, objective_logic, is_complete )
{
	if ( !is_complete )
	{
		if ( IsDefined( objective_logic ) )
		{
			[[objective_logic]]( objective_id, objective_text );
		}
	}
	else
	{
		Objective_Add( objective_id, "invisible", objective_text );
		Objective_State_NoMessage( objective_id, "done" );
	}
}
