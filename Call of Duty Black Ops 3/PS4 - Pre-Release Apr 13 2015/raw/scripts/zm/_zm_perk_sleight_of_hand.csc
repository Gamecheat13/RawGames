#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_perks;

                                                                                       	                                
                                                                                                                               



#precache( "client_fx", "zombie/fx_perk_sleight_of_hand_zmb" );

#namespace zm_perk_sleight_of_hand;

function autoexec __init__sytem__() {     system::register("zm_perk_sleight_of_hand",&__init__,undefined,undefined);    }

// SLEIGHT OF HAND PERK ( SPEED COLA )
	
function __init__()
{
	enable_sleight_of_hand_perk_for_level();
}

function enable_sleight_of_hand_perk_for_level()
{
	// register custom functions for hud/lua
	zm_perks::register_perk_clientfields( "specialty_fastreload", &sleight_of_hand_client_field_func, &sleight_of_hand_code_callback_func );
	zm_perks::register_perk_effects( "specialty_fastreload", "sleight_light" );
	zm_perks::register_perk_init_thread( "specialty_fastreload", &init_sleight_of_hand );
}

function init_sleight_of_hand()
{
	if( ( isdefined( level.enable_magic ) && level.enable_magic ) )
	{
		level._effect["sleight_light"]	= "zombie/fx_perk_sleight_of_hand_zmb";
	}	
}

function sleight_of_hand_client_field_func()
{
	clientfield::register( "toplayer", "perk_sleight_of_hand", 1, 2, "int", undefined, !true, true );
}

function sleight_of_hand_code_callback_func()
{
	SetupClientFieldCodeCallbacks( "toplayer", 1, "perk_sleight_of_hand" );
}
