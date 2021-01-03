#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\load_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace skipto;

function autoexec __init__sytem__() {     system::register("skipto",&__init__,&__main__,undefined);    }


	




function __init__()
{
	level flag::init( "running_skipto" );
	level flag::init( "level_has_skiptos" );
	level flag::init( "level_has_skipto_branches" );
	level.skipto_current_objective = [];
	
	clientfield::register( "toplayer", "catch_up_transition", 1, 1, "counter", &catch_up_transition, !true, !true );
	
	add_internal( "_default" );
	add_internal( "_exit" );
	add_internal( "no_game" );

	load_mission_table("gamedata/tables/cp/cp_mapmissions.csv",GetDvarString( "mapname" )); 
	
	level thread watch_players_connect();
}

function __main__()
{
	level thread handle();
}

/@
"Name: add( <skipto> , <func> , <loc_string> , <cleanup_func> , <launch_after> , <end_before> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <skipto>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <loc_string>: Localizated string to display, this became a requirement when loc_warnings were turned on."
"OptionalArg: <cleanup_func>: This function is called when the given objective is no longer active either because it has been completed or because some other checkpoint was completed that renders it unnecessary."
"OptionalArg: <launch_after>: UNSUPPORTED - use add_branch instead. "
"OptionalArg: <end_before>: UNSUPPORTED - use add_branch instead."
"Example: 	skipto::add( "first_hind",&skipto_first_hind, &"SKIPTOS_FIRSTHIND", &cleanup_first_hind );"
"SPMP: singleplayer"
@/

function add( skipto, func, loc_string, cleanup_func, launch_after, end_before )
{
	if(!isdefined(level.default_skipto))level.default_skipto=skipto;
	
	if ( is_dev( skipto ) )
	{
		/#
			ErrorMsg( "Use skipto::add_dev for dev skiptos" );
		#/
		return;
	}
	
	if ( IsDefined(launch_after) || IsDefined(end_before) ) 
	{
		/#
			ErrorMsg( "Use skipto::add_branch to use launch_after and end_before" );
		#/
		return;
	}
	
	if ( level flag::get( "level_has_skipto_branches" ) )
	{
		/#
			ErrorMsg( "Adding a simple skipto after a branching skipto may cause unpredictable results" );
		#/
	}

	if (!IsDefined(launch_after))
	{
		if (IsDefined(level.last_skipto))
		{
			if (IsDefined(level.skipto_settings[level.last_skipto]))
			{
				if (!IsDefined(level.skipto_settings[level.last_skipto].end_before) || level.skipto_settings[level.last_skipto].end_before.size < 1)
					if ( !isdefined( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = []; else if ( !IsArray( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = array( level.skipto_settings[level.last_skipto].end_before ); level.skipto_settings[level.last_skipto].end_before[level.skipto_settings[level.last_skipto].end_before.size]=skipto;;
			}
		}
		if (IsDefined(level.last_skipto))
		{
			launch_after = level.last_skipto;
		}
		level.last_skipto = skipto;
	}
	if( !isdefined( func ) )
	{
		assert( isdefined( func ), "skipto::add() called with no func parameter.." );
	}
	
	struct = add_internal( skipto, func, loc_string, cleanup_func, launch_after, end_before );
	struct.public = true;
	level flag::set( "level_has_skiptos" );
}

/@
"Name: add_branch( <skipto> , <func> , <loc_string> , <cleanup_func> , <launch_after> , <end_before> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <skipto>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <loc_string>: Localizated string to display, this became a requirement when loc_warnings were turned on."
"OptionalArg: <cleanup_func>: This function is called when the given objective is no longer active either because it has been completed or because some other checkpoint was completed that renders it unnecessary."
"OptionalArg: <launch_after>: Launches this objective after the specified objective has been completed. By default this is the previously added skipto, but passing something else allows multiple skiptos to branch from a single checkpoint. Passing an empty string (not undefined) makes this objective active by default on startup. "
"OptionalArg: <end_before>: Specify the objectives that should become active after this objective is completed. By default the next skipto would be activated. Changing it allows branching skiptos to end at the same place."
"Example: 	skipto::add( "first_hind",&skipto_first_hind, &"SKIPTOS_FIRSTHIND", &cleanup_first_hind );"
"SPMP: singleplayer"
@/

function add_branch( skipto, func, loc_string, cleanup_func, launch_after, end_before )
{
	if(!isdefined(level.default_skipto))level.default_skipto=skipto;

	if ( is_dev( skipto ) )
	{
		/#
			ErrorMsg( "Use skipto::add_dev for dev skiptos" );
		#/
		return;
	}
	
	if ( !IsDefined(launch_after) && !IsDefined(end_before) ) 
	{
		/#
			ErrorMsg( "Use skipto::add for automatically ordered skiptos" );
		#/
		return;
	}
	
	if (!IsDefined(launch_after))
	{
		if (IsDefined(level.last_skipto))
		{
			if (IsDefined(level.skipto_settings[level.last_skipto]))
			{
				if (!IsDefined(level.skipto_settings[level.last_skipto].end_before) || level.skipto_settings[level.last_skipto].end_before.size < 1)
					if ( !isdefined( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = []; else if ( !IsArray( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = array( level.skipto_settings[level.last_skipto].end_before ); level.skipto_settings[level.last_skipto].end_before[level.skipto_settings[level.last_skipto].end_before.size]=skipto;;
			}
		}
		if (IsDefined(level.last_skipto))
		{
			launch_after = level.last_skipto;
		}
		level.last_skipto = skipto;
	}
	if( !isdefined( func ) )
	{
		assert( isdefined( func ), "skipto::add() called with no func parameter.." );
	}
	
	struct = add_internal( skipto, func, loc_string, cleanup_func, launch_after, end_before );
	struct.public = true;
	level flag::set( "level_has_skiptos" );
	level flag::set( "level_has_skipto_branches" );
}

/@
"Name: add_dev( <skipto> , <func> , <loc_string> , <cleanup_func> , <launch_after> , <end_before> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <skipto>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <loc_string>: Localizated string to display, this became a requirement when loc_warnings were turned on."
"OptionalArg: <cleanup_func>: This function is called when the given objective is no longer active either because it has been completed or because some other checkpoint was completed that renders it unnecessary."
"OptionalArg: <launch_after>: Launches this objective after the specified objective has been completed. By default this is the previously added skipto, but passing something else allows multiple skiptos to branch from a single checkpoint. Passing an empty string (not undefined) makes this objective active by default on startup. "
"OptionalArg: <end_before>: Specify the objectives that should become active after this objective is completed. By default the next skipto would be activated. Changing it allows branching skiptos to end at the same place."
"Example: 	skipto::add( "first_hind",&skipto_first_hind, &"SKIPTOS_FIRSTHIND", &cleanup_first_hind );"
"SPMP: singleplayer"
@/

function add_dev( skipto, func, loc_string, cleanup_func, launch_after, end_before )
{
	if(!isdefined(level.default_skipto))level.default_skipto=skipto;

	if ( is_dev( skipto ) )
	{
		struct = add_internal( skipto, func, loc_string, cleanup_func, launch_after, end_before );
		struct.dev_skipto = true;
		return;
	}
	
	/#
		ErrorMsg( "Only use skipto::add_dev for dev skiptos" );
	#/
	
}



function add_internal( msg, func, loc_string, cleanup_func, launch_after, end_before )
{
   	assert( !isdefined( level._loadStarted ), "Can't create skiptos after _load" );
	
	msg = ToLower( msg );
	
	struct = add_construct( msg, func, loc_string, cleanup_func, launch_after, end_before );
	
	level.skipto_settings[ msg ] = struct;
	return struct;
}

function change( msg, func, loc_string, cleanup_func, launch_after, end_before )
{
	struct = level.skipto_settings[ msg ];
	if (IsDefined(func))
		struct.skipto_func = func;
	if (IsDefined(loc_string))
		struct.skipto_loc_string = loc_string;
	if (IsDefined(cleanup_func))
		struct.cleanup_func = cleanup_func;
	if ( IsDefined(launch_after) )
	{
		if ( !isdefined( struct.launch_after ) ) struct.launch_after = []; else if ( !IsArray( struct.launch_after ) ) struct.launch_after = array( struct.launch_after ); struct.launch_after[struct.launch_after.size]=launch_after;;
	}
	if ( IsDefined(end_before) )
	{
		struct.end_before = StrTok(end_before,",");
		struct.next = struct.end_before;
	}
}

/@
"Name: set_skipto_cleanup_func( <func> )"
"Summary: set the skipto cleanup function for the level"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <func>: function that runs before any skipto function gets called. Used for shared skipto initialization."
"Example: 	set_skipto_cleanup_func(&skipto_cleanup );"
"SPMP: singleplayer"
@/
function set_skipto_cleanup_func( func )
{
	level.func_skipto_cleanup = func;
}

/@
"Name: add_construct( <skipto> )"
"Summary: Returns the parameters as a string indexed array, used in the utility logic later on"
@/
function add_construct( msg, func, loc_string, cleanup_func, launch_after, end_before )
{
	struct = spawnstruct();
	struct.name = msg;
	struct.skipto_func = func;
	struct.skipto_loc_string = loc_string;
	struct.cleanup_func = cleanup_func;
	struct.next = [];
	struct.prev = [];
	struct.completion_conditions = ""; 
	struct.launch_after = []; 
	if ( IsDefined(launch_after) )
	{
		if ( !isdefined( struct.launch_after ) ) struct.launch_after = []; else if ( !IsArray( struct.launch_after ) ) struct.launch_after = array( struct.launch_after ); struct.launch_after[struct.launch_after.size]=launch_after;;
	}
	struct.end_before = []; 
	if ( IsDefined(end_before) )
	{
		struct.end_before = StrTok(end_before,",");
		struct.next = struct.end_before;
	}
	struct.ent_movers = [];
	return struct;
	
}

function build_objective_tree()
{
	foreach( struct in level.skipto_settings )
	{
		if ( ( isdefined( struct.public ) && struct.public ) )
		{
			if ( struct.launch_after.size )
			{
				foreach( launch_after in struct.launch_after )
				{
					if ( IsDefined( level.skipto_settings[launch_after] ) )
					{
						if ( !isinarray( level.skipto_settings[launch_after].next, struct.name ) )
						{
							if ( !isdefined( level.skipto_settings[launch_after].next ) ) level.skipto_settings[launch_after].next = []; else if ( !IsArray( level.skipto_settings[launch_after].next ) ) level.skipto_settings[launch_after].next = array( level.skipto_settings[launch_after].next ); level.skipto_settings[launch_after].next[level.skipto_settings[launch_after].next.size]=struct.name;;
						}
					}
					else
					{
						if ( !isdefined( level.skipto_settings["_default"].next ) ) level.skipto_settings["_default"].next = []; else if ( !IsArray( level.skipto_settings["_default"].next ) ) level.skipto_settings["_default"].next = array( level.skipto_settings["_default"].next ); level.skipto_settings["_default"].next[level.skipto_settings["_default"].next.size]=struct.name;;
					}
				}
			}
			else
			{
				if ( !isdefined( level.skipto_settings["_default"].next ) ) level.skipto_settings["_default"].next = []; else if ( !IsArray( level.skipto_settings["_default"].next ) ) level.skipto_settings["_default"].next = array( level.skipto_settings["_default"].next ); level.skipto_settings["_default"].next[level.skipto_settings["_default"].next.size]=struct.name;;
			}

			foreach( end_before in struct.end_before )
			{
				if ( IsDefined( level.skipto_settings[end_before] ) )
				{
					if ( !isdefined( level.skipto_settings[end_before].prev ) ) level.skipto_settings[end_before].prev = []; else if ( !IsArray( level.skipto_settings[end_before].prev ) ) level.skipto_settings[end_before].prev = array( level.skipto_settings[end_before].prev ); level.skipto_settings[end_before].prev[level.skipto_settings[end_before].prev.size]=struct.name;;
				}
			}
		}
	}
	foreach( struct in level.skipto_settings )
	{
		if ( ( isdefined( struct.public ) && struct.public ) )
		{
			if ( struct.next.size < 1 )
			{
				if ( !isdefined( struct.next ) ) struct.next = []; else if ( !IsArray( struct.next ) ) struct.next = array( struct.next ); struct.next[struct.next.size]="_exit";;
			}
		}
	}
}

function is_dev( skipto )
{
	substr = ToLower( GetSubStr( skipto, 0, 4 ) );

	if ( substr == "dev_" )
	{
		return true;
	}

	return false;
	
}

function level_has_skipto_points()
{
	return ( level flag::get( "level_has_skiptos" ) );
}

function get_current_skiptos()
{
	skiptos = ToLower(GetSkiptos());
	result  = StrTok( skiptos, "," );
	return result;
}

function handle()
{
	wait_for_first_player();
	build_objective_tree();
	
	run_initial_logic();
	skiptos = get_current_skiptos();
	set_level_objective( skiptos, true );
	
	while(1)
	{
		level waittill("skiptos_changed");
		skiptos = get_current_skiptos();
		set_level_objective( skiptos, false );
	}
}

//UTILITY FUNCTIONS

/@
"Name: set_cleanup_func( <func> )"
"Summary: set the skipto cleanup function for the level"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <func>: function that runs before any skipto function gets called. Used for shared skipto initialization."
"Example: 	skipto::set_cleanup_func(&cleanup );"
"SPMP: singleplayer"
@/
function set_cleanup_func( func )
{
	level.func_skipto_cleanup = func;
}

/@
"Name: default_skipto( <skipto> )"
"Summary: Set the default skipto point by name. Allows any skipto to be called by default when level loads naturally."
"Module: Utility"
"MandatoryArg: <skipto>: Which skipto to use as the default skipto. "
"Example: skipto::default_skipto( "ride" );"
"SPMP: singleplayer"
@/
function default_skipto( skipto )
{
	level.default_skipto = skipto;
}

//========================================================
// CP specific functions  

function convert_token( str, fromtok, totok )
{
	sarray = StrTok( str, fromtok );
	ostr = "";
	first = true;
	foreach ( s in sarray )
	{
		if (!first)
			ostr = ostr+totok;
		first = false;
		ostr = ostr+s;
	}
	return ostr;	
}

function load_mission_table( table, levelname, sublevel="" )
{
	index = 0;
	
	row = TableLookupRow(table, index);
	
	while(isdefined(row))
	{
		if ( row[0] == levelname && row[1] == sublevel  )
		{
			skipto = row[2];
			launch_after = row[3];
			end_before = row[4];
			end_before = convert_token( end_before, "+", "," );
			locstr = row[5];
			add_branch( skipto, &load_mission_init, locstr, undefined, launch_after, end_before );
		}
		
		index++;
		row = TableLookupRow(table, index);
		
	}
	
}

function load_mission_init()
{	
}
	
function wait_for_first_player()
{
	level flag::wait_till("skipto_player_connected");
}

function watch_players_connect()
{
	if ( !level flag::exists("skipto_player_connected") )
	{
		level flag::init("skipto_player_connected");
	}
	callback::add_callback( #"on_localclient_connect", &on_player_connect);
}

function on_player_connect( localClientNum )
{
	level flag::set("skipto_player_connected");
}

function set_level_objective( objectives, starting )
{
	clear_recursion();
	if ( starting )
	{
		foreach( objective in objectives )
		{
			if ( IsDefined( level.skipto_settings[objective] ))
			{
				stop_objective_logic( level.skipto_settings[objective].prev, starting );
			}
		}
	}
	else
	{
		foreach( skipto in level.skipto_settings )
		{
			if ( ( isdefined( skipto.objective_running ) && skipto.objective_running ) && !IsInArray(objectives,skipto.name))
			{
				stop_objective_logic( skipto.name, starting );
			}
		}
	}

	if ( isdefined( level.func_skipto_cleanup ) )
	{
		foreach( name in objectives )
		{
			thread [[ level.func_skipto_cleanup ]]( name );
		}
	}

	start_objective_logic( objectives, starting );
	
	level.skipto_point = level.skipto_current_objective[0];
	
	level notify("objective_changed",level.skipto_current_objective);
	level.skipto_current_objective = objectives;	
}

function run_initial_logic( objectives )
{
	foreach( skipto in level.skipto_settings )
	{
		if ( !( isdefined( skipto.logic_running ) && skipto.logic_running ) )
		{
			skipto.logic_running = true;
			if ( isdefined( skipto.logic_func ) )
				thread [[ skipto.logic_func ]]( skipto.name );
		}
	}
}

function start_objective_logic( name, starting )
{
	if ( IsArray( name ) )
	{
		foreach( element in name )
		{
			start_objective_logic( element, starting );
		}
	}
	else
	{
		if ( IsDefined( level.skipto_settings[ name ] ) )
		{
			if ( !( isdefined( level.skipto_settings[ name ].objective_running ) && level.skipto_settings[ name ].objective_running ) )
			{
				If (!IsInArray(level.skipto_current_objective,name))
				{
					if ( !isdefined( level.skipto_current_objective ) ) level.skipto_current_objective = []; else if ( !IsArray( level.skipto_current_objective ) ) level.skipto_current_objective = array( level.skipto_current_objective ); level.skipto_current_objective[level.skipto_current_objective.size]=name;;
				}
				level notify(name + "_init");
				level.skipto_settings[ name ].objective_running = true;
				standard_objective_init( name, starting );
				
				if ( isdefined( level.skipto_settings[ name ].skipto_func ) )
					thread [[ level.skipto_settings[ name ].skipto_func ]]( name, starting );
			}
		}
	}
}

function clear_recursion()
{
	foreach( skipto in level.skipto_settings )
	{
		skipto.cleanup_recursion = false;
	}
}

function stop_objective_logic( name, starting )
{
	if ( IsArray( name ) )
	{
		foreach( element in name )
		{
			stop_objective_logic( element, starting );
		}
	}
	else
	{
		if ( IsDefined( level.skipto_settings[ name ] ) )
		{
			cleaned = false;
			if ( ( isdefined( level.skipto_settings[ name ].objective_running ) && level.skipto_settings[ name ].objective_running ) )
			{
				cleaned = true;
				level.skipto_settings[ name ].objective_running = false;
				If (IsInArray(level.skipto_current_objective,name))
				{
					ArrayRemoveValue( level.skipto_current_objective, name);
				}
				if ( isdefined( level.skipto_settings[ name ].cleanup_func ) )
					thread [[ level.skipto_settings[ name ].cleanup_func ]]( name, starting );
				
				standard_objective_done( name, starting );
				level notify(name + "_terminate");
			}
			
			
			if ( starting && !( isdefined( level.skipto_settings[ name ].cleanup_recursion ) && level.skipto_settings[ name ].cleanup_recursion ) )
			{
				level.skipto_settings[ name ].cleanup_recursion = true;
				stop_objective_logic( level.skipto_settings[ name ].prev, starting );
				if ( !cleaned )
				{
					if ( isdefined( level.skipto_settings[ name ].cleanup_func ) )
						thread [[ level.skipto_settings[ name ].cleanup_func ]]( name, starting );
					
					standard_objective_done( name, starting );
				}
			}
		}
	}
}

function level_completed( objective, starting )
{
}

//========================================================
// default handlers for missions with no function calls

function private standard_objective_init( objective, starting )
{
}

function private standard_objective_done( objective, starting )
{
}

function catch_up_transition( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	postfx::playpostfxbundle( "pstfx_cp_transition_sprite" );
}
