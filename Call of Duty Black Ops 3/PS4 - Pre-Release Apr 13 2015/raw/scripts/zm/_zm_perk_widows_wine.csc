#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_perks;

                                                                                       	                                
                                                                                                                               
                                            	       

#precache( "client_fx", "_t6/misc/fx_zombie_cola_revive_on" );
#precache( "client_fx", "zombie/fx_widows_wrap_torso_zmb" );

#namespace zm_perk_widows_wine;

function autoexec __init__sytem__() {     system::register("zm_perk_widows_wine",&__init__,undefined,undefined);    }

// WIDOW'S WINE
	
function __init__()
{
	// register custom functions for hud/lua
	zm_perks::register_perk_clientfields( "specialty_widowswine", &widows_wine_client_field_func, &widows_wine_code_callback_func );
	zm_perks::register_perk_effects( "specialty_widowswine", "widow_light" );
	zm_perks::register_perk_init_thread( "specialty_widowswine", &init_widows_wine );
}


function init_widows_wine()
{
	if( ( isdefined( level.enable_magic ) && level.enable_magic ) )
	{
		level._effect["widow_light"]	= "_t6/misc/fx_zombie_cola_revive_on";
		level._effect["widows_wine_wrap"]			= "zombie/fx_widows_wrap_torso_zmb";
	}
}


function widows_wine_client_field_func()
{
	clientfield::register( "toplayer", "perk_widows_wine", 1, 2, "int", undefined, !true, true ); 

	clientfield::register( "actor", "widows_wine_wrapping", 1, 1, "int", &widows_wine_wrap_cb, !true, true ); 
}

function widows_wine_code_callback_func()
{
	SetupClientFieldCodeCallbacks( "toplayer", 1, "perk_widows_wine" );
}

function widows_wine_wrap_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		if ( !isdefined( self.fx_widows_wine_wrap ) )
		{
			self.fx_widows_wine_wrap = PlayFxOnTag( localClientNum, level._effect["widows_wine_wrap"], self, "j_spineupper" );
		}
	}
	else
	{
		if ( isdefined( self.fx_widows_wine_wrap ) )
		{
			StopFX( localClientNum, self.fx_widows_wine_wrap );
			self.fx_widows_wine_wrap = undefined;
		}
	}
}
