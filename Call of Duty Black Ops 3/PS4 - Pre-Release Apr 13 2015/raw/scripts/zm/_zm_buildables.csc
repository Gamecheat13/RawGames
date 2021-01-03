#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             

#namespace zm_buildables;

function autoexec __init__sytem__() {     system::register("zm_buildables",&__init__,undefined,undefined);    }

function __init__()
{
	//Buidables:
	level.buildable_piece_count = 0; // it's value will be set in level specific gsc file, like zm_transit_buildables.gsc;
}

function add( buildable_name )
{
	if ( !isdefined( level.zombie_include_buildables ) )
	{
		level.zombie_include_buildables = [];
	}
	
	if( isdefined( level.zombie_include_buildables ) && !isdefined( level.zombie_include_buildables[ buildable_name ] ) )
	{
		return;
	}

	buildable_name = level.zombie_include_buildables[ buildable_name ];

	if( !isdefined( level.zombie_buildables ) )
	{
		level.zombie_buildables = [];
	}

	level.zombie_buildables[ buildable_name ] = buildable_name;

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
			clientfield::register( "toplayer", level.buildable_clientfields[i], 1, bits, "int", undefined, !true, true );
		}
	}
	else
	{
		bits = GetMinBitCountForNum(level.buildable_piece_count);
		clientfield::register( "toplayer", "buildable",	1, bits, "int", undefined, !true, true );
	}
}


function set_clientfield_code_callbacks()
{
	wait(0.1);        // This won't run - until after all the client field registration has finished.

	if ( level.zombie_buildables.size > 0 )
	{
		if (IsDefined(level.buildable_slot_count))
		{
			for (i=0; i<level.buildable_slot_count; i++)
			{
				SetupClientFieldCodeCallbacks( "toplayer", 1, level.buildable_clientfields[i] );	
			}
		}
		else
		{
			SetupClientFieldCodeCallbacks( "toplayer", 1, "buildable" );	
		}
	}
}

function get_included_buildable( buildable_name )
{
	if( isdefined( level.zombie_include_buildables ) && isdefined( level.zombie_include_buildables[ buildable_name ] ) )
	{
		return level.zombie_include_buildables[ buildable_name ];
	}
	return undefined;
}

function get_all_included_buildables()
{
	if( isdefined( level.zombie_include_buildables ) )
	   return GetArrayKeys( level.zombie_include_buildables );
}

function include( buiildable_name )
{
	if ( !isdefined( level.zombie_include_buildables ) )
	{
		level.zombie_include_buildables = [];
	}

	level.zombie_include_buildables[ buiildable_name ] = buiildable_name;
}
