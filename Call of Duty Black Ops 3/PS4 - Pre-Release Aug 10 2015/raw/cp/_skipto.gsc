#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\load_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_accolades;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_util;
#using scripts\cp\_bb;

#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\music_shared;

#namespace skipto;

#precache( "lui_menu", "ScriptDebugBillboard" );
#precache( "lui_menu_data", "name" );
#precache( "lui_menu_data", "type" );
#precache( "lui_menu_data", "size" );

#precache( "lui_menu", "RewardsOverlayCP" );
#precache( "lui_menu", "CPAAR" );

#precache( "string", "COOP_REACHED_SKIPTO");

function autoexec __init__sytem__() {     system::register("skipto",&__init__,&__main__,undefined);    }

/*   Level variables used in file
level.default_skipto	 - String 						- Only set manually in set_default_skipto.  Sets which skipto will be called when level loads naturally.
level.skipto_settings	 - Array of Struct			    - The first index is by skipto name, the corresponding array holds the skipto name, skipto function, skipto loc string, and the event/logic func for level progression
level.skipto_point		 - String 						- The name of the skipto point used on current level load called from Rex, the in game devgui, or other tools
*/

// these are publicly used
// skipto::add()
// skipto::default_skipto()
// skipto::set_cleanup_func()
// skipto::filter_player_spawnpoints()
// skipto::teleport()
// skipto::teleport_players()
// skipto::use_default_skipto()
// skipto::do_no_game();







function __init__()
{
	level flag::init( "skipto_player_connected" );
	level flag::init( "running_skipto" );
	level flag::init( "level_has_skiptos" );
	level flag::init( "level_has_skipto_branches" );
	
	level flag::init( "skip_safehouse_after_map" );
	level flag::init( "final_level" );
		
	level flag::init( "_exit" );
	
	clientfield::register( "toplayer", "catch_up_transition", 1, 1, "counter" );
	
	add_internal( "_default" );
	add_internal( "_exit", &level_completed );
	add_internal( "no_game", &skipto::nogame );
	
	load_mission_table( "gamedata/tables/cp/cp_mapmissions.csv", level.script );

	level.filter_spawnpoints = &filter_spawnpoints;

	callback::on_connect( &on_player_connect );
	
	/#
		level thread update_billboard();
		callback::on_spawned( &update_player_billboard );
	#/
}

function __main__()
{
	level thread entity_mover_main();
	level thread handle();
	level thread regroup_triggers();
}

/@
"Name: add( <skipto> , <func> , <str_name> , <cleanup_func> , <launch_after> , <end_before> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <skipto>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <str_name>: Descriptive name used for dev purposes only (not localized)."
"OptionalArg: <cleanup_func>: This function is called when the given objective is no longer active either because it has been completed or because some other checkpoint was completed that renders it unnecessary."
"OptionalArg: <launch_after>: UNSUPPORTED - use add_branch instead. "
"OptionalArg: <end_before>: UNSUPPORTED - use add_branch instead."
"Example: 	skipto::add( "first_hind",&skipto_first_hind, &"SKIPTOS_FIRSTHIND", &cleanup_first_hind );"
"SPMP: singleplayer"
@/

function add( skipto, func, str_name, cleanup_func, launch_after, end_before )
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
	
	if ( !isdefined( launch_after ) )
	{
		if ( isdefined( level.last_skipto ) )
		{
			if ( isdefined( level.skipto_settings[level.last_skipto] ) )
			{
				if ( !isdefined( level.skipto_settings[level.last_skipto].end_before ) || level.skipto_settings[level.last_skipto].end_before.size < 1 )
				{
					if ( !isdefined( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = []; else if ( !IsArray( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = array( level.skipto_settings[level.last_skipto].end_before ); level.skipto_settings[level.last_skipto].end_before[level.skipto_settings[level.last_skipto].end_before.size]=skipto;;
				}
			}
		}

		if ( isdefined( level.last_skipto ) )
		{
			launch_after = level.last_skipto;
		}

		level.last_skipto = skipto;
	}

	if ( !isdefined( func ) )
	{
		assert( isdefined( func ), "skipto::add() called with no func parameter.." );
	}

	struct = add_internal( skipto, func, str_name, cleanup_func, launch_after, end_before );

	struct.public = true;
	
	level flag::set( "level_has_skiptos" );
}

/@
"Name: add_branch( <skipto> , <func> , <str_name> , <cleanup_func> , <launch_after> , <end_before> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <skipto>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <str_name>: Descriptive name used for dev purposes only (not localized)."
"OptionalArg: <cleanup_func>: This function is called when the given objective is no longer active either because it has been completed or because some other checkpoint was completed that renders it unnecessary."
"OptionalArg: <launch_after>: Launches this objective after the specified objective has been completed. By default this is the previously added skipto, but passing something else allows multiple skiptos to branch from a single checkpoint. Passing an empty string (not undefined) makes this objective active by default on startup. "
"OptionalArg: <end_before>: Specify the objectives that should become active after this objective is completed. By default the next skipto would be activated. Changing it allows branching skiptos to end at the same place."
"Example: 	skipto::add( "first_hind",&skipto_first_hind, &"SKIPTOS_FIRSTHIND", &cleanup_first_hind );"
"SPMP: singleplayer"
@/

function add_branch( skipto, func, str_name, cleanup_func, launch_after, end_before )
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
	
	if ( !isdefined( launch_after ) )
	{
		if ( isdefined( level.last_skipto ) )
		{
			if ( isdefined( level.skipto_settings[level.last_skipto] ) )
			{
				if ( !isdefined( level.skipto_settings[level.last_skipto].end_before ) || level.skipto_settings[level.last_skipto].end_before.size < 1 )
				{
					if ( !isdefined( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = []; else if ( !IsArray( level.skipto_settings[level.last_skipto].end_before ) ) level.skipto_settings[level.last_skipto].end_before = array( level.skipto_settings[level.last_skipto].end_before ); level.skipto_settings[level.last_skipto].end_before[level.skipto_settings[level.last_skipto].end_before.size]=skipto;;
				}
			}
		}

		if ( isdefined( level.last_skipto ) )
		{
			launch_after = level.last_skipto;
		}

		level.last_skipto = skipto;
	}

	if ( !isdefined( func ) )
	{
		assert( isdefined( func ), "skipto::add() called with no func parameter.." );
	}

	struct = add_internal( skipto, func, str_name, cleanup_func, launch_after, end_before );

	struct.public = true;
	
	level flag::set( "level_has_skiptos" );
	level flag::set( "level_has_skipto_branches" );
	
	return struct;
}

function add_branchend( skipto, func, str_name, cleanup_func, launch_after, end_before )
{
	struct = add_branch( skipto, func, str_name, cleanup_func, launch_after, end_before ); 
	if ( IsDefined(struct) )
	{
		struct.looping = true;
	}
}


/@
"Name: add_dev( <skipto> , <func> , <str_name> , <cleanup_func> , <launch_after> , <end_before> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <skipto>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <str_name>: Descriptive name used for dev purposes only (not localized)."
"OptionalArg: <cleanup_func>: This function is called when the given objective is no longer active either because it has been completed or because some other checkpoint was completed that renders it unnecessary."
"OptionalArg: <launch_after>: Launches this objective after the specified objective has been completed. By default this is the previously added skipto, but passing something else allows multiple skiptos to branch from a single checkpoint. Passing an empty string (not undefined) makes this objective active by default on startup. "
"OptionalArg: <end_before>: Specify the objectives that should become active after this objective is completed. By default the next skipto would be activated. Changing it allows branching skiptos to end at the same place."
"Example: 	skipto::add( "first_hind",&skipto_first_hind, &"SKIPTOS_FIRSTHIND", &cleanup_first_hind );"
"SPMP: singleplayer"
@/

function add_dev( skipto, func, str_name, cleanup_func, launch_after, end_before )
{
	if(!isdefined(level.default_skipto))level.default_skipto=skipto;

	if ( is_dev( skipto ) )
	{
		struct = add_internal( skipto, func, str_name, cleanup_func, launch_after, end_before );
		struct.dev_skipto = true;
		return;
	}
	
	/#
		ErrorMsg( "Only use skipto::add_dev for dev skiptos" );
	#/
}

function objective_leave_incomplete( skipto )
{
	if ( !isdefined( level.skipto_settings[ skipto ] ) )
	{
		AssertMsg( "Must call skipto::add for skipto (" + skipto + ") before calling skipto::objective_leave_incomplete." );
		return;
	}
	
	level.skipto_settings[ skipto ].objective_mark_complete = false;
	foreach (player in level.players)
	{
		bb::logObjectiveStatusChange(skipto, player, "leave_objective_incomplete");
	}
}

function add_billboard( skipto, event_name, event_type, event_size, event_state/*, disable_fade */)
{
	if(!isdefined(level.billboards))level.billboards=[];
	level.billboards[ skipto ] = Array( event_name, event_type, event_size, event_state/*, disable_fade */);
}

function add_internal( msg, func, str_name, cleanup_func, launch_after, end_before )
{
	assert( !isdefined( level._loadStarted ), "Can't create skiptos after _load" );
	msg = ToLower( msg );
	struct = add_construct( msg, func, str_name, cleanup_func, launch_after, end_before );
	level.skipto_settings[ msg ] = struct;
	level flag::init( msg );
	level flag::init( msg + "_completed" );
	
	return struct;
}

function change( msg, func, str_name, cleanup_func, launch_after, end_before )
{
	struct = level.skipto_settings[ msg ];

	if ( isdefined( func ) )
	{
		struct.skipto_func = func;
	}

	if ( isdefined( str_name ) )
	{
		struct.str_name = str_name;
	}

	if ( isdefined( cleanup_func ) )
	{
		struct.cleanup_func = cleanup_func;
	}

	if ( isdefined( launch_after ) )
	{
		struct.completion_conditions = struct parse_launch_after( launch_after );
	}

	if ( isdefined( end_before ) )
	{
		struct.end_before = StrTok( end_before, "," );
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
function add_construct( msg, func, str_name, cleanup_func, launch_after, end_before )
{
	struct = spawnstruct();
	struct.name = msg;
	struct.code_index = RegisterSkipto( msg );
	struct.skipto_func = func;
	struct.str_name = str_name;
	struct.cleanup_func = cleanup_func;
	struct.next = [];
	struct.prev = [];
	struct.completion_conditions = "";
	struct.launch_after = [];

	if ( isdefined( launch_after ) )
	{
		struct.completion_conditions = struct parse_launch_after( launch_after );
	}

	struct.end_before = [];

	if ( isdefined( end_before ) )
	{
		struct.end_before = StrTok( end_before, "," );
		struct.next = struct.end_before;
	}

	struct.ent_movers = [];

	return struct;
}


function level_has_skipto_points()
{
	return ( level flag::get( "level_has_skiptos" ) );
}

function parse_error( msg )
{
	/#
	AssertMsg( msg );
#/
}

function split_top_level_and_or( instring )
{
	op = "";
	ret = [];
	outindex = 0;
	ret[outindex] = "";
	paren = 0;

	for ( i = 0; i < instring.size; i++ )
	{
		c = GetSubstr( instring, i, i + 1 );

		if ( c == "(" )
		{
			paren++;
			ret[outindex] = ret[outindex] + c;
		}
		else if ( c == ")" )
		{
			paren--;
			ret[outindex] = ret[outindex] + c;
		}
		else if ( paren == 0 && c == "&" )
		{
			if ( op == "|" )
			{
				/# parse_error("Cannot mix & and | in launch_after string: " + instring); #/
			}

			op = "&";
			outindex++;
			ret[outindex] = "";
		}
		else if ( paren == 0 && c == "|" )
		{
			if ( op == "&" )
			{
				/# parse_error("Cannot mix & and | in launch_after string: " + instring); #/
			}

			op = "|";
			outindex++;
			ret[outindex] = "";
		}
		else
		{
			ret[outindex] = ret[outindex] + c;
		}
	}

	if ( paren != 0 )
	{
		/# parse_error("Mismatched parens in launch_after string: " + instring); #/
	}

	for ( j = 0; j <= outindex; j++ )
	{
		ret[j] = remove_parens( ret[j] );
	}

	if ( outindex == 0 )
	{
		return ret[outindex];
	}
	else
	{
		ret["op"] = op;
		return ret;
	}
}

function remove_parens( instring )
{
	c = GetSubstr( instring, 0, 1 );

	if ( c == "(" )
	{
		c2 = GetSubstr( instring, instring.size - 1, instring.size );

		if ( c2 != ")" )
		{
			/# parse_error("Mismatched parens in launch_after string: " + instring); #/
		}

		s = GetSubstr( instring, 1, instring.size - 1 );
		return split_top_level_and_or( s );
	}

	if ( !isdefined( self.launch_after ) ) self.launch_after = []; else if ( !IsArray( self.launch_after ) ) self.launch_after = array( self.launch_after ); self.launch_after[self.launch_after.size]=instring;;
	return instring;
}

function parse_launch_after( launch_after )
{
	retval = split_top_level_and_or( launch_after );

	if ( IsArray( retval ) )
	{
		return retval;
	}

	return "";
}

function check_skipto_condition( conditions, adding )
{
	if ( !IsArray( conditions ) )
	{
		if ( isdefined( level.skipto_settings[conditions] ) && 
		     ( ( isdefined( level.skipto_settings[ conditions ].objective_running ) && level.skipto_settings[ conditions ].objective_running ) || 
		       IsInArray(adding, conditions) ) )
		{
			return false;
		}

		return true;
	}
	else if ( conditions["op"] == "|" )
	{
		for ( i = 0; i < conditions.size - 1; i++ )
		{
			if ( check_skipto_condition( conditions[i], adding ) )
			{
				return true;
			}
		}

		return false;
	}
	else
	{
		for ( i = 0; i < conditions.size - 1; i++ )
		{
			if ( !check_skipto_condition( conditions[i], adding ) )
			{
				return false;
			}
		}

		return true;
	}
}


function check_skipto_conditions( objectives )
{
	result = [];
	foreach( name in objectives )
	{
		if ( check_skipto_condition( level.skipto_settings[name].completion_conditions, result ) )
		{
			if ( !isdefined( result ) ) result = []; else if ( !IsArray( result ) ) result = array( result ); result[result.size]=name;;
		}
	}
	return result;
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
					if ( isdefined( level.skipto_settings[launch_after] ) )
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
				if ( isdefined( level.skipto_settings[end_before] ) )
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

function get_next_skiptos( skipto_name )
{
	if ( isdefined( level.skipto_settings[skipto_name] ) )
	{
		return level.skipto_settings[skipto_name].next;
	}

	return level.skipto_settings["_default"].next;
}

function skiptos_to_string( skiptos )
{
	skiptostr = "";
	first = true;
	foreach ( skipto in skiptos )
	{
		if ( !first )
		{
			skiptostr = skiptostr + ",";
		}

		first = false;
		skiptostr = skiptostr + skipto;
	}
	return skiptostr;
}

function get_current_skiptos()
{
	skiptos = ToLower( GetSkiptos() );
	result  = StrTok( skiptos, "," );
	return result;
}

function set_current_skipto( skipto )
{
	SetSkiptos( ToLower( skipto ) );
}

function set_current_skiptos( skiptos )
{
	set_current_skipto( skiptos_to_string( skiptos ) );
}

function use_default_skipto()
{
	if(!isdefined(level.default_skipto))level.default_skipto="";
	set_current_skipto( level.default_skipto );
}

// position of "checkpoint reached" in _save.gsc






// Shows the skipto name, only called when a skipto other than the default is used
function indicate( skipto, index )
{
	/#

	if ( isdefined( GetDvarString( "cinCaptureEnabled" ) ) && GetDvarInt( "cinCaptureEnabled" ) ) //Disable during cinematic capture mode
	{
		return;
	}

	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.x = 125;
	hudelem.y = 20 * ( index + 2 );
	hudelem.fontScale = 1.5;
	hudelem.sort = 20;
	hudelem.alpha = 0;
	hudelem.color = ( 0.8, 0.8, 0.8 );
	hudelem.font = "small";
	hudelem SetText( skipto );
	// stagger the timing on multiple skiptos
	wait 0.25 * ( index + 1 );
	hudelem FadeOverTime( 0.25 );
	hudelem.alpha = 1;
	wait 0.25;
	wait 3.0;
	hudelem FadeOverTime( 0.75 );
	hudelem.alpha = 0;
	wait 0.75;
	hudelem Destroy();
	
	#/
}

function validate_skiptos( skiptos )
{
	done = false;

	while ( isdefined( skiptos ) && skiptos.size && !done )
	{
		done = true;
		foreach ( skipto in skiptos )
		{
			if ( !isdefined( level.skipto_settings[skipto] ) )
			{
				ArrayRemoveValue( skiptos, skipto, false );
				done = false;
				break;
			}
		}
	}

	return skiptos;
}


// Called in __main__, the main skipto functionality
function handle()
{
	build_objective_tree();
	clear_menu();
	wait_for_first_player();
	default_skiptos = get_next_skiptos( "_default" );
	skiptos = get_current_skiptos();
	skiptos = validate_skiptos( skiptos );

	if ( isdefined( level.skipto_point ) )
	{
		skiptos = [];
		skiptos[0] = level.skipto_point;
	}

	level.skipto_current_objective = skiptos;
	skipto = skiptos[0];

	if ( isdefined( skipto ) && isdefined( level.skipto_settings[skipto] ) )
	{
		level.skipto_point = skipto;
	}

	is_default = false;
	start = level.skipto_current_objective;

	if ( start.size < 1 )
	{
		is_default = true;
		start = default_skiptos;

		if ( isdefined( level.default_skipto ) )
		{
			level.skipto_point = level.default_skipto;
		}
		
		Savegame_Create(); // Save game at the start of every level
	}

	level.skipto_points = start;
	skipto = start[0];

	if ( isdefined( skipto ) && isdefined( level.skipto_settings[skipto] ) )
	{
		level.skipto_point = skipto;
	}

	if ( start.size < 1 )
	{
		return;
	}

	if ( !is_default )
	{
		entity_mover_use_objectives( default_skiptos );
	}
	
	// scenes have a hack to wait fo the client system to set up so it can sync server and client scenes
	// so we need this wait here to make sure scenes set up in their initial state before runing skipto logic
	level flagsys::set( "scene_on_load_wait" );

	set_level_objective( start, true );

	if ( is_default )
	{
		thread savegame::save();
	}
	else
	{
		thread savegame::load();
	}
	
	thread devgui();
	
	/#

	waittillframeend;
	
	thread menu(); // thread that waits for the devgui or button combo to display the skipto selection menu, then opens it
	level thread dev_warning();
	
	#/
}

// TFLAME - 3/21/11 - Creates some hudelem, not sure which one yet
function create( skipto, index )
{
	alpha = 1;
	color = ( 0.9, 0.9, 0.9 );

	if ( index != -1 )
	{
		const middle = 4;

		if ( index != middle )
		{
			alpha = 1 - ( abs( middle - index ) / middle );
		}
		else
		{
			color = ( 1, 1, 0 );
		}
	}

	if ( alpha == 0 )
	{
		alpha = 0.05;
	}

	//-- This can't be debug so that the inspector menu in ship_cheats works
	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 80;
	hudelem.y = 80 + index * 18;
	hudelem SetText( skipto );
	hudelem.alpha = 0;
	hudelem.foreground = true;
	hudelem.color = color;
	hudelem.fontScale = 1.75;
	hudelem FadeOverTime( 0.5 );
	hudelem.alpha = alpha;
	return hudelem;
}




function clear_menu()
{
	rootclear = "devgui_remove \"Map/Skipto\" \n";
	AddDebugCommand( rootclear );
}

// thread that waits for the devgui or button combo to display the skipto selection menu, then opens it
function devgui()
{
	rootmenu = "devgui_cmd \"Map/Skipto/";
	jumpmenu = rootmenu + "Jump to/";
	index = 1;
	AddDebugCommand( jumpmenu + "Default:0\" \"set " + "skipto_jump" + " " + "_default" + "\" \n" );
	foreach( struct in level.skipto_settings )
	{
		name = struct.name + ":" + index;
		index++;
		AddDebugCommand( jumpmenu + name + "\" \"set " + "skipto_jump" + " " + struct.name + "\" \n" );
	}
	AddDebugCommand( jumpmenu + "No Game:" + index + "\" \"set " + "skipto_jump" + " " + "no_game" + "\" \n" );

	for ( ;; )
	{
		jumpto = GetDvarString( "skipto_jump" );

		if ( isdefined( jumpto ) && jumpto.size )
		{
			SetDvar( "skipto_jump", "" );

			if ( jumpto == "_default" )
			{
				jumpto = "";
			}

			set_current_skipto( jumpto );
			
			music::setmusicstate ("death");	// simply an empty state that does not play the exit asset of ending state	

			map_restart();
			return; 
		}

		complete = GetDvarString( "skipto_complete" );

		if ( isdefined( complete ) && complete.size )
		{
			SetDvar( "skipto_complete", "" );
			level objective_completed( complete, GetPlayers()[0] );
		}

		{wait(.05);};
	}
}

/#
	
function menu()
{
	level flag::wait_till( "all_players_spawned" );

	player = GetPlayers()[0];
	// wait for button press from loadout screen to be released
	while ( IsDefined(player) && player ButtonPressed( "BUTTON_A" ) )
	{
		{wait(.05);};
	}

	level thread watch_key_combo();

	for ( ;; )
	{
		if ( isdefined(GetDvarInt( "debug_skipto" )) && GetDvarInt( "debug_skipto" ) )
		{
				// TFLAME - 3/21/11 - unsupported code API
			SetDvar( "debug_skipto", 0 );
			//SetSavedDvar( "hud_drawhud", 1 );
			GetPlayers()[0] allowjump(false); // TFLAME - 3/22/11 - Looks bad to jump when selecting in a menu
			display();
			GetPlayers()[0] allowjump(true);
		}
		
		{wait(.05);};
	}	
}

#/

function key_combo_pressed()
{
	player = GetPlayers()[0];
	if ( IsDefined(player) &&
		 player ButtonPressed( "BUTTON_X" ) &&
	     player ButtonPressed( "DPAD_RIGHT" ) &&
	     player ButtonPressed( "BUTTON_LSHLDR" ) &&
	     player ButtonPressed( "BUTTON_RSHLDR" )
	   )
		return true;
	return false;	
}

function watch_key_combo()
{
	for ( ;; )
	{
		while ( !key_combo_pressed() )
		{
			{wait(.05);};
		}
		SetDvar( "debug_skipto", 1 );
		while ( key_combo_pressed() )
		{
			{wait(.05);};
		}
	}
}


function change_completion_menu( objectives )
{
	rootclear = "devgui_remove \"Map/Skipto/Complete\" \n";
	AddDebugCommand( rootclear );
	rootmenu = "devgui_cmd \"Map/Skipto/";
	compmenu = rootmenu + "Complete/";
	index = 1;
	foreach( objective in objectives )
	{
		name = objective + ":" + index;
		index++;
		AddDebugCommand( compmenu + name + "\" \"set " + "skipto_complete" + " " + objective + "\" \n" );
	}
}

function get_names()
{
	index = 0;
	names = [];
	foreach( struct in level.skipto_settings )
	{
		name = struct.name; // + ":" + index;
		names[index] = name;
		index++;
	}
	return names;
}


// TFLAME - 3/21/11 - Displays the skipto menu
function display()
{
	if ( level.skipto_settings.size <= 0 )
		return;

	names = get_names();
	//names[ names.size ] = "default";
	//names[ names.size ] = "cancel";

	elems = list_menu();
	
	// Available skiptos:
	title = create( "Selected skipto:", -1 );
	title.color = ( 1, 1, 1 );
	strings = [];

	for ( i = 0; i < names.size; i++ )
	{
		s_name = names[ i ];
		skipto_string = "[" + names[ i ] + "]";

		/*
		if( s_name != "cancel" && s_name != "default" && s_name != "no_game" )
		{
			skipto_string += " -> ";
    		if (isdefined( level.skipto_arrays[ s_name ][ "str_name" ] ) )
    		{
    				// TFLAME - 3/21/11 - Can't combine strings and localized strings in our engine so can't do this right now
    			//skipto_string += level.skipto_arrays[ s_name ][ "str_name" ];
    		}
		}
		*/

		strings[ strings.size ] = skipto_string;
	}

	selected = names.size - 1;
	up_pressed = false;
	down_pressed = false;
	
	found_current_skipto = false;
	
	while( selected > 0 )
	{
	    if( names[ selected ] == level.skipto_point )
	    {
	        found_current_skipto = true;
	        break;
	    }
	    selected--;
	}
	
	if( !found_current_skipto )
	{
	    selected = names.size - 1;
	}

	list_settext( elems, strings, selected );
	old_selected = selected;
	
	for ( ;; )
	{
		if ( old_selected != selected )
		{		
			list_settext( elems, strings, selected );
			old_selected = selected;
		}

		if ( !up_pressed )
		{
			if ( GetPlayers()[0] ButtonPressed( "UPARROW" ) || GetPlayers()[0] ButtonPressed( "DPAD_UP" ) || GetPlayers()[0] ButtonPressed( "APAD_UP" ) )
			{
				up_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( !GetPlayers()[0] ButtonPressed( "UPARROW" ) && !GetPlayers()[0] ButtonPressed( "DPAD_UP" ) && !GetPlayers()[0] ButtonPressed( "APAD_UP" ) )
			{
				up_pressed = false;
			}
		}


		if ( !down_pressed )
		{
			if ( GetPlayers()[0] ButtonPressed( "DOWNARROW" ) || GetPlayers()[0] ButtonPressed( "DPAD_DOWN" ) || GetPlayers()[0] ButtonPressed( "APAD_DOWN" ) )
			{
				down_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( !GetPlayers()[0] ButtonPressed( "DOWNARROW" ) && !GetPlayers()[0] ButtonPressed( "DPAD_DOWN" ) && !GetPlayers()[0] ButtonPressed( "APAD_DOWN" ) )
			{
				down_pressed = false;
			}
		}

		if ( selected < 0 )
		{
			selected = names.size - 1;
		}

		if ( selected >= names.size )
		{
			selected = 0;
		}

		if ( GetPlayers()[0] ButtonPressed( "BUTTON_B" ) )
		{
			display_cleanup( elems, title );
			break;
		}

		if ( GetPlayers()[0] ButtonPressed( "kp_enter" ) || GetPlayers()[0] ButtonPressed( "BUTTON_A" ) || GetPlayers()[0] ButtonPressed( "enter" ) )
		{
			if ( names[ selected ] == "cancel" )
			{
				display_cleanup( elems, title );
				break;
			}


			// TFLAME - 3/21/11 - unsuppoted code API.  As far as I can tell it just reset the level 
			//GetPlayers()[0] OpenPopupMenu( "skipto" );
			set_current_skipto( names[ selected ] );

			map_restart();
			return; 
		}
		wait( 0.05 );
	}
}

function list_menu()
{
	hud_array = [];
	for ( i = 0; i < 8; i++ )
	{
		hud = create( "", i );
		hud_array[ hud_array.size ] = hud;
	}

	return hud_array;
}

// handles the updating of the skipto menu selection(s)
function list_settext( hud_array, strings, num )
{
	for ( i = 0; i < hud_array.size; i++ )
	{
		index = i + ( num - 4 );
		if ( isdefined( strings[ index ] ) )
		{
			text = strings[ index ];
		}
		else
		{
			text = "";
		}

		hud_array[ i ] SetText( text );
	}

}

function display_cleanup( elems, title )
{
	title Destroy();
	for ( i = 0; i < elems.size; i++ )
	{
		elems[ i ] Destroy();
	}
}




function nogame()
{
	guys = GetAIArray();
	guys = ArrayCombine( guys, getspawnerarray(), true, false );

	for ( i = 0; i < guys.size; i++ )
	{
		guys[i] delete();
	}
}

function dev_warning()
{
	if ( !is_current_dev() )
	{
		return;
	}

	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.x = 0;
	hudelem.y = 70;
	hudelem SetText( "This skipto is for development purposes only!  The level may not progress from this point." );
	hudelem.alpha = 1;
	hudelem.fontScale = 1.8;
	hudelem.color = ( 1, 0.55, 0 );
	wait( 7 );
	hudelem FadeOverTime( 1 );
	hudelem.alpha = 0;
	wait( 1 );
	hudelem Destroy();
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

function is_current_dev()
{
	return is_dev( level.skipto_point );
}

function is_no_game()
{
	if ( !isdefined( level.skipto_point ) )
	{
		return false;
	}

	return IsSubStr( level.skipto_point, "no_game" );
}

function do_no_game() // currently call this after 442
{
	if ( !is_no_game() )
	{
		return;
	}

	// we want ufo/noclip to hit triggers in no_game
	level.stop_load = true;

	// SRS 11/25/08: LDs can run a custom setup function for their levels to get back some
	//  selected script calls (loadout, vision, etc).  be careful, this function is not threaded!
	if ( isdefined( level.custom_no_game_setupFunc ) )
	{
		level [[ level.custom_no_game_setupFunc ]]();
	}

	level thread load::all_players_spawned();
	array::thread_all( GetEntArray( "water", "targetname" ), &load::water_think );
	level waittill( "eternity" );
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

/@
"Name: teleport( <skipto_name>, <friendly_ai>, <coop_sort> )"
"Summary: teleports players and ai for skiptos"
"Module: Utility"
"CallOn: Structs must be set up in radiant with a targetname equal to skipto_name for the player(s) to teleport to.  Structs with a targetname of skipto_name+"_ai" must be set up for AI to teleport to"
"Example: skipto::teleport( "airfield", "blue_squad", true );"
"MandatoryArg: <skipto_name> : the name of the skipto"
"OptionalArg: <friendly_ai> : Either an array of AI or a script_noteworthy value of ai to teleport"
"OptionalArg: <coop_sort> : if the skipto is set up for coop, players will be placed in accordance with a script_int value on the skipto structs in radiant"
"SPMP: singleplayer"
@/
function teleport( skipto_name, friendly_ai, coop_sort )
{
	teleport_ai( skipto_name, friendly_ai );
	teleport_players( skipto_name, coop_sort );
}

/@
"Name: teleport_ai( <skipto_name>, <friendly_ai> )"
"Summary: Teleports AI's to structs with the specified skipto_name+"_ai" as a targetname."
"Module: Utility"
"Example: skipto::teleport_ai( ::"mangrove", mangrove_heroes );"
"MandatoryArg: <skipto_name> : the name of the skipto event.  Must correspond to naming of structs in radiant"
"OptionalArg: <friendly_ai> : Array of AI to teleport.  This can also be a script_noteworthy string of AI to teleport.  If this parameter is empty, all living allies will be grabbed and teleported"
"SPMP: singleplayer"
@/
function teleport_ai( skipto_name, friendly_ai )
{
	if ( !isdefined( friendly_ai ) )
	{
		if ( isdefined( level.heroes ) )
		{
			friendly_ai = level.heroes;
		}
		else
		{
			friendly_ai = GetAITeamArray( "allies" );
		}
	}

	if ( IsString( friendly_ai ) )
	{
		friendly_ai = GetAIArray( friendly_ai, "script_noteworthy" );
	}

	if ( !IsArray( friendly_ai ) )
	{
		friendly_ai = array( friendly_ai );
	}
	
	friendly_ai = array::remove_dead( friendly_ai );

	a_skipto_structs = ArrayCopy( struct::get_array( skipto_name + "_ai", "targetname" ) );
	
	assert( a_skipto_structs.size >= friendly_ai.size, "Need more start positions for ai for " + skipto_name + "!  Tried to teleport " + friendly_ai.size + " AI to only " + a_skipto_structs.size + " structs" );	

	if ( !a_skipto_structs.size )
	{
		return;
	}

	foreach( ai in friendly_ai )
	{
		if ( isdefined( ai ) )
		{
			start_i = 0;
	
			if ( isdefined( ai.script_int ) )
			{
				for ( j = 0; j < a_skipto_structs.size; j++ )
				{
					if ( isdefined( a_skipto_structs[j].script_int ) )
					{
						if ( a_skipto_structs[j].script_int == ai.script_int )
						{
							start_i = j;
							break;
						}
					}
				}
			}
	
			ai teleport_single_ai( a_skipto_structs[start_i] );
			ArrayRemoveValue( a_skipto_structs, a_skipto_structs[start_i] );
		}
	}
}

function teleport_single_ai( ai_skipto_spot )
{
	if ( isdefined( ai_skipto_spot.angles ) )
	{
		self ForceTeleport( ai_skipto_spot.origin, ai_skipto_spot.angles );
	}
	else
	{
		self ForceTeleport( ai_skipto_spot.origin );
	}

	// so they don't run back to their original spot
	if ( isdefined( ai_skipto_spot.target ) )
	{
		node = GetNode( ai_skipto_spot.target, "targetname" );

		if ( isdefined( node ) )
		{
			self SetGoal( node );
			return;
		}
	}

	self SetGoal( ai_skipto_spot.origin );
}

function get_snapped_spot_origin( spot_position )
{
	snap_max_height = 100;
	size = 15;
	height = size * 2;
	mins = (-1 * size, -1 * size, 0 );
	maxs = ( size, size, height );
	
	spot_position = (spot_position[0], spot_position[1], spot_position[2] + 5);
	new_spot_position = ( spot_position[0], spot_position[1], spot_position[2] - snap_max_height);
	
	trace = physicstrace( spot_position, new_spot_position, mins, maxs, self);

	if ( trace["fraction"] < 1 )
	{
		return trace["position"];
	}
	
	return spot_position;
}

function teleport_players( skipto_name, coop_sort )
{
	wait_for_first_player();
	
	// Grab the skipto points. if this skipto is the entrypoint into the level or needs each player in a particular spot, sort them for coop placement
	skipto_spots = get_spots( skipto_name, coop_sort );

	// make sure there are enough points skipto spots for the players
	assert( skipto_spots.size >= level.players.size, "Need more skipto positions for players!" );

	// set up each player
	for ( i = 0; i < level.players.size; i++ )
	{
		skiptoOrigin = skipto_spots[i].origin;
		skiptoOrigin = level.players[i] get_snapped_spot_origin(skiptoOrigin);
		
		// Set the players' origin to each skipto point
		level.players[i] SetOrigin( skiptoOrigin );

		if ( isdefined( skipto_spots[i].angles ) )
		{
			// Set the players' angles to face the right way.
			level.players[i] SetPlayerAngles( skipto_spots[i].angles );
		}
	}

	//set_breadcrumbs(skipto_spots);
}

function get_spots( skipto_name, coop_sort = false )
{
	skipto_spots = struct::get_array( skipto_name, "targetname" );
	
	if ( !skipto_spots.size )
	{
		skipto_spots = spawnlogic::get_spawnpoint_array( "cp_coop_spawn", true );
		skipto_spots = filter_player_spawnpoints( undefined, skipto_spots, skipto_name );
	}
	
	if ( coop_sort )
	{
		for ( i = 0; i < skipto_spots.size; i++ )
		{
			for ( j = i; j < skipto_spots.size; j++ )
			{
				assert( isdefined( skipto_spots[j].script_int ), "player skipto struct at: " + skipto_spots[j].origin + " must have a script_int set for coop spawning" );
				assert( isdefined( skipto_spots[i].script_int ), "player skipto struct at: " + skipto_spots[i].origin + " must have a script_int set for coop spawning" );
	
				if ( skipto_spots[j].script_int < skipto_spots[i].script_int )
				{
					temp = skipto_spots[i];
					skipto_spots[i] = skipto_spots[j];
					skipto_spots[j] = temp;
				}
			}
		}
	}
	
	return skipto_spots;
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
		if ( !first )
		{
			ostr = ostr + totok;
		}

		first = false;
		ostr = ostr + s;
	}
	return ostr;
}

function load_mission_table( table, levelname, sublevel = "" )
{
	index = 0;
	row = TableLookupRow( table, index );

	while ( isdefined( row ) )
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
		row = TableLookupRow( table, index );
	}
}

function load_mission_init()
{
}

function wait_for_first_player()
{
	level flag::wait_till( "skipto_player_connected" );
}

function on_player_connect()
{
	level flag::set( "skipto_player_connected" );
}

function objective_completed( name, player )
{
	Assert( isdefined( level.skipto_settings[ name ] ), "Invalid skipto \"" + name + "\" passed to skipto::objective_completed " );
	
	foreach( statPlayer in level.players )
	{
		if ( statPlayer isTestClient() )
			continue;		
			    
		bb::logObjectiveStatusChange(name, statPlayer, "complete");
		
		//save off hero weapons if they exist
		statPlayer globallogic_player::SaveHeroWeapons();
		
		for ( index = 0; index < level.players.size; index++ )
		{
			lvlplayer = level.players[index];
			
			//Save player stats
			statPlayer setDStat( "AfterActionReportStats", "playerStats", index, "score", lvlplayer.pers["score"] );
			statPlayer setDStat( "AfterActionReportStats", "playerStats", index, "kills", lvlplayer.pers["kills"] );
			statPlayer setDStat( "AfterActionReportStats", "playerStats", index, "deaths", lvlplayer.pers["deaths"] );
			statPlayer setDStat( "AfterActionReportStats", "playerStats", index, "assists", lvlplayer.pers["assists"] );
			statPlayer setDStat( "AfterActionReportStats", "playerStats", index, "revives", lvlplayer.pers["revives"] );
		}
		UploadStats( statPlayer );
	}
	
	if ( isdefined( name ) )
	{
		stop_objective_logic( name, false, true, player );
	}

	next = get_next_skiptos( name );
	next = check_skipto_conditions( next );
	
	if ( isdefined( next ) && next.size > 0 )
	{
		set_level_objective( next, false, player );
		thread savegame::save();
		
		// Message only the host that their savegame is being updated. Party member savegames are not overwritten.
		util::show_event_message(level.players[0], &"COOP_REACHED_SKIPTO");
	}
}





function private regroup_triggers()
{
	foreach ( trig in trigger::get_all() )
	{
		if ( isdefined( trig.scriptgroup_playerspawns_regroup ) )
		{
			trig thread _regroup_trigger();
		}
	}
}

function private _regroup_trigger()
{
	self endon( "death" );
	
	level flag::wait_till( "all_players_spawned" );
	
	a_regroup_locs = get_regroup_spawnpoints( self.scriptgroup_playerspawns_regroup );
	
	Assert( a_regroup_locs.size >= 3, "Must have at least 3 regroup spawn points." );
	
	while ( true )
	{
		self waittill( "trigger", lead_player );
			
		if ( IsPlayer( lead_player ) )
		{
			foreach ( player in level.players )
			{
				if ( player != lead_player )
				{
					if ( player.sessionstate === "playing" )
					{
						n_dist = ( isdefined( self.script_regroup_distance ) ? self.script_regroup_distance * self.script_regroup_distance : ( 1500 * 1500 ) );
						
						if ( DistanceSquared( player.origin, lead_player.origin ) > n_dist )
						{
							if ( !player IsTouching( self ) )
							{
								player thread regroup_player( a_regroup_locs );
							}
						}
					}
				}
			}
			
			break; // only regroup once from each trigger
		}
	}
}

function get_regroup_spawnpoints( str_num )
{
	a_ret = [];
	
	a_regroup_locs = spawnlogic::get_all_spawn_points();
	foreach ( loc in a_regroup_locs )
	{
		if ( loc.scriptgroup_playerspawns_regroup === str_num )
		{
			if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=loc;;
		}
	}
	
	return a_ret;
}

function private regroup_player( a_regroup_locs )
{
	self endon( "death" );
	
	foreach ( loc in a_regroup_locs )
	{
		if ( !( isdefined( loc.b_used ) && loc.b_used ) )
		{
			loc.b_used = true;
			
			clientfield::increment_to_player( "postfx_igc", 1 ); //the same transition as the scene system
			
			wait .5;
			
			self SetOrigin( loc.origin );

			if ( isdefined( loc.angles ) )
			{
				self SetPlayerAngles( loc.angles );
			}
			
			break;
		}
	}
}

/#

function show_level_objectives( objectives )
{
	SetDvar( "bgcache_disablewarninghints", 1 );
	
	index = 0;
	foreach( name in objectives )
	{
		skipto_struct = level.skipto_settings[ name ];

		if ( isdefined( skipto_struct.str_name ) && skipto_struct.str_name.size )
		{
			thread indicate( skipto_struct.str_name, index );
			index++;
		}
	}
	
	SetDvar( "bgcache_disablewarninghints", 0 );
}

#/

function set_level_objective( objectives, starting, player )
{
	if(( isdefined( starting ) && starting ) && !( isdefined( level.stats_loaded ) && level.stats_loaded ))
	{
		level.stats_loaded = true;
		
		if( ( util::is_new_cp_map() || util::is_safehouse() ) && ( objectives[0] === level.default_skipto ) )
		{
			//reset player stats when starting a new map
			for ( index = 0; index < level.players.size; index++ )
			{
				lvlplayer = level.players[index];
				
				lvlplayer setDStat( "AfterActionReportStats", "playerStats", index, "score", 0 );
				lvlplayer setDStat( "AfterActionReportStats", "playerStats", index, "kills", 0 );
				lvlplayer setDStat( "AfterActionReportStats", "playerStats", index, "deaths", 0 );
				lvlplayer setDStat( "AfterActionReportStats", "playerStats", index, "assists", 0 );
				lvlplayer setDStat( "AfterActionReportStats", "playerStats", index, "revives", 0 );
				
				UploadStats( lvlplayer );
			}
		}
		else
		{
			//load player stats between sub-maps and objectives
			for ( index = 0; index < level.players.size; index++ )
			{
				lvlplayer = level.players[index];
				
				lvlplayer.pers["score"] = lvlplayer getDStat( "AfterActionReportStats", "playerStats", index, "score" );
				lvlplayer.pers["kills"] = lvlplayer getDStat( "AfterActionReportStats", "playerStats", index, "kills" );
				lvlplayer.pers["deaths"] = lvlplayer getDStat( "AfterActionReportStats", "playerStats", index, "deaths" );
				lvlplayer.pers["assists"] = lvlplayer getDStat( "AfterActionReportStats", "playerStats", index, "assists" );
				lvlplayer.pers["revives"] = lvlplayer getDStat( "AfterActionReportStats", "playerStats", index, "revives" );
			}
		}
	}
	
	clear_recursion();
	foreach( name in objectives )
	{
		if ( isdefined( level.skipto_settings[ name ] ) )
		{
			stop_objective_logic( level.skipto_settings[ name ].prev, starting, false, player );
		}
	}

	if ( isdefined( level.func_skipto_cleanup ) )
	{
		foreach( name in objectives )
		{
			thread [[ level.func_skipto_cleanup ]]( name );
		}
	}

	/#
	thread show_level_objectives( objectives );
	#/
		
	start_objective_logic( objectives, starting );
	level.skipto_point = level.skipto_current_objective[0];
	if ( !( isdefined( level.level_ending ) && level.level_ending ) )
	{
		set_current_skiptos( level.skipto_current_objective );
	}
	level notify( "objective_changed", level.skipto_current_objective );
	
	// Please do not use the following (bzm_skipto_objective_changed_callback) callback for your purposes. Its only meant to be used by BONUSZM mode.
	if(IsDefined(level.bzm_skipto_objective_changed_callback))
	{
		[[level.bzm_skipto_objective_changed_callback]]( level.skipto_current_objective );
	}
	
	change_completion_menu( level.skipto_current_objective );
	
	level thread update_spawn_points( starting );
}

function update_spawn_points( starting )
{
	level endon( "objective_changed" );
	
	level flag::wait_till( "first_player_spawned" );
	
	spawnlogic::clear_spawn_points();
	spawnlogic::add_spawn_points( "allies", "cp_coop_spawn" );
	spawnlogic::add_spawn_points( "allies", "cp_coop_respawn" );
	spawning::updateAllSpawnPoints();
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
		if ( isdefined( level.skipto_settings[ name ] ) )
		{
			if ( !( isdefined( level.skipto_settings[ name ].objective_running ) && level.skipto_settings[ name ].objective_running ) )
			{
				If ( !IsInArray( level.skipto_current_objective, name ) )
				{
					if ( !isdefined( level.skipto_current_objective ) ) level.skipto_current_objective = []; else if ( !IsArray( level.skipto_current_objective ) ) level.skipto_current_objective = array( level.skipto_current_objective ); level.skipto_current_objective[level.skipto_current_objective.size]=name;;
				}
				level notify( name + "_init" );
				level.skipto_settings[ name ].objective_running = true;
				
				if ( !GetDvarInt( "art_review", 0 ) )
				{
					standard_objective_init( name, starting );

					if ( isdefined( level.skipto_settings[ name ].skipto_func ) )
					{
						thread [[ level.skipto_settings[ name ].skipto_func ]]( name, starting );
						savegame::checkpoint_save();
					}
				}
			}

			if ( !( isdefined( level.skipto_settings[ name ].logic_running ) && level.skipto_settings[ name ].logic_running ) && isdefined( level.skipto_settings[ name ].logic_func ) )
			{
				// DEPRECATED - remove
				level.skipto_settings[ name ].logic_running = true;
				thread [[ level.skipto_settings[ name ].logic_func ]]( name );
			}
		}
		
		foreach (player in level.players)
		{
			bb::logObjectiveStatusChange(name, player, "start");
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

function stop_objective_logic( name, starting, direct, player )
{
	if ( IsArray( name ) )
	{
		foreach( element in name )
		{
			stop_objective_logic( element, starting, direct, player );
		}
	}
	else
	{
		if ( isdefined( level.skipto_settings[ name ] )  )
		{
			cleaned = false;
			if ( ( isdefined( level.skipto_settings[ name ].objective_running ) && level.skipto_settings[ name ].objective_running ) )
			{
				cleaned = true;
				level.skipto_settings[ name ].objective_running = false;
				If ( IsInArray( level.skipto_current_objective, name ) )
				{
					ArrayRemoveValue( level.skipto_current_objective, name );
				}

				if ( !GetDvarInt( "art_review", 0 ) )
				{
					if ( isdefined( level.skipto_settings[ name ].cleanup_func ) )
					{						
						thread [[ level.skipto_settings[ name ].cleanup_func ]]( name, starting, direct, player );
					}

					standard_objective_done( name, starting, direct, player );
				}
				
				level notify( name + "_terminate" );
			}

			if ( !( isdefined( level.skipto_settings[ name ].cleanup_recursion ) && level.skipto_settings[ name ].cleanup_recursion )  )
			{
				level.skipto_settings[ name ].cleanup_recursion = true;
				if ( !( isdefined( level.skipto_settings[ name ].looping ) && level.skipto_settings[ name ].looping ) )
				{
					prev = level.skipto_settings[ name ].prev;
					foreach( element in prev )
					{
						stop_objective_logic( element, starting, false, player );
					}
				}
				
				if ( starting && !cleaned )
				{
					if ( !GetDvarInt( "art_review", 0 ) )
					{
						if ( isdefined( level.skipto_settings[ name ].cleanup_func ) )
						{
							thread [[ level.skipto_settings[ name ].cleanup_func ]]( name, starting, false, player );
						}
	
						standard_objective_done( name, starting, false, player );
					}
				}
			}
		}
	}
}

function filter_spawnpoints( spawnpoints )
{
	return filter_player_spawnpoints( undefined, spawnpoints );
}

function filter_player_spawnpoints( player, spawnpoints, str_skipto )
{
	objectives = (isdefined(str_skipto)?str_skipto:level.skipto_current_objective);
	
	if ( !isdefined( objectives) || !objectives.size )
	{
		objectives = get_current_skiptos();
		if ( !isdefined( objectives) || !objectives.size )
		{
			objectives = level.default_skipto;
		}
	}
	
	filter = [];
	
	if ( !isdefined( objectives ) ) objectives = []; else if ( !IsArray( objectives ) ) objectives = array( objectives );;	
	foreach( objective in objectives )
	{
		if ( isdefined( level.skipto_settings[ objective ] ) )
		{
			if ( ( isdefined( level.skipto_settings[ objective ].public ) && level.skipto_settings[ objective ].public ) || 
			     ( isdefined( level.skipto_settings[ objective ].dev_skipto ) && level.skipto_settings[ objective ].dev_skipto ) )
			{
				if ( !isdefined( filter ) ) filter = []; else if ( !IsArray( filter ) ) filter = array( filter ); filter[filter.size]=objective;;
			}
		}
	}

	if ( isdefined( filter ) && filter.size > 0 )
	{
		anypoints = [];
		retpoints = [];
		foreach( point in spawnpoints )
		{
			point.different_skipto = false;
			
			if ( isdefined( point.script_objective ) && IsInArray( filter, point.script_objective ) )
			{
				if ( !isdefined( retpoints ) ) retpoints = []; else if ( !IsArray( retpoints ) ) retpoints = array( retpoints ); retpoints[retpoints.size]=point;;
			}
			else if ( !isdefined( point.script_objective ) )
			{
				if ( !isdefined( anypoints ) ) anypoints = []; else if ( !IsArray( anypoints ) ) anypoints = array( anypoints ); anypoints[anypoints.size]=point;;
			}
			else
			{
				point.different_skipto = true;
			}
		}

		if ( retpoints.size > 0 )
		{
			return retpoints;
		}
		
		return anypoints;
	}

	return spawnpoints;
}

function delete_start_spawns( str_skipto )
{
	a_spawns = spawnlogic::get_spawnpoint_array( "cp_coop_spawn" );
	foreach ( spawn_point in a_spawns )
	{
		if ( spawn_point.script_objective == str_skipto )
		{
			if ( ( spawn_point.classname === "script_model" ) )
			{
				spawn_point Delete();
			}
			else
			{
				spawn_point struct::delete();
			}
		}
	}
}

/@
"Name: preload_next_level()"
"Summary: Start preloading the next level.  Call some time before the level ends."
"CallOn: Any"
"Example: level skipto::preload_next_level();"
@/
function preload_next_level()
{
	level.preloading_next_level = true;
	
	str_next_map = GetNextMap();
	
	if ( should_skip_safehouse() || ( SessionModeIsCampaignZombiesGame() ) )
	{
		SwitchMap_PreLoad( str_next_map );
	}
	else if ( !is_final_level() )
	{
		str_next_safehouse = util::get_next_safehouse( str_next_map );
		SwitchMap_PreLoad( str_next_safehouse );
	}
}


function open_aar_menus_for_player()
{
	menuHandle = self OpenLuiMenu( "RewardsOverlayCP" );
	
	self waittill( "menuresponse", menu, response );
	while ( response != "closed" )
	{
		self waittill( "menuresponse", menu, response );
	}
	
	self CloseLuiMenu( menuHandle );
}

function level_completed( skipto, starting )
{
	foreach( lvlplayer in level.players)
	{
		bb::logObjectiveStatusChange("_level", lvlplayer, "complete");
	}
	
	globallogic_player::SetZombieCampaignUnlocked();
	
	// end mission
	if ( !( isdefined( level.level_ending ) && level.level_ending ) )
	{	
		level lui::screen_fade_out( 1 );
		
		if( ( isdefined( level.b_end_of_level_aar ) && level.b_end_of_level_aar ) && !( SessionModeIsCampaignZombiesGame() ) )
		{
			level accolades::commit(); // Commit accolades before AAR 
			for( i = 1; i < level.players.size; i++ )
			{
				level.players[i] thread open_aar_menus_for_player();
			}
			
			// block on the host
			level.players[0] open_aar_menus_for_player();
		}
		else
		{
			world.show_aar = true; // show the AAR in the safe house
		}

		if( ( SessionModeIsCampaignZombiesGame() ) )		
		{
			current_map_name = ToLower( GetDvarString( "mapname" ) );
			tokens = StrTok( current_map_name, "_" );
			modified_current_map_name = "";
			
			for( i=0; i<tokens.size; i++ )
			{
				if( i == 0 )
				{
					modified_current_map_name = modified_current_map_name + tokens[i]; 
					modified_current_map_name = modified_current_map_name + "_nightmares";					
				}
				else
				{
					modified_current_map_name = modified_current_map_name + "_" + tokens[i]; 
				}				
			}
			
			str_next_map = GetNextMap(modified_current_map_name);
			tokens = StrTok( str_next_map, "_" );
			modified_str_map_name = "cp";
			
			for( i=2; i<tokens.size; i++ )
			{
				modified_str_map_name = modified_str_map_name + "_" + tokens[i]; 								
			}
			
			str_next_map = modified_str_map_name;
		}
		else if ( is_final_level() ) // last level in regular campaign
		{
			
		}
		else
		{
			str_next_map = GetNextMap();
		}
		
		if ( isdefined( str_next_map ) )
		{
			/#
			
			// Fix issues exiting immediately upon load using debug skiptos.
			if ( skipto == "_exit" && starting )
			{
				wait 4.0;
			}
			
			#/
				
				
			// Load into the safehouse leading into the next map.
			if ( should_skip_safehouse() || ( SessionModeIsCampaignZombiesGame() ) )
			{
				str_intro_movie = GetMapIntroMovie( str_next_map );
				if ( isdefined( str_intro_movie ) )
				{
					SwitchMap_SetLoadingMovie( str_intro_movie );
				}
				
				if ( !( isdefined( level.preloading_next_level ) && level.preloading_next_level ) )
				{
					SwitchMap_Load( str_next_map );
				}
			}
			else
			{
				str_outro_movie = GetMapOutroMovie();
				if ( isdefined( str_outro_movie ) )
				{
					SwitchMap_SetLoadingMovie( str_outro_movie );
				}
			
				world.next_map = str_next_map;
				if ( !isdefined( world.highest_map_reached ) || ( GetMapOrder( str_next_map ) > GetMapOrder( world.highest_map_reached ) ) )
				{
					world.highest_map_reached = str_next_map;
				}
							
				world.last_map = level.script;
				level accolades::commit();
				if ( !( isdefined( level.preloading_next_level ) && level.preloading_next_level ) )
				{
					str_next_safehouse = util::get_next_safehouse( str_next_map );
					SwitchMap_Load( str_next_safehouse );
				}
			}
			
			util::wait_network_frame();		// Let the next map/video register with the code systems before advancing.
			skipto::set_current_skipto( "" );
			
			Savegame_Create(); // Save game at the end of every level
			if( is_last_level_in_mission( str_next_map ) )
			{
				//check if level has been completed before
				foreach( e_player in level.players )
				{
					if( !IsDefined( GetRootMapName() ) )
					{
						break;
					}
					first_time_completing_mission = !( e_player GetDStat( "PlayerStatsByMap", GetRootMapName(), "hasBeenCompleted" ) );
					if( ( isdefined( first_time_completing_mission ) && first_time_completing_mission ) )
					{
						e_player SetDStat( "PlayerStatsByMap", GetRootMapName(), "hasBeenCompleted", 1 );
						e_player GiveUnlockToken( 1 );
					}
					current_difficulty = GetLocalProfileInt( "g_gameskill" ) + 1;
					highest_completed_difficulty = e_player GetDStat( "PlayerStatsByMap", GetRootMapName(), "highestStats", "HIGHEST_DIFFICULTY" );
					if( current_difficulty > highest_completed_difficulty )
					{
						e_player SetDStat( "PlayerStatsByMap", GetRootMapName(), "highestStats", "HIGHEST_DIFFICULTY", current_difficulty );
						switch( current_difficulty )
						{
							case 0:
								e_player AddRankXp( "complete_mission_recruit" );
								break;
							case 1:
								e_player AddRankXp( "complete_mission_regular" );
								break;
							case 2:
								e_player AddRankXp( "complete_mission_hardened" );
								break;
							case 3:
								e_player AddRankXp( "complete_mission_veteran" );
								break;
							case 4:
								e_player AddRankXp( "complete_mission_realistic" );
								break;								
						}
					}
					e_player savegame::set_player_data( "last_mission", "" ); //force accolades to reset on next mission
				}
			}
			
			SwitchMap_Switch();
			UploadStats();
		}
		else
		{
			// No next map available--return to the frontend.
			UploadStats();
			ExitLevel( false );
		}
	}
		
	level.level_ending = true;
}

function is_last_level_in_mission( next_level_name )
{
	return !IsMapSubLevel( next_level_name );
}

//========================================================
// default handlers for missions with no function calls

function private standard_objective_init( skipto, starting )
{
	if( IsDefined(level.BZMStartObjectiveCallback) ) [[level.BZMStartObjectiveCallback]](skipto,starting);;
	
	level flag::set( skipto );
	
	level thread watch_completion( skipto );
	
	level.current_skipto = skipto;
	
	level notify( "update_billboard" );
}

/@
"Name: set_level_start_flag( <str_flag> )"
"Summary: Wrapper for util::set_level_start_flag, please use that instead.."
"CallOn: NA"
"MandatoryArg: <str_flag> : flag to wait for"
"Example: skipto::set_level_start_flag( "start_level" )"
@/
function set_level_start_flag( str_flag )
{
	util::set_level_start_flag( str_flag );
}

function private standard_objective_done( skipto, starting, direct, player )
{
	if( IsDefined(level.BZMWaitForObjectiveCompletionCallback) ) [[level.BZMWaitForObjectiveCompletionCallback]]();;
	
	level flag::clear( skipto );
	level flag::set( skipto + "_completed" );
	
	if ( !IsDefined( level.skipto_settings[ skipto ] ) )
	{
		AssertMsg( "Unknown objective name: " + skipto );
	}
	
	if ( !( isdefined( level.preserve_script_objective_ents ) && level.preserve_script_objective_ents ) )
	{
		waittillframeend;
		
		//Go through all entities and automatically cleanup anything tagged with this objective
		a_entities = GetEntArray( skipto, "script_objective" );
		foreach ( entity in a_entities )
		{
			if ( IsSentient( entity ) )
			{
				// Don't auto-delete heroes
				if ( !isdefined( level.heroes ) || !IsInArray( level.heroes, entity ) )
				{
					entity thread util::auto_delete();
				}
			}
			else if ( IsVehicle( entity ) )
			{
				entity.delete_on_death = true;           entity notify( "death" );           if( !IsAlive( entity ) )           entity Delete();;
			}
			else
			{
				entity delete();
			}
		}
	}
}

//============================================================
// Objective triggers

// In theory this should work for multiple exit triggers, but it hasn't been tested with that configuration
function watch_completion( name )
{
	first_trigger = undefined;
	objective_triggers = GetEntArray( "objective", "targetname" );
	foreach ( trigger in objective_triggers )
	{
		if ( trigger.script_objective == name )
		{
			if ( !isdefined( first_trigger ) )
			{
				first_trigger = trigger;
			}

			first_trigger thread trigger_watch_completion( trigger, name );
		}
	}
}

function all_players_touching( trigger )
{
	foreach( player in GetPlayers() )
	{
		if ( !player IsTouching( trigger ) )
		{
			return false;
		}
	}
	return true;
}

function trigger_wait_completion( trigger, name )
{
	trigger endon( "death" );
	level endon( name + "_terminate" );

	if ( ( trigger.script_noteworthy === "allplayers" ) )
	{
		// TODO: Obsolete.  Remove 'script_noteworthy' support in favor of 'script_trigger_allplayers'
		do
		{
			trigger waittill( "trigger", player );
		}
		while ( !all_players_touching( trigger ) );
	}
	else
	{
		trigger waittill( "trigger", player );

		if ( ( trigger.script_noteworthy === "warpplayers" ) )
		{
			foreach( other_player in level.players )
			{
				if ( other_player != player )
				{
					other_player thread catch_up_teleport();
				}
			}
		}
	}

	level thread skipto::objective_completed( trigger.script_objective, player );
	return player;
}

function trigger_watch_completion( trigger, name )
{
	self endon( "trigger_watch_completion" );

	player = trigger_wait_completion( trigger, name );

	self notify( "trigger_watch_completion" );
}


function catch_up_teleport()
{
	self.suicide = false;
	self.teamKilled = false;
	timePassed = undefined;

	if ( isdefined( self.respawnTimerStartTime ) )
	{
		timePassed = ( GetTime() - self.respawnTimerStartTime ) / 1000;
	}

	if ( self laststand::player_is_in_laststand() )
	{
		self notify( "auto_revive" );
		waittillframeend;
	}
	
	self notify( "death" ); // The player is gonna respawn so script needs to clean up on this player first	
	self thread [[level.spawnClient]]( timePassed );
	
	self.respawnTimerStartTime = undefined;
}

//========================================================
// entity movers

function entity_mover_main()
{
	entity_movers = struct::get_array( "entity_objective_loc" );
	foreach( mover in entity_movers )
	{
		if(!isdefined(mover.angles))mover.angles=( 0, 0, 0 );

		if ( isdefined( mover.script_objective ) && isdefined( level.skipto_settings[mover.script_objective] ) )
		{
			if ( !isdefined( level.skipto_settings[mover.script_objective].ent_movers ) ) level.skipto_settings[mover.script_objective].ent_movers = []; else if ( !IsArray( level.skipto_settings[mover.script_objective].ent_movers ) ) level.skipto_settings[mover.script_objective].ent_movers = array( level.skipto_settings[mover.script_objective].ent_movers ); level.skipto_settings[mover.script_objective].ent_movers[level.skipto_settings[mover.script_objective].ent_movers.size]=mover;;
		}
	}

	for ( ;; )
	{
		level waittill( "objective_changed", objectives );
		entity_mover_use_objectives( objectives );
	}
}

function entity_mover_use_objectives( objectives )
{
	foreach( objective in objectives )
	{
		foreach( mover in level.skipto_settings[objective].ent_movers )
		{
			thread apply_mover( mover );
		}
	}
}

function apply_mover( mover )
{
	targets = GetEntArray( mover.target, "targetname" );

	if ( isdefined( mover.script_noteworthy ) && mover.script_noteworthy == "relative" )
	{
		speed = 0;

		if ( isdefined( mover.script_int ) )
		{
			speed = mover.script_int;
		}

		if ( speed == 0 )
		{
			speed = .05;
		}

		foreach( target in targets )
		{
			if ( !isdefined( target.start_mover ) )
			{
				target.start_mover = mover;
				target.last_mover = mover;
			}
			else
			{
				start_mover = target.last_mover;
			}

			if ( !isdefined( start_mover ) )
			{
				start_mover = mover;
				speed = .05;
			}
			else
			{
				assert( start_mover == target.last_mover, "target ents cannot be moved from differet start points" );
			}
		}

		if ( !isdefined( start_mover ) || start_mover == mover )
		{
			return;
		}

		script_mover = spawn( "script_origin", start_mover.origin );
		script_mover.angles = start_mover.angles;
		foreach( target in targets )
		{
			target linkTo( script_mover, "", script_mover worldtolocalcoords( target.origin ), target.angles - script_mover.angles );
		}
		util::wait_network_frame();
		script_mover MoveTo( mover.origin, speed );
		script_mover RotateTo( mover.angles, speed );
		script_mover waittill( "movedone" );
		foreach( target in targets )
		{
			target.last_mover = mover;
			target unlink();
		}
		script_mover delete();
	}
	else
	{
		foreach( target in targets )
		{
			target.origin = mover.origin;

			if ( isdefined( mover.angles ) )
			{
				target.angles = mover.angles;
			}
		}
	}
}

//--------------------------------------------------------------
// Safehouse functions
//--------------------------------------------------------------

/@
"Name: set_skip_safehouse()"
"Summary: Sets the level to load directly into the next instead of a safehouse."
"Module: Utility"
"CallOn: Level"
@/
function set_skip_safehouse()
{
	level flag::set( "skip_safehouse_after_map" );
}

/@
"Name: should_skip_safehouse()"
"Summary: Returns if the level should load directly into the next instead of a safehouse."
"Module: Utility"
"CallOn: Level"
@/
function should_skip_safehouse()
{
	return level flag::get( "skip_safehouse_after_map" );
}

/@
"Name: set_final_level()"
"Summary: Sets the level as the last level in the game to prevent loading into another level."
"Module: Utility"
"CallOn: Level"
@/
function set_final_level()
{
	level flag::set( "final_level" );
}

/@
"Name: is_final_level()"
"Summary: Returns if it is the last level in the game to prevent loading into another level."
"Module: Utility"
"CallOn: Level"
@/
function is_final_level()
{
	return level flag::get( "final_level" );
}

//--------------------------------------------------------------
// BILLBOARD functions
//--------------------------------------------------------------

/#

function update_billboard()
{
	self endon( "death" );
	
	while ( true )
	{
		if ( isdefined( level.billboards ) && isdefined( level.billboards[ level.current_skipto ] ) )
		{
			event_name = level.billboards[ level.current_skipto ][ 0 ];
			
			b_same_event = ( level.billboard_event === event_name );
					
			if ( !b_same_event )
			{
				level.billboard_event = event_name;
				
				level.billboard_event_type = level.billboards[ level.current_skipto ][ 1 ];
				level.billboard_event_size = level.billboards[ level.current_skipto ][ 2 ];
				level.billboard_event_state = level.billboards[ level.current_skipto ][ 3 ];
				
				foreach ( player in level.players )
				{
					player notify( "update_billboard" );
				}
			}
			else
			{
				Assert( level.billboard_event_type == level.billboards[ level.current_skipto ][ 1 ], "Billboard: event type mismatch for same event name." );
				Assert( level.billboard_event_size == level.billboards[ level.current_skipto ][ 2 ], "Billboard: event size mismatch for same event name." );
				Assert( level.billboard_event_state == level.billboards[ level.current_skipto ][ 3 ], "Billboard: event state mismatch for same event name." );
			}
		}
		
		level waittill( "update_billboard" );
	}
}

function update_player_billboard()
{
	self endon( "death" );
	
	lui_menu = undefined;
	
	while ( true )
	{
		if ( isdefined( level.billboard_event ) )
		{
			if ( level.billboard_event == "close" )
			{
				if ( isdefined( lui_menu ) )
				{
					self CloseLUIMenu( lui_menu );
					lui_menu = undefined;
				}
			}
			else
			{
				if ( !isdefined( lui_menu ) )
				{
					lui_menu = self OpenLUIMenu( "ScriptDebugBillboard" );
				}
						
				self lui::play_animation( lui_menu, "update" );
				
				if ( isdefined( level.billboard_event_state ) )
				{
					self SetLUIMenuData( lui_menu, "name", level.billboard_event + " (" + level.billboard_event_state + ")" );
		
				}
				else
				{
					self SetLUIMenuData( lui_menu, "name", level.billboard_event );
				}
				
				self SetLUIMenuData( lui_menu, "type", level.billboard_event_type );
				self SetLUIMenuData( lui_menu, "size", level.billboard_event_size );
			}
		}
		
		self waittill( "update_billboard" );
	}
}

#/
