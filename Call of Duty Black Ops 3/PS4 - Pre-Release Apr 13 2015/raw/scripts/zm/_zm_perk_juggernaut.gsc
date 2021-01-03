#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

                                                                                       	                                
                                                                                                                               









#precache( "material", "specialty_juggernaut_zombies" );
#precache( "string", "ZOMBIE_PERK_JUGGERNAUT" );
#precache( "fx", "zombie/fx_perk_juggernaut_zmb" );

#namespace zm_perk_juggernaut;

function autoexec __init__sytem__() {     system::register("zm_perk_juggernaut",&__init__,undefined,undefined);    }

// JUGGERNAUT

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	enable_juggernaut_perk_for_level();
}

function enable_juggernaut_perk_for_level()
{	
	// register juggernaut perk for level
	zm_perks::register_perk_basic_info( "specialty_armorvest", "juggernog", 2500, &"ZOMBIE_PERK_JUGGERNAUT", GetWeapon( "zombie_perk_bottle_jugg" ) );
	zm_perks::register_perk_precache_func( "specialty_armorvest", &juggernaut_precache );
	zm_perks::register_perk_clientfields( "specialty_armorvest", &juggernaut_register_clientfield, &juggernaut_set_clientfield );
	zm_perks::register_perk_machine( "specialty_armorvest", &juggernaut_perk_machine_setup, &init_juggernaut );
	zm_perks::register_perk_threads( "specialty_armorvest", &give_juggernaut_perk, &take_juggernaut_perk );
	zm_perks::register_perk_host_migration_params( "specialty_armorvest", "vending_jugg", "jugger_light" );
}	
	
function init_juggernaut()
{	
	// tweakable variables
	zombie_utility::set_zombie_var( "zombie_perk_juggernaut_health",	250 );
	zombie_utility::set_zombie_var( "zombie_perk_juggernaut_health_upgrade",	250 );		
}

function juggernaut_precache()
{
	if( IsDefined(level.juggernaut_precache_override_func) )
	{
		[[ level.juggernaut_precache_override_func ]]();
		return;
	}
	
	level._effect["jugger_light"] = "zombie/fx_perk_juggernaut_zmb";
	
	level.machine_assets["specialty_armorvest"] = SpawnStruct();
	level.machine_assets["specialty_armorvest"].weapon = GetWeapon( "zombie_perk_bottle_jugg" );
	level.machine_assets["specialty_armorvest"].off_model = "p7_zm_vending_jugg";
	level.machine_assets["specialty_armorvest"].on_model = "p7_zm_vending_jugg";
}

function juggernaut_register_clientfield()
{
	clientfield::register( "toplayer", "perk_juggernaut", 1, 2, "int" );
}

function juggernaut_set_clientfield( state )
{
	self clientfield::set_to_player( "perk_juggernaut", state );
}

function juggernaut_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_jugganog_jingle";
	use_trigger.script_string = "jugg_perk";
	use_trigger.script_label = "mus_perks_jugganog_sting";
	use_trigger.longJingleWait = true;
	use_trigger.target = "vending_jugg";
	perk_machine.script_string = "jugg_perk";
	perk_machine.targetname = "vending_jugg";
	if( IsDefined( bump_trigger ) )
	{
		bump_trigger.script_string = "jugg_perk";
	}
}

function give_juggernaut_perk()
{
	// Increment player max health if its the jugg perk
	self zm_perks::perk_set_max_health_if_jugg( "specialty_armorvest", true, false );
}

function take_juggernaut_perk( b_pause, str_perk, str_result )
{
	self SetMaxHealth( self.preMaxHealth );
	if (self.health > self.maxhealth)
	{
		self.health = self.maxhealth;
	}
}
