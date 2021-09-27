#include common_scripts\utility;
#include maps\_utility;

// objectives
warlord_objectives()
{
	//objective flags
	flag_init( "obj_first_follow_price" );
	flag_init( "obj_take_overwatch_position" );
	flag_init( "obj_move_through_shanty_given" );
	flag_init( "obj_go_loud_given" );
	flag_init( "obj_follow_price_advance_given" );
	flag_init( "obj_follow_price_advance_complete" );
	flag_init( "obj_capture_mortar" );
	flag_init( "obj_breach_warlord_room" );
	flag_init( "obj_breach_warlord_room_started" );
	flag_init( "obj_commandeer_technical_given" );
	flag_init( "obj_commandeer_technical_done" );
	
	wait 1;
	waittillframeend;	
	
	// add/remove lines here to add/remove objectives.
	// [ objective name, objective string, objective function, override_objective_id ]
	objective_table = [];
	objective_table[ objective_table.size ] = [ "obj_follow_price", &"WARLORD_OBJ_FOLLOW_PRICE", ::objective_follow_price, 0 ];
	objective_table[ objective_table.size ] = [ "obj_overwatch", &"WARLORD_OBJ_COVER_PRICE_AND_SOAP", ::objective_overwatch ];
	objective_table[ objective_table.size ] = [ "obj_move_shanty", &"WARLORD_OBJ_MOVE_THROUGH_SHANTY", ::objective_move_shanty ];
	objective_table[ objective_table.size ] = [ "obj_commandeer", &"WARLORD_OBJ_COMMANDEER_TECHNICAL", ::objective_commandeer ];
	objective_table[ objective_table.size ] = [ "obj_evade_mortar", &"WARLORD_OBJ_EVADE_MORTAR_FIRE", ::objective_evade_mortar ];
	objective_table[ objective_table.size ] = [ "obj_cover_price", &"WARLORD_OBJ_COVER_PRICE", ::objective_use_mortar ];
	objective_table[ objective_table.size ] = [ "obj_enter_compound", &"WARLORD_OBJ_ENTER_COMPOUND", ::objective_enter_compound ];
	objective_table[ objective_table.size ] = [ "obj_capture_warlord", &"WARLORD_OBJ_CAPTURE_WARLORD", ::objective_capture_warlord ];
	
	// objective based on start point
	starting_objective = [];
	starting_objective[ "default" ] = "obj_follow_price";
	starting_objective[ "start_stealth_intro" ] = "obj_follow_price";
	starting_objective[ "start_log_encounter" ] = "obj_follow_price";
	starting_objective[ "start_burn_encounter" ] = "obj_follow_price";
	starting_objective[ "start_river_big_moment" ] = "obj_follow_price";
	starting_objective[ "start_infiltration" ] = "obj_overwatch";
	starting_objective[ "start_advance" ] = "obj_move_shanty";
	starting_objective[ "start_technical" ] = "obj_move_shanty";
	starting_objective[ "start_mortar_run" ] = "obj_evade_mortar";
	starting_objective[ "start_player_mortar" ] = "obj_cover_price";
	starting_objective[ "start_assault" ] = "obj_enter_compound";
	starting_objective[ "start_super_technical" ] = "obj_enter_compound";
	starting_objective[ "start_confrontation" ] = "obj_capture_warlord";
	starting_objective[ "start_protect" ] = "obj_enter_compound";
	
	// create objectives
	objective_id = 1;
	is_complete = true;
	foreach ( objective in objective_table )
	{
		is_complete = ( is_complete && ( starting_objective[ level.start_point ] != objective[0] ) );
		
		// allow objective id's to be overridden, then it will count up from the last overridden objective id
		if ( IsDefined( objective[3] ) )
		{
			objective_id = objective[3];
		}
		
		create_warlord_objective( objective_id, objective[1], objective[2], is_complete );
		objective_id++;
	}
}

// follow price
objective_follow_price( objective_id, objective_text )
{
	flag_wait( "obj_first_follow_price" );
	wait 1;
	AssertEx( IsDefined(level.price), "price not spawned?" );
	
	Objective_Add( objective_id, "current", objective_text );
	Objective_OnEntity( objective_id, level.price );
	flag_wait( "obj_take_overwatch_position" );
	objective_complete( objective_id );
}

// cover price and soap
objective_overwatch( objective_id, objective_text )
{
	Objective_Add( objective_id, "current", objective_text, (4419, 3274, 33) );
	handle_overwatch_objectives( objective_id );
	if ( flag( "inf_stealth_spotted" ) )
	{
		Objective_Delete( objective_id );	
	}
	else
	{
		objective_complete( objective_id );
	}
}

handle_overwatch_objectives( objective_id )
{
	level endon( "infiltration_over" );
	
	trigger = getent( "trig_tower_1", "targetname");
	trigger waittill( "trigger" );
		
	flag_wait_any( "throat_stab", "sleeping_guy_dead" );
	Objective_OnEntity( objective_id, level.soap );
	Objective_SetPointerTextOverride( objective_id, &"WARLORD_OBJ_POINTER_PROTECT" );
	
	level waittill( "infiltration_over" );
}

// move through shanty
objective_move_shanty( objective_id, objective_text )
{
	flag_wait( "obj_move_through_shanty_given" );
	Objective_Add( objective_id, "current" );
	
	if ( flag( "inf_stealth_spotted" ) )
	{
		Objective_String( objective_id, &"WARLORD_OBJ_MOVE_THROUGH_SHANTY" );
		Objective_Position( objective_id, (7366, 3255, 141) );
		flag_wait( "obj_go_loud_given" );
	}
	else
	{
		Objective_String( objective_id, objective_text );
		Objective_Position( objective_id, (7366, 3255, 141) );
		flag_wait( "obj_go_loud_given" );
		Objective_String( objective_id, &"WARLORD_OBJ_MOVE_THROUGH_SHANTY" );
	}

	Objective_Position( objective_id, (5942, 4548, 144) );
	
	flag_wait( "obj_follow_price_advance_given" );
	Objective_OnEntity( objective_id, level.price );
	
	flag_wait( "obj_follow_price_advance_complete" );
	objective_complete( objective_id );
}

// commandeer technical
objective_commandeer( objective_id, objective_text )
{
	flag_wait ("obj_commandeer_technical_given");
	if ( !IsDefined( level.player_technical_turret ) )
	{
		technical_spawner = getent("player_technical", "targetname");
		technical_spawner waittill( "spawned" );
	}
	Objective_Add( objective_id, "current", objective_text );
	Objective_OnEntity( objective_id, level.player_technical_turret, (0, 0, -40) );
	flag_wait( "obj_commandeer_technical_done" );
	objective_complete( objective_id );
	level waittill( "turret_finished" );
}

// evade mortar fire
objective_evade_mortar( objective_id, objective_text )
{
	Objective_Add( objective_id, "current", objective_text );
	Objective_OnEntity( objective_id, level.price );
	trigger = getent( "trig_mortar_roof_collapse", "targetname" );
	trigger waittill( "trigger" );
	Objective_Position( objective_id, (7866, 6658, 480) );
	trigger = getent( "trig_mortar_soap_teleport", "targetname" );
	trigger waittill( "trigger" );
	Objective_OnEntity( objective_id, level.price );
	flag_wait( "obj_capture_mortar" );
	objective_complete( objective_id );
}

// use mortar
objective_use_mortar( objective_id, objective_text )
{
	Objective_Add( objective_id, "current", objective_text );
	player_mortar = GetEnt( "player_mortar", "targetname" );
	
	loc_1 = getent( "mortar_obj_1", "targetname" );
	loc_2 = getent( "mortar_obj_2", "targetname" );
	loc_3 = getent( "mortar_obj_3", "targetname" );
	
	Objective_Position( objective_id, loc_1.origin );
	flag_wait( "flag_mortar_obj_2" );
	Objective_Position( objective_id, loc_2.origin );
	flag_wait( "flag_mortar_obj_3" );
	Objective_Position( objective_id, loc_3.origin );
	flag_wait( "flag_mortar_obj_mortar" );
	
	Objective_OnEntity( objective_id, player_mortar );
	Objective_SetPointerTextOverride( objective_id, &"WARLORD_OBJ_POINTER_CAPTURE" );
	
	handle_mortar_target_objectives( objective_id );
	
	objective_complete( objective_id );
}

handle_mortar_target_objectives( objective_id )
{
	level endon( "mortar_finished" );
	level waittill( "mortar_equipped" );
	
	Objective_SetPointerTextOverride( objective_id, &"WARLORD_OBJ_POINTER_TARGET" );
	
	if ( !IsDefined( level.mortar_technical_1 ) )
	{
		level waittill( "mortar_technical_1_spawned" );
	}
	thread technical_objective( objective_id, 0, level.mortar_technical_1, "mortar_technical_1_dead", "mortar_technical_1_riders_dead", "    Destroy Technical #1", 0.5 );
	
	if ( !IsDefined( level.mortar_truck_1 ) )
	{
		level waittill( "mortar_truck_1_spawned" );
	}
	thread technical_objective( objective_id, 1, level.mortar_truck_1, "mortar_pickup_1_dead", "mortar_pickup_1_riders_dead", "    Destroy Truck #1", 2 );
	
	if ( !IsDefined( level.mortar_technical_2 ) )
	{
		level waittill( "mortar_technical_2_spawned" );
	}
	thread technical_objective( objective_id, 2, level.mortar_technical_2, "mortar_technical_2_dead", "mortar_technical_2_riders_dead", "    Destroy Technical #2", 3 );
	
	// kill mortar waves
	if ( !IsDefined( level.mortar_wave ) )
	{
		level waittill( "spawning_mortar_wave" );
		wait 5;
	}
	
	lerp_position = false;
	average_target_pos_ent = Spawn( "script_model", (0, 0, 0) );
	average_target_pos_ent thread clean_me_up();
	
	Objective_AdditionalEntity( objective_id, 3, average_target_pos_ent );

	while ( true )
	{
		if ( IsDefined( level.mortar_wave ) && level.mortar_wave.size > 0 )
		{
			average_position = ( 0, 0, 0 );
			total_guys = 0;
			foreach ( enemy in level.mortar_wave )
			{
				if ( IsDefined( enemy ) && IsAlive( enemy ) )
				{
					average_position = average_position + enemy.origin;
					total_guys++;
				}
			}
			
			if ( total_guys > 0 )
			{
				average_position = average_position / total_guys;
				if ( lerp_position )
				{
					average_target_pos_ent MoveTo( average_position, 0.2 );
				}
				else
				{
					lerp_position = true;
					average_target_pos_ent.origin = average_position;
				}
			}
		}
		
		wait 0.2;
	}
}

technical_objective( objective_id, sub_index, technical, done_flag, done_flag_2, objective_title, objective_delay )
{
	level endon( "mortar_finished" );
	if ( IsDefined( objective_delay ) )
	{
		wait objective_delay;
	}
	
	if ( IsAlive( technical ) )
	{
		Objective_AdditionalEntity( objective_id, sub_index, technical );
		flag_wait_either( done_flag, done_flag_2 );
		Objective_AdditionalPosition( objective_id, sub_index, (0,0,0) );
	}
}

clean_me_up()
{
	level waittill( "mortar_finished" );
	self Delete();
}

// enter compound
objective_enter_compound( objective_id, objective_text )
{
	Objective_Add( objective_id, "current", objective_text );
	Objective_OnEntity( objective_id, level.price );
	
	trig_enter_compund = GetEnt( "trig_enter_compound", "targetname" );
	if ( IsDefined( trig_enter_compund ) )
	{
		trig_enter_compund waittill( "trigger" );
		Objective_Position( objective_id, (3692, 8638, 997 ) );
	}
	
	flag_wait( "compound_church_doors" );
	Objective_OnEntity( objective_id, level.price );
	
	flag_wait( "church_breach_complete" );
	objective_complete( objective_id );
}

// capture warlord
objective_capture_warlord( objective_id, objective_text )
{
	Objective_Add( objective_id, "current", objective_text );
	Objective_OnEntity( objective_id, level.price );
	
	flag_wait( "obj_breach_warlord_room" );
	
	Objective_Position( objective_id, ( 3227, 8672, 997 ) );
	//Objective_SetPointerTextOverride( objective_id, &"SCRIPT_WAYPOINT_BREACH" );
	
	flag_wait( "obj_breach_warlord_room_started" );
	
	//Objective_State( objective_id, "invisible" );
	
	flag_wait( "warlord_protect" );
	objective_complete( objective_id );
}

create_warlord_objective( objective_id, objective_text, objective_logic, is_complete )
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
