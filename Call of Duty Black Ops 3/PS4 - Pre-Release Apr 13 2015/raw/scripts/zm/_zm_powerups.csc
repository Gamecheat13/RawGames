#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                

// Client side powerups functionality

#precache( "client_fx", "zombie/fx_powerup_on_green_zmb" );
#precache( "client_fx", "zombie/fx_powerup_on_red_zmb" );
#precache( "client_fx", "zombie/fx_powerup_on_solo_zmb" );
#precache( "client_fx", "zombie/fx_powerup_on_caution_zmb" );

#namespace zm_powerups;

function init()
{
	//Powerups:

	//Random Drops
	add_zombie_powerup( "insta_kill_ug",		"powerup_instant_kill_ug", 1 );

	level thread set_clientfield_code_callbacks();

	level._effect["powerup_on"] 					= "zombie/fx_powerup_on_green_zmb";
	if (( isdefined( level.using_zombie_powerups ) && level.using_zombie_powerups ))
	{
		level._effect["powerup_on_red"] 				= "zombie/fx_powerup_on_red_zmb";
	}
	level._effect["powerup_on_solo"]				= "zombie/fx_powerup_on_solo_zmb";
	level._effect["powerup_on_caution"]				= "zombie/fx_powerup_on_caution_zmb";

	clientfield::register( "scriptmover", "powerup_fx", 1, 3, "int",&powerup_fx_callback, !true, !true );
}

function add_zombie_powerup( powerup_name, client_field_name, clientfield_version = 1 )
{
	if( isdefined( level.zombie_include_powerups ) && !isdefined( level.zombie_include_powerups[powerup_name] ) )
	{
		return;
	}

	struct = SpawnStruct();

	if( !isdefined( level.zombie_powerups ) )
	{
		level.zombie_powerups = [];
	}
	
	struct.powerup_name = powerup_name;

	level.zombie_powerups[powerup_name] = struct;

	if( isdefined( client_field_name ) )
	{
		clientfield::register( "toplayer", client_field_name, clientfield_version, 2, "int", undefined, !true, true );
		struct.client_field_name = client_field_name;
	}
}

function set_clientfield_code_callbacks()
{
	wait(0.1);        // This won't run - until after all the client field registration has finished.

	powerup_keys = GetArrayKeys( level.zombie_powerups );
	powerup_clientfield_name = undefined;
	for ( powerup_key_index = 0; powerup_key_index < powerup_keys.size; powerup_key_index++ )
	{
		powerup_clientfield_name = level.zombie_powerups[powerup_keys[powerup_key_index]].client_field_name;
		if ( isdefined( powerup_clientfield_name ) )
		{
			SetupClientFieldCodeCallbacks( "toplayer", 1, powerup_clientfield_name );
		}
	}
}

function include_zombie_powerup( powerup_name )
{
	if( !isdefined( level.zombie_include_powerups ) )
	{
		level.zombie_include_powerups = [];
	}

	level.zombie_include_powerups[powerup_name] = true;
}

function powerup_fx_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	switch ( newVal )
	{
	case 1:
		fx = level._effect["powerup_on"];
		break;
	case 2:
		fx = level._effect["powerup_on_solo"];
		break;
	case 3:
		fx = level._effect["powerup_on_red"];
		break;
	case 4:
		fx = level._effect["powerup_on_caution"];
		break;		
	default:
		// do nothing
		return;
	}

	if (!isdefined(fx))
		return;
	PlayFXOnTag( localClientNum, fx, self, "tag_origin" );
}
