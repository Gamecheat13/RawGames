#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

                                                                                       	                                
                                                                                                                               

#namespace zm_power;

function autoexec __init__sytem__() {     system::register("zm_power",&__init__,&__main__,undefined);    }

function __init__()
{
	level.powered_items = [];
	level.local_power = [];
}

function __main__()
{
	thread standard_powered_items();
	
	level thread electric_switch_init();
	
	/#
	thread debug_powered_items();
	#/	
}

/#
function debug_powered_items()
{
	while ( 1 )
	{
		if ( GetDvarInt( "zombie_equipment_health") )
		{
			if (isdefined(level.local_power))
			{
				foreach (localpower in level.local_power)
				{
					Circle( localpower.origin, localpower.radius, ( 1, 0, 0 ), false, true, 1 );
				}
			}
		}
		{wait(.05);};
	}
}
#/

function electric_switch_init()
{
	trigs = GetEntArray( "use_elec_switch", "targetname" );
	array::thread_all( trigs, &electric_switch, trigs );
}

function electric_switch( switch_array )
{
	
	if( !isdefined( self ) )
	{
		return;	
	}

	if( isdefined( self.target ) )
	{
		ent_parts = GetEntArray(self.target, "targetname");
		struct_parts = struct::get_array(self.target, "targetname");
		
		foreach(ent in ent_parts)
		{
			if(IsDefined(ent.script_noteworthy) && ent.script_noteworthy == "elec_switch")
			{
				master_switch = ent;	
				master_switch NotSolid();
			}
		}
		
		foreach(struct in struct_parts)
		{
			if(IsDefined(struct.script_noteworthy) && struct.script_noteworthy == "elec_switch_fx")
			{
				fx_pos = struct;
			}
		}
	}

	while ( IsDefined(self) )
	{
		// Power On
		//---------
		self SetHintString( &"ZOMBIE_ELECTRIC_SWITCH" );
	
		self SetVisibleToAll();
		self waittill( "trigger", user );
		self SetInvisibleToAll();
		
		if( isdefined( master_switch ) )
		{
			master_switch rotateroll( -90, .3 );
			master_switch playsound( "zmb_switch_flip" );
		}
		
		power_zone = undefined;
		if(isDefined(self.script_int))
		{
			power_zone = self.script_int;
		}
		level thread zm_perks::perk_unpause_all_perks( power_zone );
	
		if( isdefined( master_switch ) )
		{
			master_switch waittill( "rotatedone" );
			PlayFX( level._effect[ "switch_sparks" ] ,fx_pos.origin );
			master_switch playsound("zmb_turn_on");
		}
		
		level turn_power_on_and_open_doors( power_zone );
		
		//Exit loop if power can not be toggled on/off
		if( !isdefined( self.script_noteworthy ) || self.script_noteworthy != "allow_power_off" )
		{
			self delete();
			return;
		}
		
		// Power Off
		//----------		
		self SetHintString( &"ZOMBIE_ELECTRIC_SWITCH_OFF" );
		self SetVisibleToAll();
	
		self waittill( "trigger", user );
		self SetInvisibleToAll();
		
		if( isdefined( master_switch ) )
		{
			master_switch rotateroll( 90,.3 );
			master_switch playsound( "zmb_switch_flip" );
		}
		
		level thread zm_perks::perk_pause_all_perks( power_zone );
	
		if( isdefined( master_switch ) )
		{
			master_switch waittill( "rotatedone" );
		}
		
		level turn_power_off_and_close_doors( power_zone );
	}
}

function watch_global_power()
{
	while( true )
	{
		// Power On
		//---------
		level flag::wait_till("power_on");
		level thread set_global_power( true );

		// Power Off
		//---------
		level flag::wait_till_clear( "power_on" );
		level thread set_global_power( false );
	}
}

function standard_powered_items()
{
	level flag::wait_till( "start_zombie_round_logic" );

	// placeholder for all zombies
	//add_powered_item( &never_power_on, &zombie_power_off, &zombie_range, true, 1, undefined );

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		powered_on = zm_perks::get_perk_machine_start_state(trigger.script_noteworthy);
		powered_perk = add_powered_item( &perk_power_on, &perk_power_off, &perk_range, &cost_low_if_local, 0, powered_on, trigger );
		if(IsDefined(trigger.script_int))
		{
			powered_perk thread zone_controlled_perk(trigger.script_int);
		}	
	}
	
	// Electric Doors
	//---------------
	zombie_doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in zombie_doors )
	{
		if ( IsDefined( door.script_noteworthy ) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			add_powered_item( &door_power_on, &door_power_off, &door_range, &cost_door, 0, 0, door );
		}
		else if ( IsDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
		{
			power_sources = 0;
			if (!( isdefined( level.power_local_doors_globally ) && level.power_local_doors_globally ))
				power_sources = 1;
			add_powered_item( &door_local_power_on, &door_local_power_off, &door_range, &cost_door, power_sources, 0, door );
		}
	}

	thread watch_global_power();
}

function zone_controlled_perk(zone)
{
	while(true)
	{
		power_flag = ("power_on" + zone);
		// Power On
		//---------
		level flag::wait_till(power_flag);
		self thread perk_power_on();

		// Power Off
		//---------
		level flag::wait_till_clear(power_flag);
		self thread perk_power_off();
	}
}	

function add_powered_item( power_on_func, power_off_func, range_func, cost_func, power_sources, self_powered, target )
{
	powered = spawnstruct();
	powered.power_on_func = power_on_func;
	powered.power_off_func = power_off_func;
	powered.range_func = range_func;
	powered.power_sources = power_sources;
	powered.self_powered = self_powered;
	powered.target = target;
	powered.cost_func = cost_func;

	powered.power = self_powered;
	
	powered.powered_count = self_powered;
	powered.depowered_count = 0;

	level.powered_items[level.powered_items.size]=powered;
	return powered;
} 

function remove_powered_item( powered )
{
	 ArrayRemoveValue( level.powered_items, powered, false );	
}

//-----------------------------------------------------------------------------
// Transient powered items (turrets, traps)

function add_temp_powered_item( power_on_func, power_off_func, range_func, cost_func, power_sources, self_powered, target )
{
	powered = add_powered_item( power_on_func, power_off_func, range_func, cost_func, power_sources, self_powered, target );
	if (isdefined(level.local_power))
	{
		foreach (localpower in level.local_power)
		{
			if ( powered [[powered.range_func]]( 1, localpower.origin, localpower.radius ) )
			{
				powered change_power(1, localpower.origin, localpower.radius);
				if (!isdefined(localpower.added_list))
					localpower.added_list = [];
				localpower.added_list[localpower.added_list.size]=powered;
			}
		}
	}
	thread watch_temp_powered_item( powered );
	return powered;
}

function watch_temp_powered_item( powered )
{
	powered.target waittill("death");
	remove_powered_item( powered );
	if (isdefined(level.local_power))
	{
		foreach (localpower in level.local_power)
		{
			if (isdefined(localpower.added_list))
				 ArrayRemoveValue( localpower.added_list, powered, false );	
			if (isdefined(localpower.enabled_list))
				 ArrayRemoveValue( localpower.enabled_list, powered, false );	
		}
	}
}




//-----------------------------------------------------------------------------
// Area effects

function change_power_in_radius( delta, origin, radius )
{
	changed_list = [];
	for( i=0; i<level.powered_items.size; i++ )
	{
		powered = level.powered_items[i];		

		if ( powered.power_sources!=2 )
			if ( powered [[powered.range_func]]( delta, origin, radius ) )
			{
				powered change_power(delta, origin, radius);
				changed_list[changed_list.size]=powered;
			}
	}
	return changed_list;
}

function change_power( delta, origin, radius ) // self == powered item
{
	if (delta > 0)
	{
		if ( !self.power )
		{
			self.power=1;
			self [[self.power_on_func]](origin, radius);
		}
		self.powered_count++;
	}
	else if (delta < 0)
	{
		if ( self.power )
		{
			self.power=0;
			self [[self.power_off_func]](origin, radius);
		}
		self.depowered_count++;
	}
}

function revert_power_to_list( delta, origin, radius, powered_list )
{
	for( i=0; i<powered_list.size; i++ )
	{
		powered = powered_list[i];
		powered revert_power(delta, origin, radius);
	}
}

function revert_power( delta, origin, radius, powered_list ) // self == powered item
{
	if (delta > 0)
	{
		self.depowered_count--;
		assert( self.depowered_count >= 0, "Depower underflow in power system");
		if ( self.depowered_count == 0 && self.powered_count > 0 && !self.power )
		{
			self.power=1;
			self [[self.power_on_func]](origin, radius);
		}
	}
	else if (delta < 0)
	{
		self.powered_count--;
		assert( self.powered_count >= 0, "Repower underflow in power system");
		if ( self.powered_count == 0 && self.power  )
		{
			self.power=0;
			self [[self.power_off_func]](origin, radius);
		}
	}
}

//-----------------------------------------------------------------------------
// Local power

function add_local_power( origin, radius )
{
	localpower = spawnstruct();

	/#	println( "ZM POWER: local power on at "+origin+" radius "+radius+"\n" );	#/
	localpower.origin = origin;
	localpower.radius = radius;
	localpower.enabled_list = change_power_in_radius( 1, origin, radius );

	level.local_power[level.local_power.size]=localpower;
	return localpower;
}

function move_local_power( localpower, origin )
{
//	/#	println( "ZM POWER: local power moved to "+localpower.origin+" radius "+localpower.radius+"\n" );	#/
	changed_list = [];
	for( i=0; i<level.powered_items.size; i++ )
	{
		powered = level.powered_items[i];
		if ( powered.power_sources==2 )
			continue;
		waspowered = ( IsInArray( localpower.enabled_list, powered) );
		ispowered = powered [[powered.range_func]]( 1, origin, localpower.radius );
		if ( ispowered && !waspowered )
		{
			powered change_power( 1, origin, localpower.radius );
			localpower.enabled_list[localpower.enabled_list.size] = powered;
		}
		else if ( !ispowered && waspowered )
		{
			powered revert_power( -1, localpower.origin, localpower.radius, localpower.enabled_list );
			ArrayRemoveValue( localpower.enabled_list, powered, false );	
		}
	}
	localpower.origin = origin;
	return localpower;
}

function end_local_power( localpower )
{
	/#	println( "ZM POWER: local power off at "+localpower.origin+" radius "+localpower.radius+"\n" );	#/
	if (isdefined(localpower.enabled_list))
		revert_power_to_list( -1, localpower.origin, localpower.radius, localpower.enabled_list );
	localpower.enabled_list=undefined;
	if (isdefined(localpower.added_list))
		revert_power_to_list( -1, localpower.origin, localpower.radius, localpower.added_list );
	localpower.added_list=undefined;
	ArrayRemoveValue( level.local_power, localpower, false );	
}

function has_local_power( origin )
{
	if (isdefined(level.local_power))
	{
		foreach (localpower in level.local_power)
		{
			if ( DistanceSquared( localpower.origin, origin ) < localpower.radius * localpower.radius )
				return true;
		}
	}
	return false;
}

function get_powered_item_cost()
{
	if (!( isdefined( self.power ) && self.power ))
		return 0;
	
	if (( isdefined( level._power_global ) && level._power_global ) && !(self.power_sources==1))
		return 0;
	
	cost = [[self.cost_func]]();
	
	power_sources = self.powered_count;
	if (power_sources<1)
		power_sources=1;
	
	return cost/power_sources;
}
	
function get_local_power_cost( localpower )
{
	cost = 0;
	if ( isdefined(localpower) && isdefined(localpower.enabled_list))
	{
		foreach(powered in localpower.enabled_list)
			cost += powered get_powered_item_cost();
	}
	if ( isdefined(localpower) && isdefined(localpower.added_list))
	{
		foreach(powered in localpower.added_list)
			cost += powered get_powered_item_cost();
	}
	return cost;
}

//-----------------------------------------------------------------------------
// Global power (Power switch)

function set_global_power( on_off )
{
	demo::bookmark( "zm_power", gettime(), undefined, undefined, 1 );

	level._power_global = on_off;
	for( i=0; i<level.powered_items.size; i++ )
	{
		powered = level.powered_items[i];
		if ( isdefined(powered.target) && (powered.power_sources!=1) )
		{
			powered global_power(on_off);
			util::wait_network_frame();		// Network optimization
		}
	}
}

function global_power( on_off ) // self == powered item
{
	if (on_off)
	{
		/#	println( "ZM POWER: global power on\n" );	#/
		if ( !self.power )
		{
			self.power=1;
			self [[self.power_on_func]]();
		}
		self.powered_count++;
	}
	else
	{
		/#	println( "ZM POWER: global power off\n" );	#/
		self.powered_count--;
		assert( self.powered_count >= 0, "Repower underflow in power system");
		if ( self.powered_count == 0 && self.power  )
		{
			self.power=0;
			self [[self.power_off_func]]();
		}
	}
}


//=============================================================================
// Generic

function never_power_on( origin, radius )
{
}
function never_power_off( origin, radius )
{
}

function cost_negligible()
{
	if (isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost=undefined;
		return cost;
	}
	return 0;
}

function cost_low_if_local()
{
	if (isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost=undefined;
		return cost;
	}
	if (( isdefined( level._power_global ) && level._power_global ))
		return 0;
	if (( isdefined( self.self_powered ) && self.self_powered ))
		return 0;
	return 1;
}

function cost_high()
{
	if (isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost=undefined;
		return cost;
	}
	return 10;
}


//=============================================================================
// Doors

function door_range( delta, origin, radius )
{
	if ( delta < 0 )
		return false;
	if ( DistanceSquared( self.target.origin, origin ) < ( radius * radius ) )
	{
		return true;
	}
	return false;
}
function door_power_on( origin, radius )
{
	/#	println( "^1ZM POWER: door on\n" );	#/
	self.target.power_on=1;
	self.target notify( "power_on" );
	//self.one_time_cost=200;
}
function door_power_off( origin, radius )
{
	/#	println( "^1ZM POWER: door off\n" );	#/
	self.target notify( "power_off" );
	self.target.power_on=0;
}
function door_local_power_on( origin, radius )
{
	/#	println( "^1ZM POWER: door on (local)\n" );	#/
	self.target.local_power_on=1;
	self.target notify( "local_power_on" );
	//self.one_time_cost=200;
}
function door_local_power_off( origin, radius )
{
	/#	println( "^1ZM POWER: door off (local)\n" );	#/
	self.target notify( "local_power_off" );
	self.target.local_power_on=0;
}

function cost_door()
{
	// pull in the cost set on the door itself - this keeps the door from costing power when it hasn't closed. 
	if (isdefined(self.target.power_cost ) )
	{
		if (!isdefined(self.one_time_cost))
			self.one_time_cost=0;
		self.one_time_cost += self.target.power_cost;
		self.target.power_cost=0;
	}
	if (isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost=undefined;
		return cost;
	}
	return 0;
}


//=============================================================================
// Zombies


function zombie_range( delta, origin, radius )
{
	if ( delta > 0 )
		return false;
	self.zombies = array::get_all_closest( origin, zombie_utility::get_round_enemy_array(), undefined, undefined, radius );
	if ( !isDefined( self.zombies ) )
	{
		return false;
	}
	self.power = 1;
	return true;
}
function zombie_power_off( origin, radius )
{
	/#	println( "^1ZM POWER: zombies off\n" );	#/
	for (i=0; i<self.zombies.size; i++)
	{
		self.zombies[i] thread stun_zombie();		
		{wait(.05);};
	}
}
function stun_zombie()
{
	self endon("death");
	self notify( "stun_zombie" );
	self endon( "stun_zombie" );

	if ( self.health <= 0 )
	{
		/#
			iprintln( "trying to stun a dead zombie" );
		#/
		return;
	}

	if ( ( isdefined( self.ignore_inert ) && self.ignore_inert ) )
	{
		return;
	}

	if ( isdefined( self.stun_zombie ) )
	{
		self thread [[ self.stun_zombie ]]();
		return;
	}

}


//=============================================================================
// Perk machines


function perk_range( delta, origin, radius )
{
	if (IsDefined(self.target))
	{
		perkorigin = self.target.origin; 
		if( ( isdefined( self.target.trigger_off ) && self.target.trigger_off ) )
			perkorigin = self.target.realorigin;
		else if( ( isdefined( self.target.disabled ) && self.target.disabled ) )
			perkorigin = perkorigin + ( 0, 0, 10000 );
		if ( DistanceSquared( perkorigin, origin ) < radius * radius )
			return true;
	}
	return false;
}
function perk_power_on( origin, radius )
{
	/#	println( "^1ZM POWER: perk " + self.target zm_perks::getVendingMachineNotify() + " on\n" );	#/
	level notify( self.target zm_perks::getVendingMachineNotify() + "_on" );
	zm_perks::perk_unpause(self.target.script_noteworthy);
	
}
function perk_power_off( origin, radius )
{
	notify_name = self.target zm_perks::getVendingMachineNotify();
	if(isDefined(notify_name) && notify_name == "revive")
	{
		if(level flag::exists("solo_game") && level flag::get("solo_game"))
		{
			return;
		}
	}
	
	/#	println( "^1ZM POWER: perk " + self.target.script_noteworthy + " off\n" );	#/
	self.target notify( "death" );
	self.target thread zm_perks::vending_trigger_think();
	if ( IsDefined( self.target.perk_hum ) )
	{
		self.target.perk_hum Delete();
	}

	zm_perks::perk_pause(self.target.script_noteworthy);

	level notify( self.target zm_perks::getVendingMachineNotify() + "_off" );
}

function turn_power_on_and_open_doors( power_zone )
{
	level.local_doors_stay_open = true;
	level.power_local_doors_globally = 1;

	if(!IsDefined( power_zone ))
	{
		level flag::set("power_on");
		level clientfield::set("zombie_power_on", 0);
	}
	else
	{
		level flag::set( "power_on" + power_zone);
		level clientfield::set("zombie_power_on", power_zone);
	}
	
	zombie_doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in zombie_doors )
	{
		if(!IsDefined(door.script_noteworthy))
			continue;
			
		if (!IsDefined( power_zone) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify( "power_on" );
		}		
		else if((IsDefined(door.script_int) && door.script_int == power_zone) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify( "power_on" );
		}
		else if ( isdefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
		{
			door notify( "local_power_on" );
		}
	}
}

function turn_power_off_and_close_doors( power_zone )
{
	level.local_doors_stay_open = false;
	level.power_local_doors_globally = false;

	if(!IsDefined( power_zone ))
	{
		level flag::clear( "power_on" );
		level clientfield::set("zombie_power_off", 0);
	}
	else
	{
		level flag::clear( "power_on" + power_zone);
		level clientfield::set("zombie_power_off", power_zone);
	}


	zombie_doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in zombie_doors )
	{
		if(!IsDefined(door.script_noteworthy))
			continue;
			
		if (!IsDefined( power_zone) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify( "power_on" );
		}		
		else if((IsDefined(door.script_int) && door.script_int == power_zone) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify( "power_on" );
		}
		else if ( isdefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
		{
			door notify( "local_power_on" );
		}
	}
}

