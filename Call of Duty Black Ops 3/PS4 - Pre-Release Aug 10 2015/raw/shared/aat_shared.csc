// AAT stands for Alternative Ammunition Types

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

                           	               	
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace aat;
	
function autoexec __init__sytem__() {     system::register("aat",&__init__,undefined,undefined);    }

function private __init__()
{		
	level.aat_initializing = true;
	level.aat_default_info_name = "none";
	 
	level.aat = [];
	register( "none", "none" );
	
	callback::on_finalize_initialization( &finalize_clientfields );
}

/@
"Name: register_clientfield( <name>, <localized_string> )"
"Summary: Register an AAT
"Module: AAT"
"MandatoryArg: <name> Unique name to identify the AAT.
"MandatoryArg: <localized_string> local string reference.
"Example: level aat::register( "dead_paint", ZM_AAT_BLAST_FURNACE );"
"SPMP: both"
@/
function register( name, localized_string )
{
	assert( ( isdefined( level.aat_initializing ) && level.aat_initializing ), "All info registration in the AAT system must occur during the first frame while the system is initializing" );
	
	assert( IsDefined( name ), "aat::register(): name must be defined" );
	assert( !IsDefined( level.aat[name] ), "aat::register(): AAT '" + name + "' has already been registered" );
	
	assert( IsDefined( localized_string ), "aat::register(): localized_string must be defined" );

	level.aat[name] = SpawnStruct();

	level.aat[name].name = name;
	level.aat[name].localized_string = localized_string;
}

function aat_hud_manager( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( IsDefined( level.update_aat_hud ) )
	{
		[[level.update_aat_hud]]( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
	}
}


function finalize_clientfields()
{
	if ( level.aat.size > 1 )
	{
		array::alphabetize( level.aat );
		
		i = 0;
		foreach ( aat in level.aat )
		{
			aat.n_index = i;
			i++;
		}
		n_bits = GetMinBitCountForNum( level.aat.size - 1 );
		clientfield::register( "toplayer", "aat_current", 1, n_bits, "int", &aat_hud_manager, !true, !true );
	}
	
	level.aat_initializing = false;
}

function aat_get_string( n_aat_index )
{
	foreach ( aat in level.aat )
	{
		if ( aat.n_index == n_aat_index )
		{
			return aat.localized_string;
		}
	}
	return level.aat_default_info_name;
}

