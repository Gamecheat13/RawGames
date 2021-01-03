#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

                                            
                                                                                       	                                
                                                                                                                               









#precache( "material", "specialty_doubletap_zombies" );
#precache( "string", "ZOMBIE_PERK_DOUBLETAP" );
#precache( "fx", "zombie/fx_perk_doubletap2_zmb" );

#namespace zm_perk_doubletap2;

function autoexec __init__sytem__() {     system::register("zm_perk_doubletap2",&__init__,undefined,undefined);    }

// DOUBLETAP2 ( DOUBLE TAP II )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	enable_doubletap2_perk_for_level();
}

function enable_doubletap2_perk_for_level()
{	
	// register sleight of hand perk for level
	zm_perks::register_perk_basic_info( "specialty_doubletap2", "doubletap", 2000, &"ZOMBIE_PERK_DOUBLETAP", GetWeapon( "zombie_perk_bottle_doubletap" ) );
	zm_perks::register_perk_precache_func( "specialty_doubletap2", &doubletap2_precache );
	zm_perks::register_perk_clientfields( "specialty_doubletap2", &doubletap2_register_clientfield, &doubletap2_set_clientfield );
	zm_perks::register_perk_machine( "specialty_doubletap2", &doubletap2_perk_machine_setup );
	zm_perks::register_perk_host_migration_params( "specialty_doubletap2", "vending_doubletap", "doubletap2_light" );
}

function doubletap2_precache()
{
	if( IsDefined(level.doubletap2_precache_override_func) )
	{
		[[ level.doubletap2_precache_override_func ]]();
		return;
	}
	
	level._effect["doubletap2_light"] = "zombie/fx_perk_doubletap2_zmb";
	
	level.machine_assets["specialty_doubletap2"] = SpawnStruct();
	level.machine_assets["specialty_doubletap2"].weapon = GetWeapon( "zombie_perk_bottle_doubletap" );
	level.machine_assets["specialty_doubletap2"].off_model = "p7_zm_vending_doubletap2";
	level.machine_assets["specialty_doubletap2"].on_model = "p7_zm_vending_doubletap2";
}

function doubletap2_register_clientfield()
{
	clientfield::register( "toplayer", "perk_doubletap2", 1, 2, "int" );
}

function doubletap2_set_clientfield( state )
{
	self clientfield::set_to_player( "perk_doubletap2", state );
}

function doubletap2_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_doubletap_jingle";
	use_trigger.script_string = "tap_perk";
	use_trigger.script_label = "mus_perks_doubletap_sting";
	use_trigger.target = "vending_doubletap";
	perk_machine.script_string = "tap_perk";
	perk_machine.targetname = "vending_doubletap";
	if( IsDefined( bump_trigger ) )
	{
		bump_trigger.script_string = "tap_perk";
	}
}
