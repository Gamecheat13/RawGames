#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#using_animtree( "vehicles" );

init()
{
	
	setdvar( "scr_veh_cleanupdebugprint", "0" );
	
	// We can control whether vehicle occupants can take damage (such as from bullets)
	setdvar( "scr_veh_driversarehidden", "1" );
	setdvar( "scr_veh_driversareinvulnerable", "1" );
	
	// "cleanuptime" must pass before veh is considered for cleanup (either by abandonment or drift)
	// these are given in seconds
	setdvar( "scr_veh_alive_cleanuptimemin", "119" );
	setdvar( "scr_veh_alive_cleanuptimemax", "120" );
	setdvar( "scr_veh_dead_cleanuptimemin", "20" );
	setdvar( "scr_veh_dead_cleanuptimemax", "30" );
	
	// These cleanuptime factors only modify cleanup due to abandonment or drift,
	// i.e. the cleanup of an alive vehicle.  Once the vehicle dies and becomes a
	// husk, only the cleanuptimemin and cleanuptimemax values apply.
	setdvar( "scr_veh_cleanuptime_dmgfactor_min", "0.33" );
	setdvar( "scr_veh_cleanuptime_dmgfactor_max", "1.0" );
	setdvar( "scr_veh_cleanuptime_dmgfactor_deadtread", "0.25" ); // decrease the damage factor ( which scales wait time ) by this much for each tread that has been completely destroyed
	setdvar( "scr_veh_cleanuptime_dmgfraction_curve_begin", "0.0" ); // this is the amount of damage at which the damage factor affecting wait time will be at max
	setdvar( "scr_veh_cleanuptime_dmgfraction_curve_end", "1.0" ); // this is the amount of damage at which the damage factor affecting wait time will be at min
	
	setdvar( "scr_veh_cleanupabandoned", "1" ); // Decide whether to cleanup abandoned vehicles
	setdvar( "scr_veh_cleanupdrifted", "1" ); // Decide whether to cleanup drifted vehicles
	setdvar( "scr_veh_cleanupmaxspeedmph", "1" ); // If it's going slower than this, then the vehicle can be cleaned up
	setdvar( "scr_veh_cleanupmindistancefeet", "75" ); // If it's at least this far from its original position, then the vehicle can be cleaned up
	setdvar( "scr_veh_waittillstoppedandmindist_maxtime", "10" );
	setdvar( "scr_veh_waittillstoppedandmindist_maxtimeenabledistfeet", "5" );
	
	// Respawn time is the wait between cleaning up an old vehicle
	// and spawning a new replacement vehicle.
	// these are given in seconds
	setdvar( "scr_veh_respawnafterhuskcleanup", "1" ); // if true, vehicle respawn kicks off after husk cleanup.  otherwise, kicks off after live vehicle is killed
	setdvar( "scr_veh_respawntimemin", "50" );
	setdvar( "scr_veh_respawntimemax", "90" );
	setdvar( "scr_veh_respawnwait_maxiterations", "30" );
	setdvar( "scr_veh_respawnwait_iterationwaitseconds", "1" );
	
	// Explodes when killed or when dvar scr_veh_explode_on_cleanup is not zero
	setdvar( "scr_veh_explosion_spawnfx", "1" ); // Whether or not to create an explosion FX when the vehicle is destroyed
	setdvar( "scr_veh_explosion_doradiusdamage", "1" ); // whether or not to hurt nearby entities when the vehicle is destroyed
	setdvar( "scr_veh_explosion_radius", "256" );
	setdvar( "scr_veh_explosion_mindamage", "20" );
	setdvar( "scr_veh_explosion_maxdamage", "200" );
	

	setdvar( "scr_veh_ondeath_createhusk", "1" ); // Whether or not to init a burnt-out husk for players to use as cover when the vehicle is destroyed
	setdvar( "scr_veh_ondeath_usevehicleashusk", "1" ); // if true, husks will be the vehicle entities themselves.  otherwise, husk will be a Spawn("script_model")	
	setdvar( "scr_veh_explosion_husk_forcepointvariance", "30" ); // controls the "spin" when the vehicle husk is launched
	setdvar( "scr_veh_explosion_husk_horzvelocityvariance", "25" );
	setdvar( "scr_veh_explosion_husk_vertvelocitymin", "100" );
	setdvar( "scr_veh_explosion_husk_vertvelocitymax", "200" );
	
	
	setdvar( "scr_veh_explode_on_cleanup", "1" ); ///< if not "exploding", then "disappearing".  this only affect auto-cleanup case, not when vehicle is destroyed.  destroyed vehicle always explodes
	setdvar( "scr_veh_disappear_maxwaittime", "60" ); ///< # seconds at which test for "player too close" and "player can see" will timeout and the husk will be cleaned up anyway
	setdvar( "scr_veh_disappear_maxpreventdistancefeet", "30" ); ///< If vehicle closer to the player than this, then it won't be cleaned up
	setdvar( "scr_veh_disappear_maxpreventvisibilityfeet", "150" ); ///< Only apply visibility check if vehicle is closer to the player than this
	
	setdvar( "scr_veh_health_tank", "1350" ); // default health
	
	level.vehicle_drivers_are_invulnerable = getdvarint( "scr_veh_driversareinvulnerable" );
	
	level.vehicleHealths[ "panzer4_mp" ] = 2600;
	level.vehicleHealths[ "t34_mp" ] = 2600;
	
	setdvar( "scr_veh_health_jeep", "700" ); 

	if ( init_vehicle_entities() )
	{
		level.vehicle_explosion_effect= loadFX("explosions/large_vehicle_explosion"); // kaboom!

		initialize_vehicle_damage_effects_for_level();
	
		maps\mp\_panzeriv::main( "vehicle_ger_tracked_panzer4_mp" );
		maps\mp\_sherman::main( "vehicle_usa_tracked_sherman_m4a3_mp" );
		maps\mp\_t34::main( "vehicle/exhaust/fx_exhaust_t34" );
		maps\mp\_type97::main( "vehicle/exhaust/fx_exhaust_t97" );
	
	
		{
			level.veh_husk_models = [];
			
			if ( IsDefined( level.use_new_veh_husks ) )
			{
				level.veh_husk_models[ "t34_mp" ] = "veh_t34_destroyed_mp";
				//level.veh_husk_models[ "panzer4_mp" ] = "veh_panzer4_destroyed_mp";
			}
			
			keys = GetArrayKeys( level.veh_husk_models );
			
			for ( i = 0; i < keys.size; i++ )
			{
				precacheModel( level.veh_husk_models[ keys[ i ] ] );
			}
		}
		
		
		precacheRumble( "tank_damage_light_mp" );
		precacheRumble( "tank_damage_heavy_mp" );

		level._effect["tanksquish"] = loadfx("maps/see2/fx_body_blood_splat");
	}
	
	
	return;
}

initialize_vehicle_damage_effects_for_level()
{
	//###stefan $TODO it would be great if these came from a GDT somewhere instead of being hard-coded in scripts
	
	/*
	Vehicle damage effects are stored in level.vehicles_damage_states[]
	where the array key is the GDT vehicle-type name for the particular vehicle.
	For example, "sherman_mp" --> level.vehicles_damage_states["sherman_mp"]
	The default MP vehicle is "defaultvehicle_mp". This is used for vehicles who do not have a custom entry in the vehicles_damage_states[] array.
	
	Here we setup the vehicle damage effects response behaviors for all vehicles, using a data structure layout as follows:
	struct s_vehicle_damage_state
	{
		float health_percentage; // apply effect(s) from effect_array[] when vehicle health is <= this amount
		struct s_effect_array
		{
			id damage_effect; // this is the damage effect to apply
			string sound_effect; // this is the sound effect to play
			string vehicle_tag; // this is the tag on the vehicle where the effect should be applied
		} effect_array[];
	};
	So, when a vehicle's health percentage becomes <= s_vehicle_damage_effects.health_percentage,
	all the effects listed in s_vehicle_damage_effects.effect_array[] are applied as defined
	*/
	
	// damage indices
	k_mild_damage_index= 0;
	k_moderate_damage_index= 1;
	k_severe_damage_index= 2;
	k_total_damage_index= 3;
	
	// health_percentage constants
	k_mild_damage_health_percentage= 0.85;
	k_moderate_damage_health_percentage= 0.55;
	k_severe_damage_health_percentage= 0.35;
	k_total_damage_health_percentage= 0;
	level.k_mild_damage_health_percentage = k_mild_damage_health_percentage;
	level.k_moderate_damage_health_percentage = k_moderate_damage_health_percentage;
	level.k_severe_damage_health_percentage = k_severe_damage_health_percentage;
	level.k_total_damage_health_percentage = k_total_damage_health_percentage;
	
	level.vehicles_damage_states= [];
	level.vehicles_husk_effects = [];
	level.vehicles_damage_treadfx = [];
	
	// setup the default vehicle
	vehicle_name= get_default_vehicle_name();
	{
		level.vehicles_damage_states[vehicle_name]= [];
		level.vehicles_damage_treadfx[vehicle_name] = [];

		// mild damage
		{
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].health_percentage= k_mild_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_tank_sherman_smldr"); // smoldering (smoke puffs)
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].vehicle_tag= "tag_origin";
		}
		// moderate damage
		{
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].health_percentage= k_moderate_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_vfire_med_12"); // flames & more smoke
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].vehicle_tag= "tag_origin";
		}
		// severe damage
		{
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].health_percentage= k_severe_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_vfire_sherman"); // pillar of smoke
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].vehicle_tag= "tag_origin";
		}
		// total damage
		{
			level.vehicles_damage_states[vehicle_name][k_total_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].health_percentage= k_total_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].damage_effect= loadFX("explosions/large_vehicle_explosion");
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].sound_effect= "vehicle_explo"; // kaboom!
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].vehicle_tag= "tag_origin";
		}
		
		
		{
			default_husk_effects = SpawnStruct();
			default_husk_effects.damage_effect = undefined;//loadFX("vehicle/vfire/fx_vfire_med_12"); // flames & more smoke
			default_husk_effects.sound_effect = undefined;
			default_husk_effects.vehicle_tag = "tag_origin";
			
			level.vehicles_husk_effects[ vehicle_name ] = default_husk_effects;
		}
	}

	maps\mp\_t34::build_damage_states();
	maps\mp\_panzeriv::build_damage_states();
	
	return;
}

//string
get_vehicle_name(
	vehicle)
{
	name= "";
	
	if (IsDefined(vehicle))
	{
		if (IsDefined(vehicle.vehicletype))
		{
			name= vehicle.vehicletype;
		}
	}
	
	return name;
}

//string
get_default_vehicle_name()
{
	return "defaultvehicle_mp";
}

//string
get_vehicle_name_key_for_damage_states(
	vehicle)
{
	vehicle_name= get_vehicle_name(vehicle);
	
	if (!IsDefined(level.vehicles_damage_states[vehicle_name]))
	{
		vehicle_name= get_default_vehicle_name();
	}
	
	return vehicle_name;
}

//int
get_vehicle_damage_state_index_from_health_percentage(
	vehicle)
{
	damage_state_index= -1;
	vehicle_name= get_vehicle_name_key_for_damage_states();
	
	for (test_index= 0; test_index<level.vehicles_damage_states[vehicle_name].size; test_index++)
	{
		if (vehicle.current_health_percentage<=level.vehicles_damage_states[vehicle_name][test_index].health_percentage)
		{
			damage_state_index= test_index;
		}
		else
		{
			break;
		}
	}
	
	return damage_state_index;
}


// called each time a vehicle takes damage
update_damage_effects(
	vehicle,
	attacker)
{
	if (vehicle.initial_state.health>0)
	{
		previous_damage_state_index= get_vehicle_damage_state_index_from_health_percentage(vehicle);
		vehicle.current_health_percentage= vehicle.health/vehicle.initial_state.health;
		current_damage_state_index= get_vehicle_damage_state_index_from_health_percentage(vehicle);
		// if we have reached a new damage state, play associated effects
		if (previous_damage_state_index!=current_damage_state_index)
		{
			vehicle notify ( "damage_state_changed" );
			if (previous_damage_state_index<0)
			{
				start_damage_state_index= 0;
			}
			else
			{
				start_damage_state_index= previous_damage_state_index+1;
			}
			play_damage_state_effects(vehicle, start_damage_state_index, current_damage_state_index);
			if ( vehicle.health <= 0 )
			{
				vehicle kill_vehicle(attacker);
			}
		}
	}
	
	return;
}


play_damage_state_effects(
	vehicle,
	start_damage_state_index,
	end_damage_state_index)
{
	vehicle_name= get_vehicle_name_key_for_damage_states( vehicle );
	
	// play effects for all damage states from start_damage_state_index --> end_damage_state_index
	for (damage_state_index= start_damage_state_index; damage_state_index<=end_damage_state_index; damage_state_index++)
	{
		for (effect_index= 0;
			effect_index<level.vehicles_damage_states[vehicle_name][damage_state_index].effect_array.size;
			effect_index++)
		{
			effects = level.vehicles_damage_states[ vehicle_name ][ damage_state_index ].effect_array[ effect_index ];
			vehicle thread play_vehicle_effects( effects );
		}
	}
	
	return;
}


play_vehicle_effects( effects, isDamagedTread )
{
	self endon( "delete" );
	self endon( "removed" );
	
	if ( !isdefined( isDamagedTread ) || isDamagedTread == 0 )
	{
		self endon( "damage_state_changed" );
	}

	// if there is an associated sound effect, play it
	if ( IsDefined( effects.sound_effect ) )
	{
		self PlaySound( effects.sound_effect );
	}

	waitTime = 0;
	if ( isdefined ( effects.damage_effect_loop_time ) )
	{
		waitTime = effects.damage_effect_loop_time;
	}

	while ( waitTime > 0 )
	{
		// if the specified effect was loaded, play it on the associated vehicle tag
		if ( IsDefined( effects.damage_effect ) )
		{
			PlayFxOnTag( effects.damage_effect, self, effects.vehicle_tag );
		}
		wait( waitTime );
	}
}


init_vehicle_entities()
{
	vehicles = getentarray( "script_vehicle", "classname" );
	array_thread( vehicles, ::init_original_vehicle );
	
	if ( isdefined( vehicles ) )
	{
		return vehicles.size;
	}
	
	return 0;
}


precache_vehicles()
{
	// Last time I tested, this is actually not called from anywhere
}


register_vehicle()
{
	// Register vehicle husk
	if ( !IsDefined( level.vehicles_list ) )
	{
		level.vehicles_list = [];
	}
	
	level.vehicles_list[ level.vehicles_list.size ] = self;
}


// Before spawning a new vehicle, we need to bookkeep our list
// of instantiated vehicles.  If spawning the new vehicle would cause us to go
// over the max vehicle limit, then we need to force-delete
// the oldest (dead) ones to make room.

manage_vehicles()
{
	if ( !IsDefined( level.vehicles_list ) )
	{
		return true;
	}
	else
	{
		MAX_VEHICLES = GetMaxVehicles();
		
		{
			// Consolidate array - Husks might have been cleaned up in the interim
			
			newArray = [];
			
			for ( i = 0; i < level.vehicles_list.size; i++ )
			{
				if ( IsDefined( level.vehicles_list[ i ] ) )
				{
					newArray[ newArray.size ] = level.vehicles_list[ i ];
				}
			}
			
			level.vehicles_list = newArray;
		}
		
		
		// make sure there's room for one more
		vehiclesToDelete = ( level.vehicles_list.size + 1 ) - MAX_VEHICLES;
		
		
		if ( vehiclesToDelete > 0 )
		{
			newArray = [];
			
			for ( i = 0; i < level.vehicles_list.size; i++ )
			{
				vehicle = level.vehicles_list[ i ];
				
				if ( vehiclesToDelete > 0 )
				{
					// ".permanentlyRemoved" vehicles will never be really deleted
					if ( IsDefined( vehicle.is_husk ) && !IsDefined( vehicle.permanentlyRemoved ) )
					{
						deleted = vehicle husk_do_cleanup();
						
						if ( deleted )
						{
							vehiclesToDelete--;
							continue;
						}
					}
				}
				
				newArray[ newArray.size ] = vehicle;
			}
			
			level.vehicles_list = newArray;
		}
		
		return level.vehicles_list.size < MAX_VEHICLES;
	}
}


/* 
============= 
///ScriptDocBegin
"Name: init_vehicle( )"
"Summary: Initializes a vehicle entity when the game starts"
"Module: Vehicle"
"Example: vehicle init_vehicle();"
"SPMP: multiplayer"
///ScriptDocEnd
============= 
*/ 
init_vehicle()
{
	self register_vehicle();
	

	// setting the tank health here so it is universal
	// we should do the same for the other vehicles
	if ( isdefined( level.vehicleHealths ) && isdefined( level.vehicleHealths[ self.vehicletype ] ) )
	{
		self.maxhealth = level.vehicleHealths[ self.vehicletype ];
	}
	else
	{
		self.maxhealth = getdvarint("scr_veh_health_tank");
/#
		println( "No health specified for vehicle type "+self.vehicletype+"! Using default..." );
#/
	}
	self.health = self.maxhealth;
		
	self vehicle_record_initial_values();
	
	self init_vehicle_threads();
	
	self maps\mp\gametypes\_spawning::create_vehicle_influencers();
	
	self thread monitorTankDeath();
}


initialize_vehicle_damage_state_data()
{
	if (self.initial_state.health>0)
	{
		self.current_health_percentage= self.health/self.initial_state.health;
		self.previous_health_percentage= self.health/self.initial_state.health;
	}
	else
	{
		self.current_health_percentage= 1;
		self.previous_health_percentage= 1;
	}
	
	return;
}

init_original_vehicle()
{
	// this is a temporary hack trying to resolve the "!cent->pose.fx.effect"
	// crash bug.  Basically I think the bug is caused by deleteing the original 
	// tanks that were in the bsp
	self.original_vehicle = true;
	
	self init_vehicle();
}

monitorTankDeath()
{
	self endon( "disconnect" );
	for ( ;; )
	{
		self waittill ("death", attacker, damageFromUnderneath, weaponName ); 
		
		if ( isdefined ( attacker )  && isdefined ( weaponName ) )
		{
			if ( attacker.health < 100 && isDefined ( attacker.lastTankThatAttacked ) ) 
			{
				if (self == attacker.lastTankThatAttacked ) 
					attacker maps\mp\gametypes\_missions::doMissionCallback( "youtalkintome", attacker ); 
			}
			if ( isdefined ( damageFromUnderneath ) && isdefined( attacker.pers ) && vehicle_get_occupant_team() != attacker.pers["team"] || game["dialog"]["gametype"] == "freeforall" )
			{
				if ( damageFromUnderneath && weaponName == "satchel_charge_mp")
					attacker maps\mp\gametypes\_missions::doMissionCallback( "trapper", attacker ); 
			}
		}
	}
}



/*###stefan $NOTE OLD debug vehicle health bar system; disabled per David Vonderhaar - do not turn this on!
// debug code below is for a simple vehicle health bar
vehicle_wait_player_enter_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	while( 1 )
	{
		self waittill( "enter_vehicle", player );

		player thread player_wait_exit_vehicle_t();

		player player_update_vehicle_hud( true, self );
	}
}


player_wait_exit_vehicle_t()
{
	// Don't endon "death".  Player will receive
	// "exit_vehicle" message when killed in a vehicle
	self endon( "disconnect" );
	
	self waittill( "exit_vehicle", vehicle );
	self player_update_vehicle_hud( false, vehicle );
}


vehicle_wait_damage_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	while( 1 )
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type );

		occupants = self GetVehOccupants();
		if( isDefined( occupants ) )
		{
			for( i = 0; i < occupants.size; i++ )
			{
				occupants[i] player_update_vehicle_hud( true, self );
			}
		}
	}
}


player_update_vehicle_hud( show, vehicle )
{
	if( show )
	{
		if ( !isDefined( self.vehicleHud ) )
		{
			self.vehicleHud = createBar( (1, 1, 1), 64, 16 );
			self.vehicleHud setPoint( "CENTER", "BOTTOM", 0, -40 );
			self.vehicleHud.alpha = 0.75;
		}

		self.vehicleHud updateBar( vehicle.health / vehicle.initial_state.health );
	}
	else
	{
		if ( isDefined( self.vehicleHud ) )
		{
			self.vehicleHud destroyElem();
		}
	}

	if ( getDvar( "scr_vehicle_healthnumbers" )!= "" )
	{
		if ( getDvarInt( "scr_vehicle_healthnumbers" )!= 0 )
		{
			if( show )
			{
				if ( !isDefined( self.vehicleHudHealthNumbers ) )
				{
					self.vehicleHudHealthNumbers = createFontString( "default", 2.0 );
					self.vehicleHudHealthNumbers setParent( self.vehicleHud );
					self.vehicleHudHealthNumbers setPoint( "LEFT", "RIGHT", 8, 0 );
					self.vehicleHudHealthNumbers.alpha = 0.75;
					self.vehicleHudHealthNumbers.hideWhenInMenu = false;
					self.vehicleHudHealthNumbers.archived = false;
				}

				self.vehicleHudHealthNumbers setValue( vehicle.health );
			}
			else
			{
				if ( isDefined( self.vehicleHudHealthNumbers ) )
				{
					self.vehicleHudHealthNumbers destroyElem();
				}
			}
		}
	}
}
*/

init_vehicle_threads()
{
	self thread vehicle_fireweapon_t();
	self thread vehicle_abandoned_by_drift_t();
	self thread vehicle_abandoned_by_occupants_t();
	self thread vehicle_damage_t();
	self thread vehicle_ghost_entering_occupants_t();
	
	self thread vehicle_recycle_spawner_t();
	self thread vehicle_disconnect_paths();
	
	/*###stefan $NOTE removed 07/29/2008
	// enable debug vehicle health bar
	self thread vehicle_wait_player_enter_t();
	self thread vehicle_wait_damage_t();
	*/
	
	self thread vehicle_wait_tread_damage();
	
	self thread vehicle_overturn_suicide();
	
	/#
	self thread cleanup_debug_print_t();
	self thread cleanup_debug_print_clearmsg_t();
	#/
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_template( <type> , <model> , <typeoverride> )"
"Summary: called in individual vehicle file - mandatory to call this in all vehicle files at the top!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <type> : vehicle type to set"
"MandatoryArg: <model> : model to set( this is usually generated by the level script )"
"OptionalArg: <typeoverride> : this overrides the type, used for copying a vehicle script"
"Example: 	build_template( "bmp", model, type );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_template( type, model, typeoverride )
{
	if( isdefined( typeoverride ) )
		type = typeoverride; 
	//precachevehicle( type );

	if( !isdefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = []; 
	if( 	!isdefined( level.vehicle_death_fx[ type ] ) )
		level.vehicle_death_fx[ type ] = []; // can have overrides
	
	level.vehicle_compassicon[ type ] = false; 
	level.vehicle_team[ type ] = "axis"; 
	level.vehicle_life[ type ] = 999; 
	level.vehicle_hasMainTurret[ model ] = false; 
	level.vehicle_mainTurrets[ model ] = [];
	level.vtmodel = model; 
	level.vttype = type; 
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_rumble( <rumble> , <scale> , <duration> , <radius> , <basetime> , <randomaditionaltime> )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <rumble> :  rumble asset"
"MandatoryArg: <scale> : scale"
"MandatoryArg: <duration> : duration"
"MandatoryArg: <radius> : radius"
"MandatoryArg: <basetime> : time to wait between rumbles"
"MandatoryArg: <randomaditionaltime> : random amount of time to add to basetime"
"Example: 			build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_rumble( rumble, scale, duration, radius, basetime, randomaditionaltime )
{
	if( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = []; 
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	assert( isdefined( rumble ) );
	precacherumble( rumble );
	struct.rumble = rumble; 
	level.vehicle_rumble[ level.vttype ] = struct; 
	precacherumble( "tank_damaged_rumble_mp" );
}

build_quake( scale, duration, radius, basetime, randomaditionaltime )
{
	struct = spawnstruct();
	struct.scale = scale; 
	struct.duration = duration; 
	struct.radius = radius; 
	if( isdefined( basetime ) )
		struct.basetime = basetime; 
	if( isdefined( randomaditionaltime ) )
		struct.randomaditionaltime = randomaditionaltime; 
	return struct; 
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_exhaust( <exhaust_effect_str> )"
"Summary: called in individual vehicle file - assign an exhaust effect to this vehicle!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <exhaust_effect_str> : exhaust effect in string format"
"Example: 	build_exhaust( "distortion / abrams_exhaust" );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_exhaust( effect )
{
	level.vehicle_exhaust[ level.vtmodel ] = loadfx( effect );
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_treadfx()"
"Summary: called in individual vehicle file - enables treadfx"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"Example: 	build_treadfx();"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_treadfx( type )
{
	if( ! isdefined( type ) )
		type = level.vttype; 
	maps\mp\_treadfx::main( type );
}


cleanup_debug_print_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	/#
	while ( 1 )
	{
		if ( IsDefined( self.debug_message )
			&& getdvarint( "scr_veh_cleanupdebugprint" ) != 0 )
		{
			Print3d( self.origin + ( 0, 0, 150 ), self.debug_message, ( 0, 1, 0 ), 1, 1, 1 );
		}
		
		wait 0.01;
	}
	#/
}


cleanup_debug_print_clearmsg_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	/#
	while ( 1 )
	{
		self waittill( "enter_vehicle" );
		self.debug_message = undefined;
	}
	#/
}


cleanup_debug_print( message )
{
	/#
	self.debug_message = message;
	#/
}


// =====================================================================================
// Abandonment Code

vehicle_abandoned_by_drift_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	self wait_then_cleanup_vehicle( "Drift Test", "scr_veh_cleanupdrifted" );
}


vehicle_abandoned_by_occupants_timeout_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	self wait_then_cleanup_vehicle( "Abandon Test", "scr_veh_cleanupabandoned" );
}


wait_then_cleanup_vehicle( test_name, cleanup_dvar_name )
{
	self endon( "enter_vehicle" );
	
	self wait_until_severely_damaged();
	self do_alive_cleanup_wait( test_name );
	self wait_for_vehicle_to_stop_outside_min_radius(); // unoccupied vehicle can be being pushed!
	self cleanup( test_name, cleanup_dvar_name, ::vehicle_recycle );
}


wait_until_severely_damaged()
{
	while ( 1 )
	{
		health_percentage = self.health / self.initial_state.health;
		
		if ( IsDefined( level.k_severe_damage_health_percentage ) ) // initially called before this is set up.
		{
			self cleanup_debug_print( "Damage Test: Still healthy - (" + health_percentage + " >= " + level.k_severe_damage_health_percentage + ") and working treads");
		}
		else
		{
			self cleanup_debug_print( "Damage Test: Still healthy and working treads");
		}
		
		
		self waittill( "damage" );
		
		health_percentage = self.health / self.initial_state.health;
		
		if ( ( health_percentage < level.k_severe_damage_health_percentage )
			|| ( ( self GetTreadHealth( 0 ) ) <= 0.0 )
			|| ( ( self GetTreadHealth( 1 ) ) <= 0.0 ) )
			break;
	}
}


get_random_cleanup_wait_time( state )
{
	varnamePrefix = "scr_veh_" + state + "_cleanuptime";
	minTime = getdvarfloat( varnamePrefix + "min" );
	maxTime = getdvarfloat( varnamePrefix + "max" );	
	
	if ( maxTime > minTime )
	{
		return RandomFloatRange( minTime, maxTime );
	}
	else
	{
		return maxTime;
	}
}


do_alive_cleanup_wait( test_name )
{
	initialRandomWaitSeconds = get_random_cleanup_wait_time( "alive" );
		
	secondsWaited = 0.0;
	seconds_per_iteration = 1.0;
	
	while ( true )
	{	
		curve_begin = GetDvarFloat( "scr_veh_cleanuptime_dmgfraction_curve_begin" );
		curve_end = GetDvarFloat( "scr_veh_cleanuptime_dmgfraction_curve_end" );
		
		factor_min = GetDvarFloat( "scr_veh_cleanuptime_dmgfactor_min" );
		factor_max = GetDvarFloat( "scr_veh_cleanuptime_dmgfactor_max" );
		
		treadDeadDamageFactor = GetDvarFloat( "scr_veh_cleanuptime_dmgfactor_deadtread" );
		
	
		damageFraction = 0.0;
	
		if ( self is_vehicle() )
		{
			damageFraction = ( self.initial_state.health - self.health ) / self.initial_state.health;	
		}
		else // is husk
		{
			damageFraction = 1.0;
		}
	
		damageFactor = 0.0;
	
		if ( damageFraction <= curve_begin )
		{
			damageFactor = factor_max;
		}
		else if ( damageFraction >= curve_end )
		{
			damageFactor = factor_min;
		}
		else
		{
			dydx = ( factor_min - factor_max ) / ( curve_end - curve_begin );
			damageFactor = factor_max + ( damageFraction - curve_begin ) * dydx;
		}
		
		
		{
			// For each tread that has been completely destroyed, decrease the
			// total amount of time to wait before cleaning up.
			
			for ( i = 0; i < 2; i++ )
			{
				if ( ( self GetTreadHealth( i ) ) <= 0 )
				{
					damageFactor -= treadDeadDamageFactor;
				}
			}
		}
		
	
		totalSecsToWait = initialRandomWaitSeconds * damageFactor;
		
		if ( secondsWaited >= totalSecsToWait )
		{
			break;
		}
		
		self cleanup_debug_print( test_name + ": Waiting " + ( totalSecsToWait - secondsWaited ) + "s" );
		
		wait seconds_per_iteration;
		secondsWaited = secondsWaited + seconds_per_iteration;
	}
}


do_dead_cleanup_wait( test_name )
{
	total_secs_to_wait = get_random_cleanup_wait_time( "dead" );
		
	seconds_waited = 0.0;
	seconds_per_iteration = 1.0;
	
	while ( seconds_waited < total_secs_to_wait )
	{	
		self cleanup_debug_print( test_name + ": Waiting " + ( total_secs_to_wait - seconds_waited ) + "s" );
		wait seconds_per_iteration;
		seconds_waited = seconds_waited + seconds_per_iteration;
	}
}


cleanup( test_name, cleanup_dvar_name, cleanup_func )
{
	keep_waiting = true;

	while ( keep_waiting )
	{
		cleanupEnabled = !IsDefined( cleanup_dvar_name )
			|| getdvarint( cleanup_dvar_name ) != 0;
		
		if ( cleanupEnabled != 0 )
		{
			self [[cleanup_func]]();
			break;
		}
		
		keep_waiting = false;
		
		/#
		// Only in debug mode, we will keep looping in case someone turns the
		// cleanup dvar back on.
		self cleanup_debug_print( "Cleanup disabled for " + test_name + " ( dvar = " + cleanup_dvar_name + " )" );
		wait 5.0;
		keep_waiting = true;
		#/
	}
}

vehicle_wait_tread_damage()
{
	self endon( "death" );
	self endon( "delete" );

	vehicle_name= get_vehicle_name(self);
	
	while ( 1 )
	{
		self waittill ( "broken", brokenNotify );
		if ( brokenNotify == "left_tread_destroyed" )
		{
			if ( isdefined( level.vehicles_damage_treadfx[vehicle_name] ) && isdefined( level.vehicles_damage_treadfx[vehicle_name][0] ) )
			{
				self thread play_vehicle_effects( level.vehicles_damage_treadfx[vehicle_name][0], true );
			}
		}
		else if ( brokenNotify == "right_tread_destroyed" )
		{
			if ( isdefined( level.vehicles_damage_treadfx[vehicle_name] ) && isdefined( level.vehicles_damage_treadfx[vehicle_name][1] ) )
			{
				self thread play_vehicle_effects( level.vehicles_damage_treadfx[vehicle_name][1], true );
			}
		}
	}
}

wait_for_vehicle_to_stop_outside_min_radius()
{
	maxWaitTime = getdvarfloat( "scr_veh_waittillstoppedandmindist_maxtime" );
	iterationWaitSeconds = 1.0;
	
	maxWaitTimeEnableDistInches = 12 * getdvarfloat( "scr_veh_waittillstoppedandmindist_maxtimeenabledistfeet" );
	
	initialOrigin = self.initial_state.origin;
	
	for ( totalSecondsWaited = 0.0; totalSecondsWaited < maxWaitTime; totalSecondsWaited += iterationWaitSeconds )
	{
		// We don't want to disappear it if someone is
		// currently pushing it with another vehicle
		speedMPH = self GetSpeedMPH();
		cutoffMPH = getdvarfloat( "scr_veh_cleanupmaxspeedmph" );
		
		if ( speedMPH > cutoffMPH )
		{
			cleanup_debug_print( "(" + ( maxWaitTime - totalSecondsWaited ) + "s) Speed: " + speedMPH + ">" + cutoffMPH );
		}
		else
		{
			break;
			
			/*
			initialOriginOnTerrain = ( initialOrigin[0], initialOrigin[1], 0 );
			originOnTerrain = ( self.origin[0], self.origin[1], 0 );
			moveDistInches = Distance( initialOriginOnTerrain, originOnTerrain );
			cutoffInches = 12 * getdvarint( "scr_veh_cleanupmindistancefeet" );
			
			if ( moveDistInches < cutoffInches )
			{
				cleanup_debug_print( "(" + ( maxWaitTime - totalSecondsWaited ) + "s) Dist: " + moveDistInches + "<" + cutoffInches );
				
				if ( moveDistInches < maxWaitTimeEnableDistInches )
				{
					totalSecondsWaited = 0.0;
				}
			}
			else
			{
				break;
			}
			*/
		}
		
		wait iterationWaitSeconds;
	}
}


vehicle_abandoned_by_occupants_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	while ( 1 )
	{
		self waittill( "exit_vehicle" );
		
		occupants = self GetVehOccupants();
		
		if ( occupants.size == 0 )
		{
			self play_start_stop_sound( "tank_shutdown_sfx" );
			self thread vehicle_abandoned_by_occupants_timeout_t();
		}
	}
}


play_start_stop_sound( sound_alias, modulation )
{
	if ( IsDefined( self.start_stop_sfxid ) )
	{
		//stopSound( self.start_stop_sfxid );
	}
	
	self.start_stop_sfxid = self playSound( sound_alias );
}


// this function should be replaced by code in cg_player.cpp cg_player() 
// we should just not be rendering the player when in a non-visible seat
vehicle_ghost_entering_occupants_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	//if ( self vehicle_is_tank() )
	{
		while ( 1 )
		{
			self waittill( "enter_vehicle", player, seat );
			
			isDriver = seat == 0;
			
			if ( getdvarint( "scr_veh_driversarehidden" ) != 0
				&& isDriver )
			{
				player Ghost();
			}
			
			
			{
				occupants = self GetVehOccupants();
				
				if ( occupants.size == 1 )
				{
					self play_start_stop_sound( "tank_startup_sfx" );
				}
			}
			
			
			player thread player_change_seat_handler_t( self );
			player thread player_leave_vehicle_cleanup_t( self );
		}
	}
}


player_is_occupant_invulnerable( sMeansOfDeath )
{
	invulnerable = ( level.vehicle_drivers_are_invulnerable	&& ( self player_is_driver() ) );
	
	return invulnerable;
}


player_is_driver()
{
	if ( !isalive(self) )
		return false;
		
	vehicle = self GetVehicleOccupied();
	
	if ( IsDefined( vehicle ) )
	{
		seat = vehicle GetOccupantSeat( self );
		
		if ( isdefined(seat) && seat == 0 )
			return true;
	}
	
	return false;
}


// this function should be replaced by code in cg_player.cpp cg_player() 
// we should just not be rendering the player when in a non-visible seat
player_change_seat_handler_t( vehicle )
{
	self endon( "disconnect" );
	self endon( "exit_vehicle" );

	while ( 1 ) 
	{
		self waittill( "change_seat", vehicle, oldSeat, newSeat );
		
		isDriver = newSeat == 0;
		
		if ( isDriver )
		{
			if ( getdvarint( "scr_veh_driversarehidden" ) != 0 )
			{
				self Ghost();
			}
		}
		else
		{
			self Show();
		}
	}
}


// this function should be replaced by code in cg_player.cpp cg_player() 
// we should just not be rendering the player when in a non-visible seat
player_leave_vehicle_cleanup_t( vehicle )
{
	self endon( "disconnect" );
	self waittill( "exit_vehicle" );
	currentWeapon = self getCurrentWeapon();
	
	if( self.lastWeapon != currentWeapon && self.lastWeapon != "none" )
		self switchToWeapon( self.lastWeapon );

	self Show();
}


vehicle_is_tank()
{
	return self.vehicletype == "sherman_mp"
		|| self.vehicletype == "panzer4_mp"
		|| self.vehicletype == "type97_mp"
		|| self.vehicletype == "t34_mp";
}

// =====================================================================================


vehicle_record_initial_values()
{
	if ( !IsDefined( self.initial_state ) )
	{
		self.initial_state= SpawnStruct();
	}
	
	if ( IsDefined( self.origin ) )
	{
		self.initial_state.origin= self.origin;
	}
	
	if ( IsDefined( self.angles ) )
	{
		self.initial_state.angles= self.angles;
	}
	
	if ( IsDefined( self.health ) )
	{
		self.initial_state.health= self.health;
	}

	self maps\mp\_destructible::destructible_record_initial_values();
	
	self initialize_vehicle_damage_state_data();
	
	return;
}


vehicle_fireweapon_t()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	for( ;; )
	{
		self waittill( "turret_fire", player );
		
		if ( isdefined(player) && isalive(player) && player isinvehicle() )
			self fireweapon();
	}
}


vehicle_should_explode_on_cleanup()
{
	return getdvarint( "scr_veh_explode_on_cleanup" ) != 0;
}


vehicle_recycle()
{
	self wait_for_unnoticeable_cleanup_opportunity();
	self.recycling = true;
	self suicide();
}

wait_for_vehicle_overturn()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );

	worldup = anglestoup((0,90,0));
	
	overturned = 0;
	
	while (!overturned)	
	{
		if ( IsDefined( self.angles ) )
		{
			up = AnglesToUp( self.angles );
			dot = vectordot(up, worldup);
			if (dot <= 0.0)
				overturned = 1;
		}
		
		if (!overturned)
			wait (1.0);
	}
}

vehicle_overturn_suicide()
{
	self endon( "transmute" );
	self endon( "death" );
	self endon( "delete" );
	
	self wait_for_vehicle_overturn();

	seconds = RandomFloatRange( 5, 7 );
	wait seconds;
	
	damageOrigin = self.origin + (0,0,25);
	self finishVehicleRadiusDamage(self, self, 32000, 32000, 32000, 0, "MOD_EXPLOSIVE", "defaultweapon_mp",  damageOrigin, 400, -1, (0,0,1), 0);
}

suicide()
{
	self kill_vehicle( self );
}

kill_vehicle( attacker )
{
	damageOrigin = self.origin + (0,0,1);
	self finishVehicleRadiusDamage(attacker, attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", "defaultweapon_mp",  damageOrigin, 400, -1, (0,0,1), 0);
}

value_with_default( preferred_value, default_value )
{
	if ( IsDefined( preferred_value ) )
	{
		return preferred_value;
	}
	
	return default_value;
}


vehicle_transmute( attacker )
{
	deathOrigin = self.origin;
	deathAngles = self.angles;
	
	
	modelname = self VehGetModel();
	vehicle_name = get_vehicle_name_key_for_damage_states( self );
	
	
	respawn_parameters = SpawnStruct();
	respawn_parameters.origin = self.initial_state.origin;
	respawn_parameters.angles = self.initial_state.angles;
	respawn_parameters.health = self.initial_state.health;
	respawn_parameters.modelname = modelname;
	respawn_parameters.targetname = value_with_default( self.targetname, "" );
	respawn_parameters.vehicletype = value_with_default( self.vehicletype, "" );
	respawn_parameters.destructibledef = self.destructibledef; // Vehicle may or may not be a destructible vehicle
	
	
	vehicleWasDestroyed = !IsDefined( self.recycling );

	if ( vehicleWasDestroyed
		|| vehicle_should_explode_on_cleanup() )
	{
		_spawn_explosion( deathOrigin );
		
		if ( vehicleWasDestroyed
			&& getdvarint( "scr_veh_explosion_doradiusdamage" ) != 0 )
		{
			// Vehicle is exploding, so damage nearby entities
			// Damage first, so doesn't affect other entities spawned
			// by this function
			
			explosionRadius = getdvarint( "scr_veh_explosion_radius" );
			explosionMinDamage = getdvarint( "scr_veh_explosion_mindamage" );
			explosionMaxDamage = getdvarint( "scr_veh_explosion_maxdamage" );
			self kill_vehicle(attacker);
			self RadiusDamage( deathOrigin, explosionRadius, explosionMaxDamage, explosionMinDamage, attacker, "MOD_EXPLOSIVE", self.vehicletype+"_explosion_mp" );////////////////XXXXXXXXXXXXXXXXX COLLATERAL DAMAGE
		}
	}
	
	
	self notify( "transmute" );
	
		
	respawn_vehicle_now = true;
	
	if ( vehicleWasDestroyed
		&& getdvarint( "scr_veh_ondeath_createhusk" ) != 0 )
	{
		// Spawn burned out husk for players to use as cover
		
		if ( getdvarint( "scr_veh_ondeath_usevehicleashusk" ) != 0 )
		{
			husk = self;
			self.is_husk = true;
		}
		else
		{
			husk = _spawn_husk( deathOrigin, deathAngles, modelname );
		}
			
		husk _init_husk( vehicle_name, respawn_parameters );
		
		if ( getdvarint( "scr_veh_respawnafterhuskcleanup" ) != 0 )
		{
			respawn_vehicle_now = false;
		}
	}
	
	
	if ( !IsDefined( self.is_husk ) )
	{
		self remove_vehicle_from_world();
	}
	
	
	if ( respawn_vehicle_now )
	{
		respawn_vehicle( respawn_parameters );
	}
}


respawn_vehicle( respawn_parameters )
{	
	{
		minTime = getdvarint( "scr_veh_respawntimemin" );
		maxTime = getdvarint( "scr_veh_respawntimemax" );
		seconds = RandomFloatRange( minTime, maxTime );
		wait seconds;
	}
	
	
	wait_until_vehicle_position_wont_telefrag( respawn_parameters.origin );
	
			
	if ( !manage_vehicles() ) // make sure we don't hit max vehicle limit
	{
		/#
		iprintln("Vehicle can't respawn because MAX_VEHICLES has been reached and none of the vehicles could be cleaned up.");
		#/
	}
	else
	{		
		if ( IsDefined( respawn_parameters.destructibledef ) ) // passing undefined argument doesn't make the server happy
		{
			vehicle = SpawnVehicle(
				respawn_parameters.modelname,
				respawn_parameters.targetname,
				respawn_parameters.vehicletype,
				respawn_parameters.origin,
				respawn_parameters.angles,
				respawn_parameters.destructibledef );
		}
		else
		{
			vehicle = SpawnVehicle(
				respawn_parameters.modelname,
				respawn_parameters.targetname,
				respawn_parameters.vehicletype,
				respawn_parameters.origin,
				respawn_parameters.angles );
		}
		
		vehicle.vehicletype = respawn_parameters.vehicletype;
		vehicle.destructibledef = respawn_parameters.destructibledef;
		vehicle.health = respawn_parameters.health;
		
		vehicle init_vehicle();
	
		vehicle vehicle_telefrag_griefers_at_position( respawn_parameters.origin );
	}
}


remove_vehicle_from_world()
{
	// this is a temporary hack trying to resolve the "!cent->pose.fx.effect"
	// crash bug.  Basically I think the bug is caused by deleteing the original 
	// tanks that were in the bsp

	self notify ( "removed" );
	
	if ( IsDefined( self.original_vehicle ) )
	{
		if ( !IsDefined( self.permanentlyRemoved ) )
		{
			self.permanentlyRemoved = true; // Mark that it has been permanently removed from the world
			self thread hide_vehicle(); // threaded because it calls a wait()
		}
		
		return false;
	}
	else 
	{
		self _delete_entity();
		return true;
	}
}


_delete_entity()
{
	/#
	//iprintln("$e" + ( self GetEntNum() ) + " is deleting");
	#/
	
	self Delete();
}


hide_vehicle()
{
	under_the_world = ( self.origin[0], self.origin[1], self.origin[2] - 10000 );
	self.origin = under_the_world;

	wait 0.1;
	self Hide();
	
	self notify( "hidden_permanently" );
}


wait_for_unnoticeable_cleanup_opportunity()
{	
	maxPreventDistanceFeet = getdvarint( "scr_veh_disappear_maxpreventdistancefeet" );
	maxPreventVisibilityFeet = getdvarint( "scr_veh_disappear_maxpreventvisibilityfeet" );
	
	maxPreventDistanceInchesSq = 144 * maxPreventDistanceFeet * maxPreventDistanceFeet;
	maxPreventVisibilityInchesSq = 144 * maxPreventVisibilityFeet * maxPreventVisibilityFeet;
	

	maxSecondsToWait = getdvarfloat( "scr_veh_disappear_maxwaittime" );	
	iterationWaitSeconds = 1.0;
	
	for ( secondsWaited = 0.0; secondsWaited < maxSecondsToWait; secondsWaited += iterationWaitSeconds )
	{
		players_s = get_all_alive_players_s();
		
		okToCleanup = true;
		
		for ( j = 0; j < players_s.a.size && okToCleanup; j++ )
		{
			player = players_s.a[ j ];
			distInchesSq = DistanceSquared( self.origin, player.origin );
			
			if ( distInchesSq < maxPreventDistanceInchesSq )
			{
				self cleanup_debug_print( "(" + ( maxSecondsToWait - secondsWaited ) + "s) Player too close: " + distInchesSq + "<" + maxPreventDistanceInchesSq );
				okToCleanup = false;
			}
			else if ( distInchesSq < maxPreventVisibilityInchesSq )
			{
				vehicleVisibilityFromPlayer = self SightConeTrace( player.origin, player, AnglesToForward( player.angles ) );
				
				if ( vehicleVisibilityFromPlayer > 0 )
				{
					self cleanup_debug_print( "(" + ( maxSecondsToWait - secondsWaited ) + "s) Player can see" );
					okToCleanup = false;
				}
			}
		}
		
		if ( okToCleanup )
		{
			return;
		}
	
		wait iterationWaitSeconds;
	}
}


wait_until_vehicle_position_wont_telefrag( position )
{
	maxIterations = getdvarint( "scr_veh_respawnwait_maxiterations" );
	iterationWaitSeconds = getdvarint( "scr_veh_respawnwait_iterationwaitseconds" );
	
	for ( i = 0; i < maxIterations; i++ )
	{
		if ( !vehicle_position_will_telefrag( position ) )
		{
			return;
		}
		
		wait iterationWaitSeconds;
	}
}


vehicle_position_will_telefrag( position )
{
	players_s = get_all_alive_players_s();
	
	for ( i = 0; i < players_s.a.size; i++ )
	{
		if ( players_s.a[ i ] player_vehicle_position_will_telefrag( position ) )
		{
			return true;
		}
	}
	
	return false;
}


vehicle_telefrag_griefers_at_position( position )
{
	attacker = self;
	inflictor = self;
	doDamageToHead = 0;
	
	players_s = get_all_alive_players_s();
	
	for ( i = 0; i < players_s.a.size; i++ )
	{
		player = players_s.a[ i ];
		
		if ( player player_vehicle_position_will_telefrag( position ) )
		{
			player DoDamage( 20000, player.origin + ( 0, 0, 1 ), attacker, inflictor, doDamageToHead );
		}
	}
}


player_vehicle_position_will_telefrag( position )
{
	distanceInches = 20 * 12; ///< 20 ft., in inches
	minDistInchesSq = distanceInches * distanceInches;
	
	distInchesSq = DistanceSquared( self.origin, position );
	
	return distInchesSq < minDistInchesSq;
}


vehicle_recycle_spawner_t()
{
	self endon( "delete" );
	
	self waittill( "death", attacker ); // "vehicle Delete()" sends death message too!!!
	
	if ( IsDefined( self ) )
	{
		self vehicle_transmute( attacker );
	}
}


vehicle_play_explosion_sound()
{
	self playSound( "car_explo_large" );
}


vehicle_damage_t()
{
	self endon( "delete" );
	self endon( "removed" );
	
	for( ;; )
	{
		self waittill ( "damage", damage, attacker );

		players = get_players();
		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( !isalive(players[i]) )
				continue;
				
			vehicle = players[i] GetVehicleOccupied();
			if ( isdefined( vehicle) && self == vehicle && players[i] player_is_driver() )
			{
				if (damage>0)
				{
					// ^^^ earthquake() will generate an SRE if scale <= 0
					earthquake( damage/400, 1.0, players[i].origin, 512, players[i] );
				}
				
				if ( damage > 100.0 )
				{
/#
					println( "Playing heavy rumble." );
#/
					players[i] PlayRumbleOnEntity( "tank_damage_heavy_mp" );
				}
				else if ( damage > 10.0 )
				{
/#
					println( "Playing light rumble." );
#/
					players[i] PlayRumbleOnEntity( "tank_damage_light_mp" );
				}
			}
		}
		
		update_damage_effects(self, attacker);
		if ( self.health <= 0 )
		{
			return;
		}
	}
}


// =====================================================================================
// Burnt-Out Husk Code
	
_spawn_husk( origin, angles, modelname )
{	
	husk = Spawn( "script_model", origin );
	husk.angles = angles;
	husk SetModel( modelname );
	
	husk.health = 1;
	husk SetCanDamage( false ); ///< Does this really work?  It doesn't for players, but might for other entities
	
	return husk;
}


is_vehicle()
{
	// Could check classname=="script_vehicle", but this is a little more general purpose, I think
	return IsDefined( self.vehicletype );
}


swap_to_husk_model()
{
	if ( IsDefined( self.vehicletype ) )
	{
		husk_model = level.veh_husk_models[ self.vehicletype ];
		
		if ( IsDefined( husk_model ) )
		{
			self SetModel( husk_model );
		}
	}
}


_init_husk( vehicle_name, respawn_parameters )
{
	self swap_to_husk_model();

	effects = level.vehicles_husk_effects[ vehicle_name ];
	self play_vehicle_effects( effects );
	
	
	self.respawn_parameters = respawn_parameters;
	
	
	forcePointVariance = getdvarint( "scr_veh_explosion_husk_forcepointvariance" );
	horzVelocityVariance = getdvarint( "scr_veh_explosion_husk_horzvelocityvariance" );
	vertVelocityMin = getdvarint( "scr_veh_explosion_husk_vertvelocitymin" );
	vertVelocityMax = getdvarint( "scr_veh_explosion_husk_vertvelocitymax" );
	
	
	forcePointX = RandomFloatRange( 0-forcePointVariance, forcePointVariance );
	forcePointY = RandomFloatRange( 0-forcePointVariance, forcePointVariance );
	forcePoint = ( forcePointX, forcePointY, 0 );

	forcePoint += self.origin;
	
	initialVelocityX = RandomFloatRange( 0-horzVelocityVariance, horzVelocityVariance );
	initialVelocityY = RandomFloatRange( 0-horzVelocityVariance, horzVelocityVariance );
	initialVelocityZ = RandomFloatRange( vertVelocityMin, vertVelocityMax );
	initialVelocity = ( initialVelocityX, initialVelocityY, initialVelocityZ );
	
	
	if ( self is_vehicle() )
	{
		self LaunchVehicle( initialVelocity, forcePoint );
	}
	else
	{
		self PhysicsLaunch( forcePoint, initialVelocity );
	}
	
	
	self thread husk_cleanup_t();
	
	/#
	self thread cleanup_debug_print_t();
	#/
}


husk_cleanup_t()
{
	self endon( "death" ); // ent Delete() actually sends the "death" message!!!
	self endon( "delete" );
	self endon( "hidden_permanently" );
	
	
	respawn_parameters = self.respawn_parameters;
	
	
	self do_dead_cleanup_wait( "Husk Cleanup Test" );
	
	self wait_for_unnoticeable_cleanup_opportunity();
	
	
	self thread final_husk_cleanup_t( respawn_parameters ); // break off new thread to avoid end-ons
}


final_husk_cleanup_t( respawn_parameters )
{
	self husk_do_cleanup(); // causes endons, which is why we broke this off into a new thread
	
	if ( getdvarint( "scr_veh_respawnafterhuskcleanup" ) != 0 )
	{
		respawn_vehicle( respawn_parameters );
	}
}


// Returns true only if the entity is actually deleted, rather than just hidden.
husk_do_cleanup()
{
	// Don't ever let vehicles just blink out.  Spawn a VFX
	// explosion that doesn't injur any surrounding entities,
	// just to mask the blink out, in case players are
	// looking in the direction of this vehicle husk.
	self _spawn_explosion( self.origin );
	
	
	if ( self is_vehicle() )
	{
		return self remove_vehicle_from_world();
	}
	else
	{
		self _delete_entity();
		return true;
	}
}

// =====================================================================================


// =====================================================================================
// Explosion Code
	
_spawn_explosion( origin )
{
	if ( getdvarint( "scr_veh_explosion_spawnfx" ) == 0 )
	{
		return;
	}
	
	if ( IsDefined( level.vehicle_explosion_effect ) )
	{
		forward = ( 0, 0, 1 );
		
		rot = randomfloat( 360 );
		up = ( cos( rot ), sin( rot ), 0 );
		
		PlayFX( level.vehicle_explosion_effect, origin, forward, up );
	}
	
	thread _play_sound_in_space( "vehicle_explo", origin );
}


// NOTE: This function was copied from sab.gsc.  Should be centralized somewhere...
_play_sound_in_space( soundEffectName, origin )
{
	org = Spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( soundEffectName  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}

// =====================================================================================

vehicle_get_occupant_team()
{
	occupants = self GetVehOccupants();
	
	if ( occupants.size != 0 )
	{
		// first occupant defines the vehicle team
		occupant = occupants[0];
		
		if ( isplayer(occupant) )
		{
			return occupant.pers["team"];
		}
	}

	return "free";
}

vehicleDeathWaiter()
{
	self notify ("vehicleDeathWaiter");
	self endon ( "vehicleDeathWaiter" );
	self endon ( "disconnect" );

	while ( true )
	{
		self waittill( "vehicle_death", vehicle_died );
		if( vehicle_died )
		{
			self.diedOnVehicle = true;
		}
		else
		{
			// if the vehicle did not blow up then they died on the turret
			self.diedOnTurret = true;
		}
	}
}

turretDeathWaiter()
{
	// this has been depricated and merged with vehicleDeathWaiter
}

vehicle_kill_disconnect_paths_forever()
{
	self notify( "kill_disconnect_paths_forever" );
}

vehicle_disconnect_paths()
{
	
	self endon( "death" );
	self endon( "kill_disconnect_paths_forever" );
	if ( isdefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
	{
		self.dontDisconnectPaths = true;// lets other parts of the script know not to disconnect script
		return;		
	}
	wait( randomfloat( 1 ) );
	while( isdefined( self ) )
	{
		if( self getspeed() < 1 )
		{
			if ( !isdefined( self.dontDisconnectPaths ) )
			self disconnectpaths();
			self notify( "speed_zero_path_disconnect" );
			while( self getspeed() < 1 )
				wait .05; 
		}
		self connectpaths();
		wait 1; 
	}
}
