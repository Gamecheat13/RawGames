#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include maps\mp\zombies\_zm_zonemgr; 
#include maps\mp\zm_moon_utility; 
#include maps\mp\zm_moon_wasteland;
#include maps\mp\zm_moon_teleporter;

#insert raw\common_scripts\utility.gsh;

// ------------------------------------------------------------------------------------------------
// MAIN
// ------------------------------------------------------------------------------------------------
main()
{
	// Performance optimisation control vars.
	level._num_overriden_models = 0;
	level._use_choke_weapon_hints = 1;
	level._use_choke_blockers = 1;
	level._use_extra_blackhole_anims = ::init_extra_blackhole_anims;
	level._special_blackhole_bomb_structs = ::blackhole_bomb_area_check;
	level._limited_equipment = [];		
	level._limited_equipment[level._limited_equipment.size] = "equip_hacker_zm";
	level._override_blackhole_destination_logic = ::get_blackholebomb_destination_point;
	level._blackhole_bomb_valid_area_check = ::blackhole_bomb_in_invalid_area;
	level.quantum_bomb_prevent_player_getting_teleported = ::quantum_bomb_prevent_player_getting_teleported_override;
	
	level._no_water_risers = 1;
	//level.use_clientside_rock_tearin_fx = 1;	
	level.use_clientside_board_fx = 1;
	level.riser_fx_on_client = 1;
	level.risers_use_low_gravity_fx = 1;
//	level.check_for_alternate_poi = ::check_for_avoid_poi;

	level._round_start_func = maps\mp\zombies\_zm::round_start;
	
//t6todo	level thread maps\mp\zm_moon_ffotd::main_start();

//t6todo	maps\mp\zombies\_zm_weap_quantum_bomb::init_registration();

	maps\mp\zm_moon_fx::main();
	maps\mp\zombies\_zm::init_fx();
	maps\mp\animscripts\zm_death::precache_gib_fx();//this really belongs in zm_load::main
	level.zombiemode = true;
	
	maps\mp\_load::main();
	
	maps\mp\zm_moon_amb::main();
	
/*	trigs = GetEntArray("trigger_multiple", "classname");
	trigs = array_combine(trigs, GetEntArray("trigger_radius", "classname"));
	trigs = array_combine(trigs, GetEntArray("trigger_once", "classname"));
	
	foreach(trig in trigs)
	{
		trig Delete();
	} */
	
	precache_items();

	if(GetDvarInt( "artist") > 0)
	{
		return;
	}




	init_strings();
	init_clientflags();	

	level.player_out_of_playable_area_monitor = true;
	level.player_out_of_playable_area_monitor_callback = ::zombie_moon_player_out_of_playable_area_monitor_callback;
	level thread moon_create_life_trigs();


	level.zombie_anim_override = maps\mp\zm_moon::anim_override_func;

	level.traps = [];				//Contains all traps currently in this map

	level.round_think_func = ::moon_round_think_func;

	level.random_pandora_box_start = true;

	level.door_dialog_function = maps\mp\zombies\_zm::play_door_dialog;

	//level thread maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	level.quad_move_speed = 35;
	level.quad_explode = true;
	level.dogs_enabled = true;	

	level.dog_spawn_func = maps\mp\zombies\_zm_ai_dogs::dog_spawn_factory_logic;

	// Special zombie types, dogs and quads.
	level.custom_ai_type = [];
//t6todo	ARRAY_ADD( level.custom_ai_type, maps\mp\zombies\_zm_ai_astro::init );
//t6todo	ARRAY_ADD( level.custom_ai_type, maps\mp\zombies\_zm_ai_quad::init );
	ARRAY_ADD( level.custom_ai_type, maps\mp\zombies\_zm_ai_dogs::init );
//t6todo	ARRAY_ADD( level.custom_ai_type, maps\mp\zombies\_zm_ai_faller::faller_init );
	
	// randomize the hacker location 
	level thread hacker_location_random_init();

	level._zombie_custom_add_weapons = ::custom_add_weapons;

	include_weapons();
	include_powerups();
	include_equipment_for_level();
	maps\mp\zombies\_zm_equip_gasmask::init();
	maps\mp\zombies\_zm_equip_hacker::init();
	
/*t6todo	*/
  precachemodel( "viewmodel_zom_pressure_suit_arms" );
	precachemodel( "c_zom_moon_pressure_suit_body_player" );
	precachemodel( "c_zom_moon_pressure_suit_helm" );
	precachemodel( "c_rus_nikolai_dlc5_head_psuit" );
	level.zombiemode_gasmask_reset_player_model = ::gasmask_reset_player_model;
	level.zombiemode_gasmask_reset_player_viewmodel = ::gasmask_reset_player_set_viewmodel;
	level.zombiemode_gasmask_change_player_headmodel = ::gasmask_change_player_headmodel;
	level.zombiemode_gasmask_set_player_model = ::gasmask_set_player_model;
	level.zombiemode_gasmask_set_player_viewmodel = ::gasmask_set_player_viewmodel;

//	level.zombiemode_precache_player_model_override = ::precache_player_model_override;
//	level.zombiemode_give_player_model_override = ::give_player_model_override;
//	level.zombiemode_player_set_viewmodel_override = ::player_set_viewmodel_override;	
	level.register_offhand_weapons_for_level_defaults_override = ::moon_offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = ::offhand_weapon_give_override;	
	
		
	level.giveCustomLoadout = ::giveCustomLoadout;
	level.precacheCustomCharacters = ::precacheCustomCharacters;
	level.giveCustomCharacters = ::giveCustomCharacters;
	initCharacterStartIndex();
	
	level.use_zombie_heroes = true;

	//ENABLE PACK-A-PUNCH
	level.zombiemode_using_pack_a_punch = true;

	//ENABLE PERKS
	level.zombiemode_using_additionalprimaryweapon_perk = true;
	level.zombiemode_using_deadshot_perk = true;
	level.zombiemode_using_divetonuke_perk = true;
	level.zombiemode_using_doubletap_perk = true;
	level.zombiemode_using_juggernaut_perk = true;
	level.zombiemode_using_marathon_perk = true;
	level.zombiemode_using_revive_perk = true;
	level.zombiemode_using_sleightofhand_perk = true;

	level.moon_startmap = true;

	level._zombiemode_blocker_trigger_extra_thread = ::hacker_hides_blocker_trigger_thread;

	level.zombiemode_sidequest_init = ::moon_sidequest_of_awesome;

	//maps\mp\zombies\_zm::main();
	
	//Init zombiemode scripts
	maps\mp\zombies\_zm::init();
	
	level thread maps\mp\zombies\_zm::register_sidequest( "COTD", "ZOMBIE_COAST_EGG_SOLO", 43, "ZOMBIE_COAST_EGG_COOP", 44 );
	level thread maps\mp\zombies\_zm::register_sidequest( "EOA", undefined, undefined, "ZOMBIE_TEMPLE_SIDEQUEST", undefined );	
	level thread maps\mp\zombies\_zm::register_sidequest( "MOON", undefined, undefined, "ZOMBIE_MOON_SIDEQUEST_TOTAL", undefined );	
	
	// init the weapons
//t6todo	maps\_sticky_grenade::init();
//t6todo	maps\mp\zombies\_zm_weap_black_hole_bomb::init();
	maps\mp\zombies\_zm_weap_microwavegun::init();
	maps\mp\zombies\_zm_weap_quantum_bomb::init();

	// Setup the levels Zombie Zone Volumes
	level.zone_manager_init_func = ::moon_zone_init;
	init_zones[0] = "bridge_zone";
	init_zones[1] = "nml_zone";
	level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );

	level.zombie_ai_limit = 24;

	level maps\mp\zm_moon_digger::digger_init_flags();
	level thread maps\mp\zm_moon_achievement::init();
	
	level thread electric_switch();

	// Setup generator switch
	level thread electric_switch();
	
	level thread maps\mp\zm_moon_distance_tracking::zombie_tracking_init();
	
	// Teleporter initializations
	init_no_mans_land();
	level thread teleporter_check_for_endgame();
	level thread teleporter_function( "generator_teleporter" );
	level thread teleporter_function( "nml_teleporter" );

	level thread vision_set_init();
	level thread init_zombie_airlocks();
	level thread setup_water_physics();

	// The default time between round spawns (we change this in No Mans Land)
	set_zombie_var( "zombie_intermission_time", 15 );
	set_zombie_var( "zombie_between_round_time", 10 );
	
	
//t6todo	setsaveddvar( "r_zombieDisableSlideEffect", "1" );	
	
 level thread maps\mp\zm_moon_digger::digger_init();

/* t6todo
	level thread maps\mp\zm_moon_ai_astro::init();
	level thread maps\mp\zm_moon_ai_quad::init();
*/

	maps\mp\zm_moon_gravity::init();
	
	maps\mp\zm_moon_jump_pad::init();	// jump pads

	level thread maps\mp\zm_moon_gravity::zombie_moon_update_player_gravity();
	level thread maps\mp\zm_moon_gravity::zombie_moon_update_player_float();


	level thread maps\mp\zm_moon_sq::start_moon_sidequest();
	
	level thread init_hackables();

//	level thread maps\mp\zm_moon_achievement::init();
	
	/#
	execdevgui( "devgui_zombie_moon" );
	level.custom_devgui = ::moon_devgui;
	#/
	
	// special intermission for earth/moon
	level.custom_intermission = ::moon_intermission;	
	
	
	// DCS 070111: No mans land machines on from start.
	level thread no_mans_land_power();
	
	// DCS 070511: falling death from cliff recieving.
	level thread cliff_fall_death();
	
	level thread setup_fields();

//t6todo	level thread maps\mp\zm_moon_ffotd::main_end();
	
	//to stop any clientside stuff when the game ends
	level thread wait_for_end_game();

	// preset destroyed state for tunnel.
	level.tunnel_6_destroyed = GetEnt("tunnel_6_destroyed","targetname");
	level.tunnel_6_destroyed Hide();
	level.tunnel_11_destroyed = GetEnt("tunnel_11_destroyed","targetname");
	level.tunnel_11_destroyed Hide();

	// cleanup hud after losing perk
	level.perk_lost_func = ::moon_perk_lost;

//t6todo	level._black_hole_bomb_poi_override = ::moon_black_hole_bomb_poi;
	
	//respawn override
	level.check_valid_spawn_override = ::moon_respawn_override;
	level._zombiemode_post_respawn_callback = ::moon_post_respawn_callback;
	
	// notify csc to set the proper vision and fog
	level thread end_game_vision_and_fog_fix();
	
	// poi override
	level._poi_override = ::moon_bhb_poi_control;
	
	//no splosion for quads in low gravity
	level._override_quad_explosion = ::override_quad_explosion;

	level.zombie_speed_up = ::moon_speed_up;
	level.ai_astro_explode = ::moon_push_zombies_when_astro_explodes;
}

moon_push_zombies_when_astro_explodes( position )
{
	level.quantum_bomb_cached_closest_zombies = undefined;
	self thread maps\mp\zombies\_zm_weap_quantum_bomb::quantum_bomb_zombie_fling_result( position );
}


moon_post_respawn_callback()
{
	self clearclientflag(level._CF_PLAYER_GASMASK_OVERLAY);
	
	//to ensure the correct sky is shown after respawning
	if(flag("enter_nml"))
	{
		self setclientflag(level._CLIENTFLAG_PLAYER_SKY_TRANSITION);
	}
	else
	{
		self clearclientflag(level._CLIENTFLAG_PLAYER_SKY_TRANSITION);
	}
	
	
	if( !maps\mp\zombies\_zm_equipment::limited_equipment_in_use("equip_hacker_zm") ) 
	{
		self maps\mp\zombies\_zm_equipment::set_equipment_invisibility_to_player( "equip_hacker_zm", false );
	}
}

setup_fields()
{
	flag_wait("power_on");
	exploder(140);
}

// ------------------------------------------------------------------------------------------------
// DCS: special machine init.
// ------------------------------------------------------------------------------------------------
no_mans_land_power()
{
	level thread turn_area51_perks_on();
	level notify("Pack_A_Punch_on" );
}

turn_area51_perks_on()
{
	machine = getentarray("vending_sleight", "targetname");
	for( i = 0; i < machine.size; i++ )
	{
		machine[i] setmodel("zombie_vending_sleight_on");
	}
	level notify( "specialty_fastreload_power_on" );

	machine2 = getentarray("vending_jugg", "targetname");
	for( i = 0; i < machine2.size; i++ )
	{
		machine2[i] setmodel("zombie_vending_jugg_on");
		machine2[i] playsound("zmb_perks_power_on");
		//machine2[i] thread maps\mp\zombies\_zm_perks::perk_fx( "jugger_light" );
	}
	level notify( "specialty_armorvest_power_on" );
	
}

// ------------------------------------------------------------------------------------------------
init_hackables()
{
	level thread maps\mp\zombies\_zm_hackables_wallbuys::hack_wallbuys();
	level thread maps\mp\zombies\_zm_hackables_perks::hack_perks();
	level thread maps\mp\zombies\_zm_hackables_packapunch::hack_packapunch();
	level thread maps\mp\zombies\_zm_hackables_boards::hack_boards();
	level thread maps\mp\zombies\_zm_hackables_doors::hack_doors("zombie_airlock_buy", maps\mp\zm_moon_utility::moon_door_opened);
	level thread maps\mp\zombies\_zm_hackables_doors::hack_doors();
	level thread maps\mp\zombies\_zm_hackables_powerups::hack_powerups();
	level thread maps\mp\zombies\_zm_hackables_box::box_hacks();
	
	level thread packapunch_hack_think();
	level thread pack_gate_poi_init();
}

hacker_hides_blocker_trigger_thread()
{
	self endon("death");
	
	maps\mp\zombies\_zm_equip_hacker::hide_hint_when_hackers_active();
}

// ------------------------------------------------------------------------------------------------
// Kill thread stuff.
// ------------------------------------------------------------------------------------------------
zombie_moon_player_out_of_playable_area_monitor_callback()
{
	if(is_true(self._padded)) // using jump pads.
	{
		return false;
	}	

	return true;
}
moon_create_life_trigs()
{
	//biodome life brushes from jump pad pass throughs.
//	maps\_zombiemode::spawn_life_brush( (-498, 6336, 86), 350, 760 );
//	maps\_zombiemode::spawn_life_brush( (-621, 7726, 86), 250, 760 );
//	maps\_zombiemode::spawn_life_brush( (105, 7726, 78), 250, 760 );

}	
// ------------------------------------------------------------------------------------------------
// DCS: Zombieland-ish event when hack pack machine.
// ------------------------------------------------------------------------------------------------
packapunch_hack_think()
{
	//DCS: setup pack_zombieland gates.
	flag_init("packapunch_hacked");
	time = 30;
	
	pack_gates = GetEntArray("zombieland_gate","targetname");
	for ( i = 0; i < pack_gates.size; i++ )
	{
		pack_gates[i].startpos = pack_gates[i].origin;
	}	

	while(1)
	{
		level waittill("packapunch_hacked");

		flag_clear("packapunch_hacked");
		array_thread(pack_gates,::pack_gate_activate);
		level thread pack_gate_poi_activate(time);
		
		wait(time);
		flag_set("packapunch_hacked");
		
		maps\mp\zombies\_zm_equip_hacker::register_pooled_hackable_struct(level._pack_hack_struct, maps\mp\zombies\_zm_hackables_packapunch::packapunch_hack);
	}
}

pack_gate_poi_init()
{
	pack_zombieland_poi = GetEntArray("zombieland_poi","targetname");

	// attract_dist, num_attractors, added_poi_value, start_turned_on
	for ( i = 0; i < pack_zombieland_poi.size; i++ )
	{
		pack_zombieland_poi[i] create_zombie_point_of_interest( undefined, 30, 0, false );
		pack_zombieland_poi[i] thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	}
}

pack_gate_poi_activate(time)
{
	pack_enclosure = GetEnt("pack_enclosure","targetname");
	pack_zombieland_poi = GetEntArray("zombieland_poi","targetname");

	players = GET_PLAYERS();
	num_players_inside = 0;
	
	for( i=0; i<players.size; i++ )
	{
		if( players[i] istouching( pack_enclosure ) )
		{
			num_players_inside++;
		}
	}
	
	if(num_players_inside != players.size)
	{
		return;
	}	

	level thread activate_zombieland_poi_positions(time);
	level thread watch_for_exit(pack_zombieland_poi);

	while( !flag( "packapunch_hacked" ) )
	{
		zombies = GetAIArray("axis");
		for( i=0; i<zombies.size; i++ )
		{
			if( zombies[i] istouching( pack_enclosure ) )
			{
				zombies[i].in_pack_enclosure = true;
				zombies[i] thread moon_zombieland_ignore_poi();
			}
			else if( !is_true( zombies[i]._poi_pack_set ) ) // these zombies are outside the cage
			{
				
				// thread the function that assign a different poi per guy
				zombies[i] thread switch_between_zland_poi();
				zombies[i] thread moon_nml_bhb_present();
				zombies[i]._poi_pack_set = 1;
				
			}
			
		}
		
		wait( 1.0 );
	}

	flag_wait("packapunch_hacked");
	level notify("stop_pack_poi");

	zombies = GetAIArray( "axis" );
	for ( i = 0; i < zombies.size; i++ )
	{
		zombies[i]._poi_pack_set = 0;
	}

	// DCS: deactivate point of interests
	for ( i = 0; i < pack_zombieland_poi.size; i++ )
	{
		pack_zombieland_poi[i] deactivate_zombie_point_of_interest();
	}		
}

switch_between_zland_poi()
{
	self endon( "death" );
	level endon( "packapunch_hacked" );
	self endon( "nml_bhb" );
	
	poi_array = GetEntArray( "zombieland_poi", "targetname" );
	
	for( x = 0; x < poi_array.size; x++ )
	{
		if( is_true( poi_array[x].poi_active ) )
		{
			self add_poi_to_ignore_list( poi_array[x] );	
		}
		
	}
	
	poi_array = array_randomize( poi_array );
	
	while( !flag( "packapunch_hacked" ) )
	{
		
		for( i = 0; i < poi_array.size; i++ )
		{

			self remove_poi_from_ignore_list( poi_array[i] );
			
			self waittill_any_or_timeout( RandomIntRange( 2, 5 ), "goal", "bad_path" );
			
			self add_poi_to_ignore_list( poi_array[i] );
	
		}
		
		poi_array = array_randomize( poi_array );
		
	}
	
}

remove_ignore_on_poi( poi_array )
{
	self endon( "death" );
	
	level waittill( "stop_pack_poi" );
	
	for( i = 0; i < poi_array.size; i++ )
	{
		self remove_poi_from_ignore_list( poi_array[i] );
	}
	
	self._poi_pack_set = 0;
	
}

activate_zombieland_poi_positions(time)
{
	level endon("stop_pack_poi");

	pack_zombieland_poi = GetEntArray("zombieland_poi","targetname");
	
	for( i = 0; i < pack_zombieland_poi.size; i++ )
	{
		poi = pack_zombieland_poi[i];
		
		poi activate_zombie_point_of_interest();
	}
	
}	
watch_for_exit(poi_array)
{
	while(players_in_zombieland() && !flag("packapunch_hacked"))
	{
		wait(0.1);
	}
	
	level notify("stop_pack_poi");
	// DCS: deactivate point of interests
	for ( i = 0; i < poi_array.size; i++ )
	{
		poi_array[i] deactivate_zombie_point_of_interest();
	}
}	

// watch if any player exit during zombieland (bhb, etc.)	
players_in_zombieland()
{
	pack_enclosure = GetEnt("pack_enclosure","targetname");

	players = GET_PLAYERS();
	num_players_inside = 0;
	
	for( i=0; i<players.size; i++ )
	{
		if( players[i] istouching( pack_enclosure ) )
		{
			num_players_inside++;
		}
	}
	
	if(num_players_inside != players.size)
	{
		return false;
	}	
	return true;
}

// check for any zombies caught inside after gates close	
check_for_avoid_poi()
{
	if(is_true(self.in_pack_enclosure))
	{
		return true; 
	}
	return false; // will use poi
	
}
	
pack_gate_activate()
{
	time = 1; 
	
	self NotSolid();

	if(isDefined(self.script_vector))
	{
		self playsound( "amb_teleporter_gate_start" );
		self MoveTo( self.startpos + self.script_vector, time );
		
		self thread pack_gate_closed();

		flag_wait("packapunch_hacked");
		
		self NotSolid();
	
		if(self.classname == "script_brushmodel")
		{
			self ConnectPaths();
		}
		
		self playsound( "amb_teleporter_gate_start" );
		self MoveTo( self.startpos, time );
		
		self thread maps\mp\zombies\_zm_blockers::door_solid_thread();

	}
}

pack_gate_closed()
{
	self waittill("movedone" ); 

	self.door_moving = undefined;
	while( 1 )
	{
		players = GET_PLAYERS(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid();
			self DisconnectPaths();
			return; 
		}

		wait( 1 ); 
	}
}

moon_nml_bhb_present()
{
	self endon( "death" );
	
	nml_bhb = undefined;
	pack_zombieland_poi = GetEntArray("zombieland_poi","targetname");
	pack_enclosure = GetEnt("pack_enclosure","targetname");
	
	
	while( !flag( "packapunch_hacked" ) )
	{
		zombie_pois = GetEntArray( "zombie_poi", "script_noteworthy" );
		
		for( i = 0; i < zombie_pois.size; i++ )
		{
			if( IsDefined( zombie_pois[i].targetname ) && zombie_pois[i].targetname == "zm_bhb" )
			{
				if( moon_zmb_and_bhb_touching_trig( zombie_pois[i] ) )
				{
					nml_bhb = zombie_pois[i];	
					
					// make sure the zombie doesn't have it on their ignore list
					self remove_poi_from_ignore_list( nml_bhb );
				}
				else // this is for when the zmb and the bhb are seperated by a wall
				{
					self add_poi_to_ignore_list( zombie_pois[i] );
				}
			}
		}
		
		if( IsDefined( nml_bhb ) )
		{
			self notify( "nml_bhb" );
			
			// ignore all the other pois
			for( j = 0; j < pack_zombieland_poi.size; j++ )
			{
				self add_poi_to_ignore_list( pack_zombieland_poi[j] );
			}
			
		}
		else
		{
			wait( 0.1 );
			continue;
		}
		
		while( IsDefined( nml_bhb ) ) // wait for the bhb to leave
		{
			wait( 0.1 );
		}
		
		// if the zombie is still alive then restart the gate function on them
		self thread switch_between_zland_poi();
		
		wait( 0.1 );
	}

	return false; // there are no bhbs present
}

moon_zmb_and_bhb_touching_trig( ent_bhb )
{
	self endon( "death" );
	
	if( !IsDefined( ent_bhb ) )
	{
		return false;
	}
	
	pack_trig = GetEnt("pack_enclosure","targetname");
	
	if( self IsTouching( pack_trig ) && IsDefined( ent_bhb ) && ent_bhb IsTouching( pack_trig ) )
	{
		return true; // both zmb and bhb are inside the pack room
	}
	else if( !self IsTouching( pack_trig ) && IsDefined( ent_bhb ) && !ent_bhb IsTouching( pack_trig ) )
	{
		return true; // both zmb and bhb are outside the pack room
	}
	
	return false; // if the zmb is not where the bhb is then they shouldn't care about it
	
}

moon_zombieland_ignore_poi()
{
	self endon( "death" );
	
	nml_poi_array = GetEntArray("zombieland_poi","targetname");
	
	if( is_true( self._zmbl_ignore ) )
	{
		return;
	}
	
	self._zmbl_ignore = 1;
	
	for( i = 0; i < nml_poi_array.size; i++ )
	{
		self add_poi_to_ignore_list( nml_poi_array[i] );
	}
	
	while( !flag( "packapunch_hacked" ) )
	{
		// if a bhb is tossed while the gates are closed the ai needs to update depending on where it is
		bhb_bomb = GetEntArray( "zm_bhb", "targetname" );
		if( IsDefined( bhb_bomb ) )
		{
			for( w = 0; w < bhb_bomb.size; w++ )
			{
				if( !moon_zmb_and_bhb_touching_trig( bhb_bomb[w] ) ) // this returning false means the bhb is not in the same are and should be ignores
				{
					self add_poi_to_ignore_list( bhb_bomb[w] );	
				}
			}
		}
		wait( 0.1 );
	}
	
	for( x = 0; x < nml_poi_array.size; x++ )
	{
		self remove_poi_from_ignore_list( nml_poi_array[x] );
	}
	
	
}
// ------------------------------------------------------------------------------------------------
moon_sidequest_of_awesome()
{
	maps\mp\zm_moon_sq::init();
}

// ------------------------------------------------------------------------------------------------
//	Gravity changes from Area 51 to the moon
// ------------------------------------------------------------------------------------------------
zombie_moon_gravity_init()
{
	//SetGravity( 136 );	
}
zombie_earth_gravity_init()
{
	//SetGravity( 800 );	
}

// ------------------------------------------------------------------------------------------------
init_clientflags()
{
	level._CLIENTFLAG_SCRIPTMOVER_DIGGER_MOVING_EARTHQUAKE_RUMBLE = 0;
	level._CLIENTFLAG_SCRIPTMOVER_DIGGER_DIGGING_EARTHQUAKE_RUMBLE = 1;
	level._CLIENTFLAG_SCRIPTMOVER_DIGGER_ARM_FX = 2;
	level._CLIENTFLAG_SCRIPTMOVER_DOME_MALFUNCTION_PAD = 3;
	
	level._CLIENTFLAG_PLAYER_SKY_TRANSITION = 0;
	level._CLIENTFLAG_PLAYER_SOUL_SWAP = 1;
	level._CLIENTFLAG_PLAYER_GASP_RUMBLE = 2;
	
	level._CF_ACTOR_CLIENT_FLAG_CTT = 2;
		
}

// ------------------------------------------------------------------------------------------------
precache_items()
{
	flag_init("between_rounds");
	
	
	// viewmodel arms for the level
	PreCacheModel( "viewmodel_usa_pow_arms" ); // Dempsey
	PreCacheModel( "viewmodel_rus_prisoner_arms" ); // Nikolai
	PreCacheModel( "viewmodel_vtn_nva_standard_arms" );// Takeo
	PreCacheModel( "viewmodel_usa_hazmat_arms" );// Richtofen
			
	precachemodel("zombie_trap_switch_light_on_red");
	precachemodel("zombie_trap_switch_light_on_green");
	PreCacheShader("zom_icon_player_life");
	//precacheshellshock( "electrocution" );

	// spinning lights
	PreCacheModel( "p_rus_rb_lab_warning_light_01" );
	PreCacheModel( "p_rus_rb_lab_warning_light_01_off" );
	PreCacheModel( "p_rus_rb_lab_light_core_on" );
	PreCacheModel( "p_rus_rb_lab_light_core_off" );	
	
	PreCacheModel("p_zom_moon_lab_airlock_door01_right");
	PreCacheModel("p_zom_moon_lab_airlock_door01_left");	
	PreCacheModel("p_zom_moon_mine_airlock_door03_single");	
	
	//breachable glass
	PreCacheModel("p_zom_moon_re_glass_1_broken");
	PreCacheModel("p_zom_moon_re_glass_2_broken");
	PreCacheModel("p_zom_moon_re_glass_3_broken");
	PreCacheModel("p_zom_moon_re_glass_4_broken");
	PreCacheModel("p_zom_moon_lab_glass_top_broken");
	PreCacheModel("p_zom_moon_lab_glass_middle_broken");
	PreCacheModel("p_zom_moon_lab_glass_bottom_broken");
	
	//broken biodome piece
	PreCacheModel("p_zom_moon_biodome_hole_broken");
	
	//earth models
	PreCacheModel("P_zom_moon_earth");
	PreCacheModel("P_zom_moon_earth_dest");


}

//-------------------------------------------------------------------------------
// DCS: Vision set init and setup
//-------------------------------------------------------------------------------
vision_set_init()
{
	flag_wait( "start_zombie_round_logic" );
	
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
	//T6todo	players[i] VisionSetNaked("zombie_moonHanger18", 0.5);
	}	
}

//-------------------------------------------------------------------------------
// DCS 051011: special moon round think function to allow starting in No mans Land.
//-------------------------------------------------------------------------------
moon_round_think_func()
{
	for( ;; )
	{
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
		maxreward = 500;
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;

		level.pro_tips_start_time = GetTime();
		level.zombie_last_run_time = GetTime();	// Resets the last time a zombie ran
	
    level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_start" );
        
    if(level.moon_startmap == true)
    {
    	level.moon_startmap = false;
			level thread maps\mp\zombies\_zm::play_level_start_vox_delayed();
			wait(3); // time that would have been for round text and init spawning.
    }
    else
    {	    
			maps\mp\zombies\_zm::chalk_one_up();
		}

		players = GET_PLAYERS();
		array_thread( players, maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset );

		// only give grenades when not returning from NML.
		if(!flag("teleporter_used") || level.first_round == true)
		{
			level thread maps\mp\zombies\_zm::award_grenades_for_survivors();
		}
		
		bbPrint( "zombie_rounds: round %d player_count %d", level.round_number, players.size );

		level.round_start_time = GetTime();
		level thread [[level.round_spawn_func]]();

		level notify( "start_of_round" );

		// returning from earth: restore the zombie total if there were zombies remaining when you left
		if(flag("teleporter_used"))
		{
			flag_clear("teleporter_used");
			if ( level.prev_round_zombies != 0)
			{
				level.zombie_total = level.prev_round_zombies;
			}	
		}

		[[level.round_wait_func]]();
		
		if ( level.on_the_moon && ( !is_true( level._from_nml ) || level.first_round ) )
		{
			maps\mp\zombies\_zm_powerups::powerup_round_start();
		}

		level.first_round = false;
		level notify( "end_of_round" );
		flag_set("between_rounds");
		
		UploadStats();

		if(!flag("teleporter_used"))
		{
			level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_end" );

			if ( 1 != players.size )
			{
				level thread maps\mp\zombies\_zm::spectators_respawn();
			}
		}

		level maps\mp\zombies\_zm::chalk_round_over();

		// here's the difficulty increase over time area
		timer = level.zombie_vars["zombie_spawn_delay"];
		if ( timer > 0.08 )
		{
			level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
		}
		else if ( timer < 0.08 )
		{
			level.zombie_vars["zombie_spawn_delay"] = 0.08;
		}

		level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];

		// DCS 062811: if used teleporter to advance round stay at old round number.
		if(flag("teleporter_used"))
		{
			// restore the zombie total if there were zombies remaining when you left
			if ( level.prev_round_zombies != 0 && !flag("enter_nml") )
			{
				level.round_number = level.nml_last_round;	
			}
		}
		else
		{	
			level.round_number++;
		}

		level notify( "between_round_over" );
		flag_clear("between_rounds");
		
	}
}	

// ------------------------------------------------------------------------------------------------
// ZONE INIT
// ------------------------------------------------------------------------------------------------
moon_zone_init()
{
	flag_init( "always_on" );
	flag_set( "always_on" );


	// receiving airlocks
	add_adjacent_zone( "airlock_bridge_zone", "bridge_zone", "receiving_exit" );
	add_adjacent_zone( "airlock_bridge_zone", "water_zone", "receiving_exit" );
	add_adjacent_zone( "bridge_zone", "water_zone", "receiving_exit" );

	// west airlock from recieving
	add_adjacent_zone( "airlock_west_zone", "water_zone", "catacombs_west" );
	add_adjacent_zone( "airlock_west_zone", "cata_left_start_zone", "catacombs_west" );
	add_adjacent_zone( "water_zone", "cata_left_start_zone", "catacombs_west" );

	// single door (tunnel 6)
	add_adjacent_zone( "cata_left_start_zone", "cata_left_middle_zone", "tunnel_6_door1" );

	// east airlock from recieving
	add_adjacent_zone( "airlock_east_zone", "water_zone", "catacombs_east" );
	add_adjacent_zone( "airlock_east_zone", "cata_right_start_zone", "catacombs_east" );
	add_adjacent_zone( "cata_right_start_zone", "water_zone", "catacombs_east" );

	// airlock east to power
	add_adjacent_zone( "airlock_east2_zone", "generator_zone", "catacombs_east4" );
	add_adjacent_zone( "airlock_east2_zone", "cata_right_end_zone", "catacombs_east4" );

	// airlock west to power
	add_adjacent_zone( "airlock_west2_zone", "cata_left_middle_zone", "catacombs_west4" );
	add_adjacent_zone( "airlock_west2_zone", "generator_zone", "catacombs_west4" );

	// single doors (tunnel 11)
	add_adjacent_zone( "cata_right_start_zone", "cata_right_middle_zone", "tunnel_11_door1" );
	add_adjacent_zone( "cata_right_middle_zone", "cata_right_end_zone", "tunnel_11_door2" );

	// airlock power to labs
	add_adjacent_zone( "airlock_generator_zone", "generator_zone", "generator_exit_east" );
	add_adjacent_zone( "airlock_generator_zone", "generator_exit_east_zone", "generator_exit_east" );

	// airlock digsite to labs
	add_adjacent_zone( "airlock_digsite_zone", "enter_forest_east_zone", "exit_dig_east" );
	add_adjacent_zone( "airlock_digsite_zone", "tower_zone_east", "exit_dig_east" );
	add_zone_flags(	"exit_dig_east",									"digsite_group" );

	// airlock biodome to digsite
	add_adjacent_zone( "airlock_biodome_zone", "forest_zone", "forest_enter_digsite" );
	add_adjacent_zone( "airlock_biodome_zone", "tower_zone_east2", "forest_enter_digsite" );
	add_adjacent_zone( "forest_zone", "tower_zone_east2", "forest_enter_digsite" );
	add_zone_flags(	"forest_enter_digsite",									"digsite_group" );

	// digsite group always connected together
	add_adjacent_zone( "tower_zone_east", "tower_zone_east2", "digsite_group" );


	// airlock labs to biodome
	add_adjacent_zone( "airlock_labs_2_biodome", "enter_forest_east_zone", "enter_forest_east" );
	add_adjacent_zone( "airlock_labs_2_biodome", "forest_zone", "enter_forest_east" );

	
	// Door upper to lower labs
	add_adjacent_zone( "enter_forest_east_zone", "generator_exit_east_zone", "dig_enter_east" );

}
// ------------------------------------------------------------------------------------------------
// 
// ------------------------------------------------------------------------------------------------
init_strings()
{
	PrecacheString( &"ZOMBIE_PARIS_TRANSPORTER_WAITING" );
	PrecacheString( &"ZOMBIE_PARIS_TRANSPORTER_ACTIVATED" );
	PrecacheString( &"ZOMBIE_PARIS_TRANSPORTER_ABORTED" );
}

// ------------------------------------------------------------------------------------------------
anim_override_func()
{
//	level.scr_anim["zombie"]["walk3"] 	= %ai_zombie_walk_v2;	// DCS 030111: overwritten per bug # 76590
//	level.scr_anim["zombie"]["run6"] 	= %ai_zombie_run_v2;	
}

// ------------------------------------------------------------------------------------------------
// WEAPON FUNCTIONS
//
// Include the weapons that are only in your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
// Copy all include_weapon lines over to the level.csc file too - removing the weighting funcs...
// ------------------------------------------------------------------------------------------------
include_weapons()
{
	//Weapons - Pistols	
	include_weapon( "knife_zm", false );
	include_weapon( "frag_grenade_zm", false );
	include_weapon( "claymore_zm", false );
	include_weapon( "sticky_grenade_zm", false );

	//	Weapons - Pistols
	include_weapon( "m1911_zm", false );
	include_weapon( "m1911_upgraded_zm", false );
	include_weapon( "python_zm" );
	include_weapon( "python_upgraded_zm", false );
  	include_weapon( "cz75_zm" );
  	include_weapon( "cz75_upgraded_zm", false );

	//	Weapons - Semi-Auto Rifles
	include_weapon( "m14_zm", false );
	include_weapon( "m14_upgraded_zm", false );

	//	Weapons - Burst Rifles
	include_weapon( "m16_zm", false );						
	include_weapon( "m16_gl_upgraded_zm", false );
	include_weapon( "g11_lps_zm" );
	include_weapon( "g11_lps_upgraded_zm", false );
	include_weapon( "famas_zm" );
	include_weapon( "famas_upgraded_zm", false );

	//	Weapons - SMGs
	include_weapon( "ak74u_zm", false );
	include_weapon( "ak74u_upgraded_zm", false );
	include_weapon( "mp5k_zm", false );
	include_weapon( "mp5k_upgraded_zm", false );
	include_weapon( "mp40_zm", false );						
	include_weapon( "mp40_upgraded_zm", false );			
	include_weapon( "mpl_zm", false );
	include_weapon( "mpl_upgraded_zm", false );
	include_weapon( "pm63_zm", false );
	include_weapon( "pm63_upgraded_zm", false );
	include_weapon( "spectre_zm" );
	include_weapon( "spectre_upgraded_zm", false );

	//	Weapons - Dual Wield
  	include_weapon( "cz75dw_zm" );
  	include_weapon( "cz75dw_upgraded_zm", false );

	//	Weapons - Shotguns
	include_weapon( "ithaca_zm", false );
	include_weapon( "ithaca_upgraded_zm", false );
	include_weapon( "rottweil72_zm", false );
	include_weapon( "rottweil72_upgraded_zm", false );
	include_weapon( "spas_zm" );
	include_weapon( "spas_upgraded_zm", false );
	include_weapon( "hs10_zm" );
	include_weapon( "hs10_upgraded_zm", false );

	//	Weapons - Assault Rifles
	include_weapon( "aug_acog_zm" );
	include_weapon( "aug_acog_mk_upgraded_zm", false );
	include_weapon( "galil_zm" );
	include_weapon( "galil_upgraded_zm", false );
	include_weapon( "commando_zm" );
	include_weapon( "commando_upgraded_zm", false );
	include_weapon( "fnfal_zm" );
	include_weapon( "fnfal_upgraded_zm", false );

	//	Weapons - Sniper Rifles
	include_weapon( "dragunov_zm" );
	include_weapon( "dragunov_upgraded_zm", false );
	include_weapon( "l96a1_zm" );
	include_weapon( "l96a1_upgraded_zm", false );

	//	Weapons - Machineguns
	include_weapon( "rpk_zm" );
	include_weapon( "rpk_upgraded_zm", false );
	include_weapon( "hk21_zm" );
	include_weapon( "hk21_upgraded_zm", false );

	//	Weapons - Misc
	include_weapon( "m72_law_zm" );
	include_weapon( "m72_law_upgraded_zm", false );
	include_weapon( "china_lake_zm" );
	include_weapon( "china_lake_upgraded_zm", false );
	
	include_weapon( "minigun_zm" );

	////////////////////
	//Special grenades//
	////////////////////
//t6todo	include_weapon( "zombie_black_hole_bomb" );	
	include_weapon( "zombie_quantum_bomb" );

	///////////////////
	//Special weapons//
	///////////////////
	include_weapon( "ray_gun_zm" );
	include_weapon( "ray_gun_upgraded_zm", false );
	include_weapon( "crossbow_explosive_zm" );
	include_weapon( "crossbow_explosive_upgraded_zm", false );
	precacheItem( "explosive_bolt_zm" );
	precacheItem( "explosive_bolt_upgraded_zm" );
	include_weapon( "microwavegundw_zm" );
	include_weapon( "microwavegundw_upgraded_zm", false );

	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
	include_weapon( "knife_ballistic_bowie_zm", false );
	include_weapon( "knife_ballistic_bowie_upgraded_zm", false );
	level._uses_retrievable_ballisitic_knives = true;

	// limited weapons
	add_limited_weapon( "m1911_zm", 0 );
	add_limited_weapon( "crossbow_explosive_zm", 1 );
	add_limited_weapon( "knife_ballistic_zm", 1 );
	add_limited_weapon( "microwavegundw_zm", 1 );

	// get the bowie into the collector achievement list
//	ARRAY_ADD( level.collector_achievement_weapons, "bowie_knife_zm" );
}


//-------------------------------------------------------------------------------
giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
 	self giveWeapon( "knife_zm" );
	self give_start_weapon( true );
}
precacheCustomCharacters()
{
	//Precache characters
	character\c_usa_dempsey_zm::precache();// Dempsy
	character\c_rus_nikolai_zm::precache();// Nikolai
	character\c_jap_takeo_zm::precache();// Takeo
	character\c_ger_richtofen_zm::precache();// Richtofen
	
	PrecacheModel( "viewmodel_usa_pow_arms" );
	PrecacheModel( "viewmodel_rus_prisoner_arms" );
	PrecacheModel( "viewmodel_vtn_nva_standard_arms" );
	PrecacheModel( "viewmodel_usa_hazmat_arms" );
}

initCharacterStartIndex()
{
	level.characterStartIndex = RandomInt( 4 );
}

selectCharacterIndexToUse()
{
	if( level.characterStartIndex>=4 )
		level.characterStartIndex = 0;

	self.characterIndex = level.characterStartIndex;
	level.characterStartIndex++;
	
	return self.characterIndex;
}	

giveCustomCharacters()
{
	self DetachAll();
	switch( self selectCharacterIndexToUse() )
	{
		case 0:
		{
			//Dempsy
			self character\c_usa_dempsey_zm::main();
			self SetViewModel( "viewmodel_usa_pow_arms" );
			self.characterIndex = 0;
			break;
		}
		case 1:
		{
			//Nikolai
			self character\c_rus_nikolai_zm::main();
			self SetViewModel( "viewmodel_rus_prisoner_arms" );
			self.characterIndex = 1;
			break;
		}
		case 2:
		{
			//Takeo
			self character\c_jap_takeo_zm::main();
			self SetViewModel( "viewmodel_vtn_nva_standard_arms" );
			self.characterIndex = 2;
			break;
		}
		case 3:
		{	
			//Richtofen
			self character\c_ger_richtofen_zm::main();
			self SetViewModel( "viewmodel_usa_hazmat_arms" );
			self.characterIndex = 3;
			break;
		}
	}
	
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );
}
//-------------------------------------------------------------------------------


// ------------------------------------------------------------------------------------------------
//precache_player_model_override()
//{
//	mptype\player_t5_zm_moon::precache();
//}

/*give_player_model_override( entity_num )
{
	if(!IsDefined(level._override_num_chars_connected))
	{
		level._override_num_chars_connected = 0;
	}
	else
	{
		level._override_num_chars_connected ++;
	}
	
	if( IsDefined( self.zm_random_char ) )
	{
		entity_num = self.zm_random_char;
		self.entity_num = entity_num;
	}	
	//t6todo else if(level._override_num_chars_connected == (GetNumExpectedPlayers() -1 ) )
	{
		self.zm_random_char = 3;
		self.entity_num = 3;
		entity_num = 3;
	}
	else
	{
		self.zm_random_char = level._override_num_chars_connected;
		self.entity_num = level._override_num_chars_connected;
		entity_num = level._override_num_chars_connected;
	}
	
	switch( entity_num )
	{
		case 0:
			character\c_usa_dempsey_zm::precache();// Dempsy
			break;
		case 1:
			character\c_rus_nikolai_zm::precache();// Nikolai
			break;
		case 2:
			character\c_jap_takeo_zm::precache();// Takeo
			break;
		case 3:
			character\c_ger_richtofen_zm::precache();// Richtofen
			break;	
	}
	
	level._num_overriden_models ++;
}*/

/*player_set_viewmodel_override( entity_num )
{
	if(isDefined(self.zm_random_char))
	{
		entity_num = self.zm_random_char;
	}
	else
	{
		entity_num = self.entity_num;
	}

	switch( entity_num )
	{
		case 0:
			// Dempsey
			self SetViewModel( "viewmodel_usa_pow_arms" );
			break;
		case 1:
			// Nikolai
			self SetViewModel( "viewmodel_rus_prisoner_arms" );
			break;
		case 2:
			// Takeo
			self SetViewModel( "viewmodel_vtn_nva_standard_arms" );
			break;
		case 3:
			// Richtofen
			self SetViewModel( "viewmodel_usa_hazmat_arms" );
			break;		
	}
}*/

gasmask_get_head_model( entity_num, gasmask_active )
{
	if ( gasmask_active )
	{
		return "c_zom_moon_pressure_suit_helm";
	}

	switch ( entity_num )
	{
		case 0:
			return "c_usa_dempsey_dlc5_head";
		case 1:
			return "c_rus_nikolai_dlc5_head_psuit";
		case 2:
			return "c_jap_takeo_dlc5_head";
		case 3:
			return "c_ger_richtofen_dlc5_head";
	}
}

gasmask_change_player_headmodel( entity_num, gasmask_active )
{
	if(isDefined(self.headModel))
	{
		self Detach( self.headModel, "" );
	}
	self.headModel = gasmask_get_head_model( entity_num, gasmask_active );
	self Attach( self.headModel, "", true );
}

gasmask_set_player_model( entity_num )
{
	player_is_nikolai = false;
	if ( 1 == entity_num )
	{
		player_is_nikolai = true;
		self Detach( self.headModel, "" );
	}

	self setModel( "c_zom_moon_pressure_suit_body_player" );

	if ( player_is_nikolai )
	{
		self.headModel = gasmask_get_head_model( entity_num, false );
		self Attach( self.headModel, "", true );
	}
}

gasmask_set_player_viewmodel( entity_num )
{
	self SetViewModel( "viewmodel_zom_pressure_suit_arms" );
	self clientnotify( "gmsk" );
}


gasmask_reset_player_model( entity_num )
{
	if( IsDefined( self.zm_random_char ) )
	{
		entity_num = self.zm_random_char;
	}

	self Detach(self.headModel, "");

	switch( entity_num )
	{
		case 0:
			self character\c_usa_dempsey_zm::main();
			break;
		case 1:
			self character\c_rus_nikolai_zm::main();
			break;
		case 2:
			self character\c_jap_takeo_zm::main();
			break;
		case 3:
			self character\c_ger_richtofen_zm::main();
			break;	
	}
}

gasmask_reset_player_set_viewmodel( entity_num )
{
	if( IsDefined( self.zm_random_char ) )
	{
		entity_num = self.zm_random_char;
	}
	
	switch( self.entity_num )
	{
		case 0:
			// Dempsey
			self SetViewModel( "viewmodel_usa_pow_arms" );
			self clientnotify( "gmsk" );
			break;
		case 1:
			// Nikolai
			self SetViewModel( "viewmodel_rus_prisoner_arms" );
			self clientnotify( "gmsk" );
			break;
		case 2:
			// Takeo
			self SetViewModel( "viewmodel_vtn_nva_standard_arms" );
			self clientnotify( "gmsk" );
			break;
		case 3:
			// Richtofen
			self SetViewModel( "viewmodel_usa_hazmat_arms" );
			self clientnotify( "gmsk" );
			break;		
	}
}
// -- Offhand weapon override for cosmodrome
moon_offhand_weapon_overrride()
{
	register_lethal_grenade_for_level( "frag_grenade_zm" );
	register_lethal_grenade_for_level( "sticky_grenade_zm" );
	level.zombie_lethal_grenade_player_init = "frag_grenade_zm";

//t6todo	register_tactical_grenade_for_level( "zombie_black_hole_bomb" );
	level.zombie_tactical_grenade_player_init = undefined;
	register_tactical_grenade_for_level( "zombie_quantum_bomb" );

	register_placeable_mine_for_level( "claymore_zm" );
	level.zombie_placeable_mine_player_init = undefined;

	register_melee_weapon_for_level( "knife_zm" );
	register_melee_weapon_for_level( "bowie_knife_zm" );
	level.zombie_melee_weapon_player_init = "knife_zm";

	register_equipment_for_level( "equip_gasmask_zm" );
	register_equipment_for_level( "equip_hacker_zm" );
	level.zombie_equipment_player_init = undefined;
}

// -- gives the player a black hole bomb when it comes out of the box
offhand_weapon_give_override( str_weapon )
{
	self endon( "death" );
	
	if( is_tactical_grenade( str_weapon ) && IsDefined( self get_player_tactical_grenade() ) && !self is_player_tactical_grenade( str_weapon ) )
	{
		self SetWeaponAmmoClip( self get_player_tactical_grenade(), 0 );
		self TakeWeapon( self get_player_tactical_grenade() );
	}
	
//t6todo	if( str_weapon == "zombie_black_hole_bomb" )
//t6todo	{
//t6todo		self maps\mp\zombies\_zm_weap_black_hole_bomb::player_give_black_hole_bomb();
//t6todo		//self maps\mp\zombies\_zm_weapons::play_weapon_vo( str_weapon ); // ww: need to figure out how we will get the sound here
//t6todo		return true;
//t6todo	}
	
	if( str_weapon == "zombie_quantum_bomb" )
	{
		self maps\mp\zombies\_zm_weap_quantum_bomb::player_give_quantum_bomb();
		// play vo here
		return true;
	}

	return false;
}

// ------------------------------------------------------------------------------------------------
// POWERUP FUNCTIONS
// ------------------------------------------------------------------------------------------------
include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
	include_powerup( "carpenter" );
	include_powerup( "fire_sale" );
	
	// WW (02-04-11): Added minigun
//t6todo	PreCacheItem( "minigun_zm" );
//t6todo	include_powerup( "minigun" );
	
	include_powerup( "free_perk" );

	// for quantum bomb
	include_powerup( "random_weapon" );
	include_powerup( "bonus_points_player" );
	include_powerup( "bonus_points_team" );
	include_powerup( "lose_points_team" );
	include_powerup( "lose_perk" );
	include_powerup( "empty_clip" );
}

include_equipment_for_level()
{
	include_equipment( "equip_gasmask_zm" );
	include_equipment( "equip_hacker_zm" );
}
// ------------------------------------------------------------------------------------------------
// AUDIO
// ------------------------------------------------------------------------------------------------
init_sounds()
{
//	maps\mp\zombies\_zm_utility::add_sound( "break_stone", "break_stone" );
}

// ------------------------------------------------------------------------------------------------
// ELECTRIC SWITCH
// once this is used, it activates other objects in the map
// and makes them available to use
// ------------------------------------------------------------------------------------------------
electric_switch()
{
	trig = getent("use_elec_switch","targetname");
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	trig setcursorhint( "HINT_NOICON" );

	level thread wait_for_power();

	trig thread maps\mp\zombies\_zm_perks::vending_machine_trigger_think();

	trig waittill("trigger",user);

	if(IsDefined(trig))
	{
		trig delete();
	}
			
	flag_set( "power_on" );
	//Objective_State(8,"done");
	
	user thread delayed_poweron_vox();
}

delayed_poweron_vox()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	wait(11.5);
	if( isdefined( self ) )
	{
		self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "poweron" );
	}
}

wait_for_power()
{
	master_switch = getent("elec_switch","targetname");	
	master_switch notsolid();

	flag_wait( "power_on" );

	master_switch rotateroll(-90,.3);
	master_switch playsound("zmb_switch_flip");

	// Set Perk Machine Notifys
	level notify("revive_on");
	wait_network_frame();
	level notify("doubletap_on");
	wait_network_frame();
	level notify("divetonuke_on");
	wait_network_frame();
	level notify("marathon_on");
	wait_network_frame();
	level notify("deadshot_on");
	wait_network_frame();
	level notify("additionalprimaryweapon_on");
	wait_network_frame();

	// Set Electric Door Notify
	level notify("electric_door");

	clientnotify("ZPO");	 // Zombie Power On.
	
	master_switch waittill("rotatedone");
	playfx(level._effect["switch_sparks"] ,getstruct("elec_switch_fx","targetname").origin);

	master_switch playsound("zmb_turn_on");
}

// ------------------------------------------------------------------------------------------------
moon_devgui( cmd )
{
/#
	cmd_strings = strTok(cmd, " ");
	switch( cmd_strings[0] )
	{
		case "power":
			trigger = GetEnt( "use_elec_switch", "targetname" );

			if ( !IsDefined( trigger ) )
			{
				return;
			}

			iprintln( "Activating power" );
			trigger notify( "trigger", GET_PLAYERS()[0] );
			break;

		case "warp_nml":
			players = GET_PLAYERS();
			teleporter = GetEnt( "generator_teleporter", "targetname" );

			for ( i = 0; i < players.size; i++ )
			{
				players[i] SetOrigin( teleporter.origin );
			}
			break;
			
		case "digger_hangar":		
			maps\mp\zm_moon_digger::digger_activate("hangar");
			break;
			
		case "digger_teleporter":
			maps\mp\zm_moon_digger::digger_activate("teleporter");
			break;
			
		case "digger_biodome":
			maps\mp\zm_moon_digger::digger_activate("biodome");
			break;

		case "digger_speed":
			level.digger_speed_multiplier = GetDvarfloat("scr_moon_digger_speed");
			iprintlnbold(level.digger_speed_multiplier);
			break;
			
		case "spawn":
			player = GET_PLAYERS()[0];
			spawnerClass = cmd_strings[1];

			//Spawn AI
			//--------
			spawners = getEntArray(spawnerClass, "classname");
			if(!isDefined(spawners) || spawners.size == 0 )
			{
				return;
			}
			
			//Need to make sure we grabbed a spawner and not a live ai
			spawnerNum=0;
			while(spawners[spawnerNum].spawnflags%2 == 0)
			{
				spawnerNum++;
			}
			//Didn't find a valid spawner
			if(spawnerNum>=spawners.size)
			{
				return;
			}
			
			spawner = spawners[spawnerNum];
			guy =  undefined; //t6todo spawner maps\mp\zombies\_zm_ai_astro::astro_zombie_spawn();
			
			
			/*
			guy = spawner CodespawnerForceSpawn();
			guy.favoriteEnemy = player;
			guy.script_string = "zombie_chaser";
			guy.target = "";
			spawner.count++;
			*/
			
			//Trace to find where the player is looking
			//-----------------------------------------
			direction = player GetPlayerAngles();
			direction_vec = AnglesToForward( direction );
			eye = player GetEye();

			scale = 8000;
			direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
			trace = bullettrace( eye, eye + direction_vec, 0, undefined );
			
			originOffset = (0,0,0);

			//Teleport to where the player is looking
			//---------------------------------------
			if(isdefined(guy))
			{
				teleportOrigin = trace["position"] + originOffset;
				guy forceteleport(teleportOrigin, player.angles + (0,180,0));	
			}
			
			break;
		
	}
#/
}

// ------------------------------------------------------------------------------------------------
custom_add_weapons()
{
	add_zombie_weapon( "m1911_zm",					"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "python_zm",					"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				50,		"pistol",			"",		undefined );

	//SMGs
	add_zombie_weapon( "ak74u_zm",					"ak74u_upgraded_zm",					&"ZOMBIE_WEAPON_AK74U",					1200,	"smg",				"",		undefined );
	add_zombie_weapon( "mp5k_zm",					"mp5k_upgraded_zm",						&"ZOMBIE_WEAPON_MP5K",					1000,	"smg",				"",		undefined );

	//Shotguns
	add_zombie_weapon( "spas_zm",					"spas_upgraded_zm",						&"ZOMBIE_WEAPON_SPAS",					50,		"shotgun",			"",		undefined );
	add_zombie_weapon( "rottweil72_zm",				"rottweil72_upgraded_zm",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,	"shotgun",			"",		undefined );

	//Rifles
	add_zombie_weapon( "m14_zm",					"m14_upgraded_zm",						&"ZOMBIE_WEAPON_M14",					500,	"rifle",			"",		undefined );
	add_zombie_weapon( "m16_zm",					"m16_gl_upgraded_zm",					&"ZOMBIE_WEAPON_M16",					1200,	"burstrifle",		"",		undefined );
	add_zombie_weapon( "galil_zm",					"galil_upgraded_zm",					&"ZOMBIE_WEAPON_GALIL",					50,		"assault",			"",		undefined );
	add_zombie_weapon( "fnfal_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					50,		"burstrifle",		"",		undefined );

	//Grenades                                         		
	add_zombie_weapon( "frag_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			250,	"grenade",			"",		undefined );
	add_zombie_weapon( "sticky_grenade_zm", 		undefined,								&"ZOMBIE_WEAPON_STICKY_GRENADE",		250,	"grenade",			"",		undefined );
	add_zombie_weapon( "claymore_zm", 				undefined,								&"ZOMBIE_WEAPON_CLAYMORE",				1000,	"grenade",			"",		undefined );


	//Special                                          	
 	add_zombie_weapon( "zombie_cymbal_monkey",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"monkey",			"",		undefined );

 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );
 	add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );

	add_zombie_weapon( "cz75_zm",					"cz75_upgraded_zm",						&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );

	//SMGs
	add_zombie_weapon( "mp40_zm",					"mp40_upgraded_zm",						&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "mpl_zm",					"mpl_upgraded_zm",						&"ZOMBIE_WEAPON_MPL",					1000,	"smg",				"",		undefined );
	add_zombie_weapon( "pm63_zm",					"pm63_upgraded_zm",						&"ZOMBIE_WEAPON_PM63",					1000,	"smg",				"",		undefined );
	add_zombie_weapon( "spectre_zm",				"spectre_upgraded_zm",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );

	//Dual Wield
	add_zombie_weapon( "cz75dw_zm",					"cz75dw_upgraded_zm",					&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

	//Shotguns
	add_zombie_weapon( "ithaca_zm",					"ithaca_upgraded_zm",					&"ZOMBIE_WEAPON_ITHACA",				1500,	"shotgun",			"",		undefined );
	add_zombie_weapon( "hs10_zm",					"hs10_upgraded_zm",						&"ZOMBIE_WEAPON_HS10",					50,		"shotgun",			"",		undefined );

	//Burst Rifles
	add_zombie_weapon( "g11_lps_zm",				"g11_lps_upgraded_zm",					&"ZOMBIE_WEAPON_G11",					900,	"burstrifle",		"",		undefined );
	add_zombie_weapon( "famas_zm",					"famas_upgraded_zm",					&"ZOMBIE_WEAPON_FAMAS",					50,		"burstrifle",		"",		undefined );

	//Assault Rifles
	add_zombie_weapon( "aug_acog_zm",				"aug_acog_mk_upgraded_zm",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
	add_zombie_weapon( "commando_zm",				"commando_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );

	//Sniper Rifles
	add_zombie_weapon( "dragunov_zm",				"dragunov_upgraded_zm",					&"ZOMBIE_WEAPON_DRAGUNOV",				2500,	"sniper",			"",		undefined );
	add_zombie_weapon( "l96a1_zm",					"l96a1_upgraded_zm",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );

	//Machineguns
	add_zombie_weapon( "rpk_zm",					"rpk_upgraded_zm",						&"ZOMBIE_WEAPON_RPK",					4000,	"mg",				"",		undefined );
	add_zombie_weapon( "hk21_zm",					"hk21_upgraded_zm",						&"ZOMBIE_WEAPON_HK21",					50,		"mg",				"",		undefined );

	//Rocket Launchers
	add_zombie_weapon( "m72_law_zm", 				"m72_law_upgraded_zm",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined ); 
	add_zombie_weapon( "china_lake_zm", 			"china_lake_upgraded_zm",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined ); 

 	add_zombie_weapon( "zombie_black_hole_bomb",	undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"gersh",			"",		undefined );
	add_zombie_weapon( "zombie_quantum_bomb",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"quantum",			"",		undefined );

	add_zombie_weapon( "microwavegundw_zm",			"microwavegundw_upgraded_zm",			&"ZOMBIE_WEAPON_MICROWAVEGUN_DW", 		10,		"microwave",		"",		undefined );
}

moon_zombie_death_response()
{
	self StartRagdoll();

	rag_x = RandomIntRange( -50, 50 );
	rag_y = RandomIntRange( -50, 50 );
	rag_z = RandomIntRange( 25, 45 );

	force_min = 75;
	force_max = 100;

	if ( self.damagemod == "MOD_MELEE" )
	{
		force_min = 40;
		force_max = 50;
		rag_z = 15;
	}
	else if ( self.damageweapon == "m1911_zm" )
	{
		force_min = 60;
		force_max = 75;
		rag_z = 20;
	}
	else if ( self.damageweapon == "ithaca_zm" || self.damageweapon == "ithaca_upgraded_zm" ||
			  self.damageweapon == "rottweil72_zm" || self.damageweapon == "rottweil72_upgraded_zm" ||
			  self.damageweapon == "spas_zm" || self.damageweapon == "spas_upgraded_zm" ||
			  self.damageweapon == "hs10_zm" || self.damageweapon == "hs10_upgraded_zm" )
	{
		force_min = 100;
		force_max = 150;
	}

	scale = RandomIntRange( force_min, force_max );

	rag_x = self.damagedir[0] * scale;
	rag_y = self.damagedir[1] * scale;

	dir = ( rag_x, rag_y, rag_z );
	self LaunchRagdoll( dir );

	return false;
}
// ------------------------------------------------------------------------------------------------
// Necessary for water to slow player.
// ------------------------------------------------------------------------------------------------
setup_water_physics()
{
	flag_wait( "start_zombie_round_logic" );
	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
  {
//t6todo		players[i] SetClientDvars("phys_buoyancy",1);
	}
}
// ------------------------------------------------------------------------------------------------
// DCS 070511: adding death trigger when fall from cliff, per Jimmy.
//	instant spectate, no chance for revive.
// ------------------------------------------------------------------------------------------------
cliff_fall_death()
{
	trig = GetEnt("cliff_fall_death", "targetname");
	if(IsDefined(trig))
	{
		while(true)
		{
			trig waittill("trigger", who);	
			if(!is_true(who.insta_killed))
			{		
				who thread insta_kill_player();
			}
		}
	}	
}	

insta_kill_player()
{
	self endon("disconnect");
	
	if(is_true(self.insta_killed))
	{
		return;
	}	
	
	if(is_player_killable(self))
	{
		self.insta_killed = true;
		in_last_stand = false;
		if( self maps\mp\zombies\_zm_laststand::player_is_in_laststand()  )
		{
			in_last_stand = true;
		}
		
		//if solo then the player dies if jumps off while alive and no quick revive
		// - respawns on hacker side if both diggers are breached
		// - respawns in receiving area otherwise
		if(flag("solo_game")) 
		{			
			if(isDefined(self.lives) && self.lives > 0)
			{
				self.waiting_to_revive = true; //to bypass the normal respawn logic
			
				if(flag("both_tunnels_breached"))
				{
					point = moon_digger_respawn(self);
							
					if(!isDefined(point))
					{
						points = getstruct("bridge_zone","script_noteworthy");
						spawn_points = getstructarray(points.target,"targetname");
						num = self.characterindex;// getentitynumber();						
						point = spawn_points[num];
					}	
				}
				else
				{
					points = getstruct("bridge_zone","script_noteworthy");
					spawn_points = getstructarray(points.target,"targetname");
					num = self.characterindex;// getentitynumber();						
					point = spawn_points[num];
				}
				self dodamage(self.health + 1000,(0,0,0));
				wait(1.5); //enough time to give the player some feedback about the death
				self setorigin(point.origin + (0,0,20));
				self.angles = point.angles;	
				if(in_last_stand)
				{
					flag_set("instant_revive");
					wait_network_frame();
					flag_clear("instant_revive");
				}
				else
				{
					self thread maps\mp\zombies\_zm_laststand::auto_revive( self );
					self.waiting_to_revive = false;
					self.solo_respawn = 0;
					self.lives = 0;
				}				
			}
			else
			{
				self dodamage(self.health + 1000,(0,0,0)); //just kill him in solo mode
			}
		}
		else //in a coop match the player will die and go to spectate and then respawn on hacker side
 		{
 			self dodamage(self.health + 1000,(0,0,0));
 			wait_network_frame();
 			self.bleedout_time = 0;
 		}
		self.insta_killed = false;				
	}	
}

moon_respawn_override(player)
{
	if(flag("both_tunnels_breached"))
	{
		point = moon_digger_respawn(player);
		if(isDefined(point))
		{
			self notify( "one_giant_leap" );
			return point.origin;
		}
	}
	else 
	{
		return undefined;
	}
	
	return undefined;
	
}


is_player_killable( player, checkIgnoreMeFlag )
{
	if( !IsDefined( player ) ) 
	{
		return false; 
	}

	if( !IsAlive( player ) )
	{
		return false; 
	} 

	if( !IsPlayer( player ) )
	{
		return false;
	}

	if( player.sessionstate == "spectator" )
	{
		return false; 
	}

	if( player.sessionstate == "intermission" )
	{
		return false; 
	}

//T6todo	if ( player isnotarget() )
//T6todo	{
//T6todo		return false;
//T6todo	}
	
	//We only want to check this from the zombie attack script
	if( isdefined(checkIgnoreMeFlag) && player.ignoreme )
	{
		//IPrintLnBold(" ignore me ");
		return false;
	}
	
	return true; 
}

moon_digger_respawn(revivee)
{
	spawn_points = getstructarray( "player_respawn_point", "targetname" );

	if( level.zones[ "airlock_west2_zone" ].is_enabled )
	{
		for ( i = 0; i < spawn_points.size; i++ )
		{
			if ( spawn_points[i].script_noteworthy == "airlock_west2_zone" )
			{
				spawn_array = getstructarray( spawn_points[i].target, "targetname" );
				for ( j = 0; j < spawn_array.size; j++ )
				{
					if ( spawn_array[j].script_int == ( revivee.entity_num + 1 ) )
					{
						return spawn_array[j];
					}
				}
				return spawn_array[0];
			}
		}
	}
	else if( level.zones[ "airlock_east2_zone" ].is_enabled )
	{
		for ( i = 0; i < spawn_points.size; i++ )
		{
			if ( spawn_points[i].script_noteworthy == "airlock_east2_zone" )
			{
				spawn_array = getstructarray( spawn_points[i].target, "targetname" );
				for ( j = 0; j < spawn_array.size; j++ )
				{
					if ( spawn_array[j].script_int == ( revivee.entity_num + 1 ) )
					{
						return spawn_array[j];
					}
				}
				return spawn_array[0];
			}
		}
	}	

	return undefined;
}

moon_reset_respawn_overide()
{
	level waittill( "between_round_over" );
	level.check_valid_spawn_override = undefined;
}	
/*------------------------------------
extra blackhole bomb anims for non standard AI types
------------------------------------*/
init_extra_blackhole_anims()
{
/* t6todo	level.scr_anim["quad_zombie"]["slow_pull_1"] 	= %ai_zombie_quad_blackhole_crawl_slow_v1;
	level.scr_anim["quad_zombie"]["slow_pull_2"] 	= %ai_zombie_quad_blackhole_crawl_slow_v2;
	level.scr_anim["quad_zombie"]["slow_pull_3"] 	= %ai_zombie_quad_blackhole_crawl_slow_v1;
	
	
	level.scr_anim["quad_zombie"]["fast_pull_1"] 	= %ai_zombie_quad_blackhole_crawl_fast_v1;
	level.scr_anim["quad_zombie"]["fast_pull_2"] 	= %ai_zombie_quad_blackhole_crawl_fast_v2;
	level.scr_anim["quad_zombie"]["fast_pull_3"] 	= %ai_zombie_quad_blackhole_crawl_fast_v2;

	
	// all deaths have a "bhb_burst" notetrack for when the anim finishes playing, 
	// this is one of the ways to decide if the zombie is ready for soul burst
	level.scr_anim["quad_zombie"]["black_hole_death_1"] 	= %ai_zombie_quad_blackhole_death_v1;
	level.scr_anim["quad_zombie"]["black_hole_death_2"] 	= %ai_zombie_quad_blackhole_death_v2;
	level.scr_anim["quad_zombie"]["black_hole_death_3"] 	= %ai_zombie_quad_blackhole_death_v2;
	
	
	// death anims for zombies killed while be attracted
	level.scr_anim[ "quad_zombie" ][ "attracted_death_1" ] = %ai_zombie_quad_blackhole_death_preburst_v1;
	level.scr_anim[ "quad_zombie" ][ "attracted_death_2" ] = %ai_zombie_quad_blackhole_death_preburst_v2;
	level.scr_anim[ "quad_zombie" ][ "attracted_death_3" ] = %ai_zombie_quad_blackhole_death_preburst_v1;
	level.scr_anim[ "quad_zombie" ][ "attracted_death_4" ] = %ai_zombie_quad_blackhole_death_preburst_v2;
	
	
	level.scr_anim["quad_zombie"]["crawler_slow_pull_1"] 	= %ai_zombie_quad_blackhole_crawl_slow_v1;
	level.scr_anim["quad_zombie"]["crawler_slow_pull_2"] 	= %ai_zombie_quad_blackhole_crawl_slow_v2;


	
	level.scr_anim["quad_zombie"]["crawler_fast_pull_1"] 	= %ai_zombie_quad_blackhole_crawl_fast_v1;
	level.scr_anim["quad_zombie"]["crawler_fast_pull_2"] 	= %ai_zombie_quad_blackhole_crawl_fast_v2;
	level.scr_anim["quad_zombie"]["crawler_fast_pull_3"] 	= %ai_zombie_quad_blackhole_crawl_fast_v2;
	
	level.scr_anim["quad_zombie"]["crawler_black_hole_death_1"]	=%ai_zombie_quad_blackhole_death_v1;
	level.scr_anim["quad_zombie"]["crawler_black_hole_death_2"]	=%ai_zombie_quad_blackhole_death_v2;
	level.scr_anim["quad_zombie"]["crawler_black_hole_death_3"]	=%ai_zombie_quad_blackhole_death_v2;
	*/
}


blackhole_bomb_area_check()
{
	black_hole_teleport_structs = undefined;
	
	org = spawn("script_origin",(0,0,0));
		
	if(flag("enter_nml"))
	{
		black_hole_teleport_structs = getstructarray("struct_black_hole_teleport_nml","targetname");
	}
	else if(flag("both_tunnels_blocked"))
	{
		black_hole_teleport_structs = getstructarray("struct_black_hole_teleport","targetname");
		
		// if the players are behind the breach..and no hacker tools...then they get teleported to the hacker tool side
		all_players_trapped = false;
		
		final_structs = black_hole_teleport_structs;
		discarded_zones = [];		
		
		all_players = GET_PLAYERS();
		all_zones = getentarray("player_volume","script_noteworthy");
		players_touching = 0;
		
		
		for(x=0;x<all_zones.size;x++)
		{
			switch (all_zones[x].targetname)
			{
				case "water_zone": 
				case "cata_right_start_zone":
				case "airlock_east_zone":
				case "airlock_bridge_zone":
				case "bridge_zone":
				case "airlock_west_zone":
				case "cata_left_start_zone":
				case "cata_left_middle_zone":
				//case "nml_zone":				
				
				discarded_zones[discarded_zones.size] = all_zones[x];
				
				for(i=0;i<all_players.size;i++)
				{
					player = all_players[i];	
					equipment = player get_player_equipment();
					if(isDefined(equipment) && equipment == "equip_hacker_zm")
					{
						org delete();
						return black_hole_teleport_structs;
					}
					else
					{
						if( player istouching(all_zones[x]) )
						{
							players_touching++;
						}
					}
				}

				break;
					
				default:	
					break;
			}
		}
						
		if(players_touching == all_players.size)
		{
			all_players_trapped = true;
		}		
		
		if(all_players_trapped) //now we need to discard any blackhole teleport structs that are within the 'trapped' area
		{
			for(i=0;i<black_hole_teleport_structs.size;i++)
			{
				for(x = 0;x<discarded_zones.size;x++)
				{
					org.origin = black_hole_teleport_structs[i].origin;
					if(org istouching(discarded_zones[x]))
					{
						final_structs = array_remove(final_structs,black_hole_teleport_structs[i]);
					}
				}
			}
			black_hole_teleport_structs = final_structs;
		}
		else //tunnels are breached but the players are not trapped behind the breach
		{
			black_hole_teleport_structs = getstructarray( "struct_black_hole_teleport", "targetname" );
		}
	}	
	else
	{
		black_hole_teleport_structs = getstructarray( "struct_black_hole_teleport", "targetname" );	
	}
	
	org delete();
	return black_hole_teleport_structs;
		
}


get_blackholebomb_destination_point(black_hole_teleport_structs,ent_player)
{
	
	player_zones = getentarray("player_volume","script_noteworthy");
	valid_struct = undefined;
	scr_org = undefined;
	for( x = 0; x < black_hole_teleport_structs.size; x++ )
	{
		if(!isDefined(scr_org))
		{
			scr_org = spawn( "script_origin", black_hole_teleport_structs[x].origin+(0, 0, 40) );
		}
		else
		{
			scr_org.origin = black_hole_teleport_structs[x].origin+(0, 0, 40);
		}
		
		for( i = 0; i < player_zones.size; i++ )
		{
			if( scr_org isTouching( player_zones[i] ) )
			{
				if( isDefined( level.zones[player_zones[i].targetname] ) && is_true( level.zones[player_zones[i].targetname].is_enabled ) )
				{
					if(flag("enter_nml"))
					{
						valid_struct = black_hole_teleport_structs[x];
						scr_org delete();
						return valid_struct;
					}
					else if(ent_player get_current_zone() !=player_zones[i].targetname)
					{
						valid_struct = black_hole_teleport_structs[x];
						scr_org delete();
						return valid_struct;
					}
				}
			}
		}
	}
}

blackhole_bomb_in_invalid_area(grenade, model, player )
{
	invalid_area = getent("bhb_invalid_area","targetname");
	if(model istouching(invalid_area))
	{
//t6todo		level thread maps\mp\zombies\_zm_weap_black_hole_bomb::black_hole_bomb_stolen_by_sam( player, model );				
		return true;
	}
	else
	{
		return false;
	}
	
}


quantum_bomb_prevent_player_getting_teleported_override( position )
{
	if ( is_true( self._padded ) )
	{
		return true;
	}

	return false;
}

wait_for_end_game()
{
	level waittill("intermission");
	level clientnotify("EDR");
}

moon_perk_lost( perk )
{
	self maps\mp\zombies\_zm_perks::update_perk_hud();
}

moon_black_hole_bomb_poi()
{
	astro = getent( "astronaut_zombie_ai", "targetname" );

	if ( isdefined( astro ) )
	{
		astro add_poi_to_ignore_list( self );
	}
}

// Waits for the "end_game" notify then lets client scripts know to set the proper vision and fog
end_game_vision_and_fog_fix()
{
	level waittill( "end_game" );
	
	clientnotify( "ZEG" );
}

// makes sure that zombies only pay attention to a black hole bomb if one is deployed
// any undefined return allows the spawner system to use the old way to figure out pois
moon_bhb_poi_control()
{
	self endon( "death" );
	
	// grab all pois
	moon_pois = GetEntArray( "zombie_poi", "script_noteworthy" );
	pack_enclosure = GetEnt("pack_enclosure","targetname"); // zombieland trigger
	
	if( !IsDefined( moon_pois ) || moon_pois.size == 0 )
	{
		return undefined;
	}
	
	for( i = 0; i < moon_pois.size; i++ )
	{
		if( IsDefined( moon_pois[i].targetname ) && moon_pois[i].targetname == "zm_bhb" )
		{
			if( !flag( "packapunch_hacked" ) )
			{
				return undefined;
			}
			else // zombieland cage is not up so pay attention to the bhb
			{
				self._bhb_pull = 1;
				
				bhb_position = self moon_bhb_choice( moon_pois[i] );
				
				return bhb_position;
				
			}
		}
	}
	
	self._bhb_pull = 0;
	return undefined;
	
	
}

moon_bhb_choice( ent_poi )
{
	bhb_position = [];
	bhb_position[0] = groundpos( ent_poi.origin + (0, 0, 100) );
	bhb_position[1] = self;

	
	if( IsDefined( ent_poi.initial_attract_func ) )
	{
		self thread [[ ent_poi.initial_attract_func ]]( ent_poi );
	}
	
	if( IsDefined( ent_poi.arrival_attract_func ) )
	{
		self thread [[ ent_poi.arrival_attract_func ]]( ent_poi );
	}

	return bhb_position;	
}

override_quad_explosion(quad)
{
	if ( isdefined( quad.in_low_gravity ) && quad.in_low_gravity == 1 )
	{
		quad.can_explode = false;
	}
}

moon_speed_up()
{
	self set_zombie_run_cycle( "sprint" );
	if ( is_true( self.in_low_gravity ) )
	{
		self thread maps\mp\zm_moon_gravity::zombie_low_gravity_locomotion();
	}
}
