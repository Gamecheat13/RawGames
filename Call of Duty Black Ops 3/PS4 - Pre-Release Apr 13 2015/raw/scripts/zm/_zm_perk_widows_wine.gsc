#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

                                                                                       	                                
                                                                                                                               
                                            	       

//TODO update these to proper settings










	// Radius up to which enemies will be immobilized
	// WIDOWS_WINE_COCOON_RADIUS^2
	// Fraction of normal speed to animate when Cocooned (TEMP - should play immobile anim)
	// Duration of Cocoon
	
	// Radius up to which enemies will be slowed
	// WIDOWS_WINE_SLOW_RADIUS^2
	// Fraction of normal speed to animate when Slowed
	// Duration of Slow

#precache( "material", "specialty_widows_wine_zombies" );
#precache( "string", "ZOMBIE_PERK_WIDOWS_WINE" );
#precache( "fx", "_t6/misc/fx_zombie_cola_revive_on" );
#precache( "fx", "zombie/fx_widows_wrap_torso_zmb" );


#namespace zm_perk_widows_wine;

function autoexec __init__sytem__() {     system::register("zm_perk_widows_wine",&__init__,undefined,undefined);    }

//	WIDOWS WINE

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	enable_widows_wine_perk_for_level();
}

function enable_widows_wine_perk_for_level()
{	
	// register widows wine perk for level
	zm_perks::register_perk_basic_info( "specialty_widowswine", "widows_wine", 2000, &"ZOMBIE_PERK_WIDOWSWINE", GetWeapon( "zombie_perk_bottle_revive" ) );
	zm_perks::register_perk_precache_func( "specialty_widowswine", &widows_wine_precache );
	zm_perks::register_perk_clientfields( "specialty_widowswine", &widows_wine_register_clientfield, &widows_wine_set_clientfield );
	zm_perks::register_perk_machine( "specialty_widowswine", &widows_wine_perk_machine_setup );
	zm_perks::register_perk_host_migration_params( "specialty_widowswine", "vending_widowswine", "widow_light" );
	
	zm_perks::register_perk_threads( "specialty_widowswine", &widows_wine_perk_activate, &widows_wine_perk_lost );
	
	if( ( isdefined( level.custom_widows_wine_perk_threads ) && level.custom_widows_wine_perk_threads ) )
	{
		level thread [[ level.custom_widows_wine_perk_threads ]]();
	}

	init_widows_wine();
}

function widows_wine_precache()
{
	if( isdefined(level.widows_wine_precache_override_func) )
	{
		[[ level.widows_wine_precache_override_func ]]();
		return;
	}
	
	level._effect[ "widow_light" ]	= "_t6/misc/fx_zombie_cola_revive_on";
	level._effect[ "widows_wine_wrap" ]			= "zombie/fx_widows_wrap_torso_zmb";
		
	level.machine_assets["specialty_widowswine"] = SpawnStruct();
	level.machine_assets["specialty_widowswine"].weapon = GetWeapon( "zombie_perk_bottle_revive" );
	level.machine_assets["specialty_widowswine"].off_model = "p7_zm_vending_widows_wine";
	level.machine_assets["specialty_widowswine"].on_model = "p7_zm_vending_widows_wine";
}

function widows_wine_register_clientfield()
{
	clientfield::register( "toplayer", "perk_widows_wine", 1, 2, "int" );

	clientfield::register( "actor", "widows_wine_wrapping", 1, 1, "int" );
}

function widows_wine_set_clientfield( state )
{
	self clientfield::set_to_player( "perk_widows_wine", state );
}

function widows_wine_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound	= "mus_perks_stamin_jingle";
	use_trigger.script_string	= "widowswine_perk";
	use_trigger.script_label	= "mus_perks_stamin_sting";
	use_trigger.target			= "vending_widowswine";
	perk_machine.script_string	= "widowswine_perk";
	perk_machine.targetname		= "vending_widowswine";
	
	if( isdefined( bump_trigger ) )
	{
		bump_trigger.script_string = "widowswine_perk";
	}
}

//-----------------------------------------------------------------------------------
// functionality
//-----------------------------------------------------------------------------------
function init_widows_wine()
{	
	zm_utility::register_lethal_grenade_for_level( "sticky_grenade_widows_wine" );
	zm_spawner::register_zombie_damage_callback( &widows_wine_zombie_damage_response );
	
	level.w_widows_wine_grenade = GetWeapon( "sticky_grenade_widows_wine" );
}

function widows_wine_perk_machine_think()
{	
	init_widows_wine();

	while ( true )
	{
		machine = getentarray( "vending_widowswine", "targetname" );
		machine_triggers = GetEntArray( "vending_widowswine", "target" );
		
		// Show "inactive" models
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel( "p7_zm_vending_widows_wine" );
		}
		
		level thread zm_perks::do_initial_power_off_callback( machine, "widows_wine" );
		array::thread_all( machine_triggers, &zm_perks::set_power_on, false );

		level waittill( "widows_wine_on" );
	
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel( "p7_zm_vending_widows_wine" );
			machine[i] vibrate( ( 0, -100, 0 ), 0.3, 0.4, 3 );
			machine[i] playsound( "zmb_perks_power_on" );
			machine[i] thread zm_perks::perk_fx( "widows_wine" );
			machine[i] thread zm_perks::play_loop_on_machine();
		}
		
		level notify( "specialty_widowswine" + "_power_on" );
		
		array::thread_all( machine_triggers, &zm_perks::set_power_on, true );

		level waittill( "widows_wine_off" );
			
		array::thread_all( machine_triggers, &zm_perks::turn_perk_off );
	}
}

// when host migration occurs, fx don't carry over. If perk machine is on, turn the light back on.
function widows_wine_host_migration_func()
{
	a_widows_wine_perk_machines = GetEntArray( "vending_widowswine", "targetname" );
	
	foreach( perk_machine in a_widows_wine_perk_machines )
	{
		if( isdefined( perk_machine.model ) && perk_machine.model == "p7_zm_vending_widows_wine" )
		{
			perk_machine zm_perks::perk_fx( undefined, true );
			perk_machine thread zm_perks::perk_fx( "widows_wine" );
		}
	}
}


//--------------------------------------------------------------------------
//	Functionality
//--------------------------------------------------------------------------


//	self is a player with widow's wine perk
function widows_wine_perk_activate()
{
	// replace your grenades with widows_wine grenades
	self.w_widows_wine_prev_grenade = self zm_utility::get_player_lethal_grenade();
	self TakeWeapon( self.w_widows_wine_prev_grenade );

	// Give the widow's wine grenade and wait for them to be thrown
	self GiveWeapon( level.w_widows_wine_grenade );
	self zm_utility::set_player_lethal_grenade( level.w_widows_wine_grenade );
}
	

// self is a zombie
function widows_wine_zombie_damage_response( str_mod, str_hit_location, v_hit_origin, e_player, n_amount, w_weapon )
{
	if ( isdefined( self.damageweapon ) && self.damageweapon == level.w_widows_wine_grenade )
	{
		n_dist_sq = DistanceSquared( self.origin, v_hit_origin );

		// Nearby zombies are cocooned
		if ( n_dist_sq <= 10000 )
		{
			self thread widows_wine_cocoon_zombie();
		}
		// Further away is merely slow
		else
		{
			self thread widows_wine_slow_zombie();
		}
		return true;
	}

	return false;
}


//	zombie is immobilized by web
// self is a zombie
function widows_wine_cocoon_zombie()
{
	// Multiple calls from subsequent grenades should extend the effect
	self notify( "widows_wine_cocoon" );
	
	self endon( "widows_wine_cocoon" );
	
	if ( !( isdefined( self.b_widows_wine_cocoon ) && self.b_widows_wine_cocoon ) )
	{
		self.b_widows_wine_cocoon = true;
		self ASMSetAnimationRate( 0.1 );

		self clientfield::set( "widows_wine_wrapping", 1 );	// turn on wrap FX
	}
	
	self util::waittill_any_timeout( 10.0, "death" );

	if ( IsAlive( self ) )
	{
		self ASMSetAnimationRate( 1.0 );
		self clientfield::set( "widows_wine_wrapping", 0 );	// turn off wrap FX
		self.b_widows_wine_cocoon = false;
	}
}


//	zombie is slowed by webbing
// self is a zombie
function widows_wine_slow_zombie()
{
	// Multiple calls from subsequent grenades should extend the effect
	self notify( "widows_wine_slow" );
	
	self endon( "widows_wine_slow" );
	
	if ( ( isdefined( self.b_widows_wine_cocooned ) && self.b_widows_wine_cocooned ) )
	{
		// Should just increase cocoon time
		self thread widows_wine_cocoon_zombie();
		return;
	}

	if ( !( isdefined( self.b_widows_wine_slow ) && self.b_widows_wine_slow ) )
	{
		self.b_widows_wine_slow = true;
		self ASMSetAnimationRate( 0.7 );
		self clientfield::set( "widows_wine_wrapping", 1 );	// turn on wrap FX
	}
	self util::waittill_any_timeout( 6.0, "death" );

	self ASMSetAnimationRate( 1.0 );
	self clientfield::set( "widows_wine_wrapping", 0 );	// turn off wrap FX
	self.b_widows_wine_slow = false;
}


//////////////////////////////////////////////////////////////
//Perk lost func
//////////////////////////////////////////////////////////////
function widows_wine_perk_lost( b_pause, str_perk, str_result )
{
	self notify( "stop_widows_wine" );

	self TakeWeapon( level.w_widows_wine_grenade );
	if ( isdefined( self.w_widows_wine_prev_grenade ) )
	{
		self GiveWeapon( self.w_widows_wine_prev_grenade );
		self zm_utility::set_player_lethal_grenade( self.w_widows_wine_prev_grenade );
	}
}

