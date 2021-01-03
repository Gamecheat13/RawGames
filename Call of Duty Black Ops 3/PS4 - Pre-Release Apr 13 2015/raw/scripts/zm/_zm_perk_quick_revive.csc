#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_perks;

                                                                                       	                                
                                                                                                                               



#precache( "client_fx", "zombie/fx_perk_quick_revive_zmb" );

#namespace zm_perk_quick_revive;

function autoexec __init__sytem__() {     system::register("zm_perk_quick_revive",&__init__,undefined,undefined);    }

// QUICK REVIVE ( QUICK REVIVE )
	
function __init__()
{
	enable_quick_revive_perk_for_level();
}

function enable_quick_revive_perk_for_level()
{
	// register custom functions for hud/lua
	zm_perks::register_perk_clientfields( "specialty_quickrevive", &quick_revive_client_field_func, &quick_revive_callback_func );
	zm_perks::register_perk_effects( "specialty_quickrevive", "revive_light" );
	zm_perks::register_perk_init_thread( "specialty_quickrevive", &init_quick_revive );
}

function init_quick_revive()
{
	if( ( isdefined( level.enable_magic ) && level.enable_magic ) )
	{
		level._effect["revive_light"]	= "zombie/fx_perk_quick_revive_zmb";
	}	
}

function quick_revive_client_field_func()
{
	clientfield::register( "toplayer", "perk_quick_revive", 1, 2, "int", undefined, !true, true );
}

function quick_revive_callback_func()
{
	SetupClientFieldCodeCallbacks( "toplayer", 1, "perk_quick_revive" );
}
