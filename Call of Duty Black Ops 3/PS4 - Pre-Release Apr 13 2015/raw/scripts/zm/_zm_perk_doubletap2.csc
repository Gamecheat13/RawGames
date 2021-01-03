#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_perks;

                                                                                       	                                
                                                                                                                               



#precache( "client_fx", "zombie/fx_perk_doubletap2_zmb" );

#namespace zm_perk_doubletap2;

function autoexec __init__sytem__() {     system::register("zm_perk_doubletap2",&__init__,undefined,undefined);    }

// DOUBLETAP2 ( DOUBLE TAP II )
	
function __init__()
{
	enable_doubletap2_perk_for_level();
}

function enable_doubletap2_perk_for_level()
{
	// register custom functions for hud/lua
	zm_perks::register_perk_clientfields( "specialty_doubletap2", &doubletap2_client_field_func, &doubletap2_code_callback_func );
	zm_perks::register_perk_effects( "specialty_doubletap2", "doubletap2_light" );
	zm_perks::register_perk_init_thread( "specialty_doubletap2", &init_doubletap2 );
}

function init_doubletap2()
{
	if( ( isdefined( level.enable_magic ) && level.enable_magic ) )
	{
		level._effect["doubletap2_light"]						= "zombie/fx_perk_doubletap2_zmb";
	}	
}

function doubletap2_client_field_func()
{
	clientfield::register( "toplayer", "perk_doubletap2", 1, 2, "int", undefined, !true, true ); 
}

function doubletap2_code_callback_func()
{
	SetupClientFieldCodeCallbacks( "toplayer", 1, "perk_doubletap2" );
}
