#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_perks;

                                                                                       	                                
                                                                                                                               



#precache( "client_fx", "zombie/fx_perk_juggernaut_zmb" );

#namespace zm_perk_juggernaut;

function autoexec __init__sytem__() {     system::register("zm_perk_juggernaut",&__init__,undefined,undefined);    }

// JUGGERNAUT
	
function __init__()
{
	// register custom functions for hud/lua
	zm_perks::register_perk_clientfields( "specialty_armorvest", &juggernaut_client_field_func, &juggernaut_code_callback_func );
	zm_perks::register_perk_effects( "specialty_armorvest", "jugger_light" );
	zm_perks::register_perk_init_thread( "specialty_armorvest", &init_juggernaut );
}

function init_juggernaut()
{
	if( ( isdefined( level.enable_magic ) && level.enable_magic ) )
	{
		level._effect["jugger_light"]	= "zombie/fx_perk_juggernaut_zmb";		
	}	
}

function juggernaut_client_field_func()
{
	clientfield::register( "toplayer", "perk_juggernaut", 1, 2, "int", undefined, !true, true );
}

function juggernaut_code_callback_func()
{
	SetupClientFieldCodeCallbacks( "toplayer", 1, "perk_juggernaut" );
}
