    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                 
                                                                                                                                                                                                                         

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm_bgb_machine;

#precache( "client_fx", "zombie/fx_bgb_bubble_blow_zmb" );

#namespace bgb;

function autoexec __init__sytem__() {     system::register("bgb",&__init__,&__main__,undefined);    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level.weaponBGBGrab = GetWeapon( "zombie_bgb_grab" );
	
	callback::on_localclient_connect( &on_player_connect );

	level.bgb = []; // array for actual buffs
	level.bgb_pack = [];

	clientfield::register( "clientuimodel", "bgb_current", 1, 8, "int", &bgb_store_current, !true, !true );
	clientfield::register( "clientuimodel", "bgb_display", 1, 1, "int", undefined, !true, !true );
	clientfield::register( "clientuimodel", "bgb_timer", 1, 8, "float", undefined, !true, !true );
	clientfield::register( "clientuimodel", "bgb_activations_remaining", 1, 3, "int", undefined, !true, !true );
	clientfield::register( "clientuimodel", "bgb_invalid_use", 1, 1, "counter", undefined, !true, !true );
	clientfield::register( "clientuimodel", "bgb_one_shot_use", 1, 1, "counter", undefined, !true, !true );

	clientfield::register( "toplayer", "bgb_blow_bubble", 1, 1, "counter", &bgb_blow_bubble, !true, !true );

	level._effect["zm_bgb_blow_bubble"] = "zombie/fx_bgb_bubble_blow_zmb";
}

function private __main__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb_finalize();
}

function private on_player_connect( localClientNum )
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	self thread bgb_player_init( localClientNum );
}

function private bgb_player_init( localClientNum )
{
	if ( IsDefined( level.bgb_pack[localClientNum] ) )
	{
		return;
	}

	level.bgb_pack[localClientNum] = GetBubblegumPack( localClientNum );
}

function private bgb_finalize()
{
	level.bgb_consumable_names = [];
	level.bgb_consumable_names[level.bgb_consumable_names.size] = "base";
	level.bgb_consumable_names[level.bgb_consumable_names.size] = "speckled";
	level.bgb_consumable_names[level.bgb_consumable_names.size] = "shiny";
	level.bgb_consumable_names[level.bgb_consumable_names.size] = "swirl";

	statsTableName = util::getStatsTableName();
	
	level.bgb_item_index_to_name = [];

	keys = GetArrayKeys( level.bgb );
	for ( i = 0; i < keys.size; i++ )
	{
		level.bgb[keys[i]].item_index = GetItemIndexFromRef( keys[i] );

		level.bgb[keys[i]].consumable = Int( tableLookup( statsTableName, 0, level.bgb[keys[i]].item_index, 16 ) );

		level.bgb[keys[i]].camo_index = Int( tableLookup( statsTableName, 0, level.bgb[keys[i]].item_index, 5 ) );

		level.bgb[keys[i]].flying_gumball_tag = "tag_gumball_" + level.bgb[keys[i]].limit_type;
		level.bgb[keys[i]].give_gumball_tag = "tag_gumball_" + level.bgb[keys[i]].limit_type + "_" + level.bgb_consumable_names[level.bgb[keys[i]].consumable];

		level.bgb_item_index_to_name[level.bgb[keys[i]].item_index] = keys[i];
	}
}

/@
"Name: register( <name>, <limit_type> )"
"Summary: Register a BGB
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB.
"MandatoryArg: <limit_type> One of the BGB_LIMIT_TYPE_*'s.
"Example: level bgb::register( "zm_bgb_respin_cycle", BGB_LIMIT_TYPE_ACTIVATED );"
"SPMP: both"
@/
function register( name, limit_type )
{
	assert( IsDefined( name ), "bgb::register(): name must be defined" );
	assert( "none" != name, "bgb::register(): name cannot be '" + "none" + "', that name is reserved as an internal sentinel value" );
	assert( !IsDefined( level.bgb[name] ), "bgb::register(): BGB '" + name + "' has already been registered" );

	assert( IsDefined( limit_type ), "bgb::register(): BGB '" + name + "': limit_type must be defined" );

	level.bgb[name] = SpawnStruct();

	level.bgb[name].name = name;
	level.bgb[name].limit_type = limit_type;
}

function private bgb_store_current( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self.bgb = level.bgb_item_index_to_name[newVal];
}

function private bgb_play_fx_on_camera( localClientNum, fx )
{
	if ( IsDefined( self.bgb_bubble_blow_fx ) )
	{
		DeleteFX( localClientNum, self.bgb_bubble_blow_fx, true );
	}

	if ( IsDefined( fx ) )
	{
		self.bgb_bubble_blow_fx = PlayFXOnCamera( localclientnum, fx );
	}
}

function private bgb_blow_bubble( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	bgb_play_fx_on_camera( localClientNum, level._effect["zm_bgb_blow_bubble"] );
}
