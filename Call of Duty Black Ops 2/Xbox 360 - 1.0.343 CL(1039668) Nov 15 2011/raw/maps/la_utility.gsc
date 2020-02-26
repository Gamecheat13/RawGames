#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include animscripts\anims;
#include maps\_skipto;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la_1.gsh;

init_flags()
{
	flag_init( "drone_approach", true );
	flag_init( "intro_attack_start" );
	flag_init( "intro_done" );
	flag_init( "near_sam_cougar" );
	flag_init( "start_sam_vo" );
	flag_init( "sam_success" );
	flag_init( "sam_complete" );
	flag_init( "sniper_option" );
	flag_init( "rappel_option" );
	flag_init( "out_of_ammo" );
	flag_init( "done_rappelling" );
	flag_init( "squad_rappel_done" );
	flag_init( "g20_group1_dead" );
	flag_init( "player_in_cougar" );
	flag_init( "drive_failing" );
	flag_init( "low_road_move_up_4" );
	flag_init( "drive_under_first_overpass" );
	flag_init( "drive_under_big_overpass" );
	
	flag_init( "la_street_done" );
	flag_init( "brute_force_vo_can_play" );
	flag_init( "rooftop_sam_in" );
	flag_init( "intersect_vip_cougar_died" );
	flag_init( "event_6_done" );
	flag_init( "la_arena_start" );
	flag_init( "anderson_saved" );
	flag_init( "ending_ai_can_die" );
	flag_init( "ending_player_arrived" );
	
	flag_init( "la_1_sky_transition" );
	flag_init( "entering_arena" );
	flag_init( "exiting_arena" );
	
	// la_2 flags
	flag_init( "player_in_f35" );
	flag_init( "player_flying" ); 
	flag_init( "player_awake" );
	flag_init( "no_fail_from_distance" );
	flag_init( "F35_pilot_saved" );
	flag_init( "G20_1_saved" );  // TODO: coordinate with code to determine how this data is imported
	flag_init( "G20_2_saved" );  // TODO: coordinate with code to determine how this data is imported
	flag_init( "G20_1_dead" );  // use this to check if G20_1 has died
	flag_init( "G20_2_dead" );  // use this to check if G20_2 has died
	flag_init( "convoy_movement_started" );
	flag_init( "convoy_can_move" );
	flag_init( "player_in_range_of_convoy" );
	flag_init( "convoy_in_position" );
	flag_init( "ground_targets_escape" );
	flag_init( "convoy_at_ground_targets" );
	flag_init( "ground_targets_done" );
	flag_init( "tutorial_done" );  
	flag_init( "convoy_nag_override" );
	flag_init( "convoy_at_roadblock" );
	flag_init( "roadblock_done" );
	flag_init( "convoy_at_rooftops" );
	flag_init( "rooftops_done" ); 
	flag_init( "convoy_at_dogfight" );	
	flag_init( "dogfight_done" ); 
	flag_init( "convoy_at_trenchrun" );	
	flag_init( "trenchrun_done" ); 
	flag_init( "trenchruns_start" );
	flag_init( "convoy_at_hotel" );	
	flag_init( "hotel_done" ); 
	flag_init( "convoy_at_outro" );	
	flag_init( "outro_start" );  
	flag_init( "eject_done" );
	flag_init( "outro_done" );
	flag_init( "gas_station_destroyed" );
	flag_init( "warehouse_destroyed" );
	flag_init( "ground_attack_vehicles_dead" );
	flag_init( "rooftop_enemies_dead" );	
	flag_init( "eject_sequence_started" );
	flag_init( "convoy_at_apartment_building" );
	flag_init( "convoy_at_parking_structure" );
	flag_init( "la_transition_setup_done" );
	flag_init( "player_passed_garage" );
	flag_init( "start_anderson_f35_exit" );
	flag_init( "convoy_at_trenchrun_turn_2" );
	flag_init( "convoy_at_trenchrun_turn_3" );
	flag_init( "missile_event_started" );
	flag_init( "dogfights_story_done" );
	flag_init( "missile_can_damage_player" );
	flag_init( "force_flybys_available" );
	flag_init( "strafing_run_active" );
	flag_init( "strafing_wave_done" );
}

setup_objectives()
{
	level.OBJ_SHOOT_DRONES	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_SHOOT_DRONES" );
	level.OBJ_REGROUP		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_REGROUP" );
	level.OBJ_RAPPEL		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_RAPPEL" );
	level.OBJ_RAPPEL2		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_RAPPEL2" );
	level.OBJ_SNIPE			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_SNIPE" );
	level.OBJ_HIGHWAY		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_HIGHWAY" );
	level.OBJ_POTUS			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_POTUS" );
	level.OBJ_DRIVE			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_DRIVE" );
	level.OBJ_INTERACT		= maps\_objectives::register_objective( &"" );
	level.OBJ_STREET_REGROUP= maps\_objectives::register_objective( &"LA_SHARED_OBJ_STREET_REGROUP" );
	level.OBJ_STREET		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_STREET" );
	level.OBJ_BIG_DOGS		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_BIG_DOGS" );
	level.OBJ_PLAZA			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_PLAZA" );
	level.OBJ_ARENA			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_ARENA" );
	level.OBJ_FOLLOW		= maps\_objectives::register_objective( &"" );
	level.OBJ_ANDERSON		= maps\_objectives::register_objective( &"" );
	level.OBJ_SONAR_OUT		= maps\_objectives::register_objective( &"" );
	level.OBJ_FLY			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_FLY" );
	level.OBJ_PROTECT		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_PROTECT" );
	level.OBJ_FOLLOW_VAN	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_FOLLOW_VAN" );
	level.OBJ_ROADBLOCK 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_ROADBLOCK" );
	level.OBJ_ROOFTOPS 		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_ROOFTOPS" );
	level.OBJ_DOGFIGHTS 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_DOGFIGHTS" ); 
	level.OBJ_DOGFIGHTS_LAST= maps\_objectives::register_objective( &"" );
	level.OBJ_DOGFIGHTS_STRAFE = maps\_objectives::register_objective( &"" );
	level.OBJ_TRENCHRUN_1 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
	level.OBJ_TRENCHRUN_2 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
	level.OBJ_TRENCHRUN_3 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
	level.OBJ_TRENCHRUN_4 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_cleanup()
{
	load_gumps_la_1();
			
	if ( level.skipto_point == "intro" )
		return;
	
	if ( level.script == "la_1" )  // TravisJ 7/15/2011 - added level name check to not give LA_2 SRE on load
	{
		exploder( EXPLODER_FREEWAY_DESTRUCTION );
	}
	
	flag_set( "intro_done" );
	
	if ( level.skipto_point == "after_the_attack" )
		return;
	
	if ( level.skipto_point == "sam_jump" )
		return;
	
	if ( level.skipto_point == "sam" )
		return;
	
	skip_objective( level.OBJ_SHOOT_DRONES );
	
	if ( level.skipto_point == "cougar_fall" )
		return;
	
	if ( level.skipto_point == "sniper_rappel" )
		return;
	
	flag_set( "done_rappelling" );
	
	if ( level.skipto_point == "g20_group1" )
		return;
	
	skip_objective( level.OBJ_HIGHWAY );
	
	if ( level.skipto_point == "drive" )
		return;
	
	flag_set( "la_1_sky_transition" );
	
	if ( level.skipto_point == "skyline" )
		return;
	
	if ( level.skipto_point == "street" )
		return;
	
	if ( level.skipto_point == "plaza" )
		return;
	
	if ( level.skipto_point == "intersection" )
		return;
	
	flag_set( "entering_arena" );
	
	if ( level.skipto_point == "arena" )
		return;
	
	if ( level.skipto_point == "arena_exit" )
		return;
	
	flag_set( "exiting_arena" );
	
	// section 3 starts - flyable f35
	if ( level.skipto_point == "f35_wakeup" )
	{
		return;
	}
	
	level.player SetClientDvar( "cg_drawHUD", 1 );
	flag_set( "player_awake" );
	
	if ( level.skipto_point == "f35_boarding" )
	{
		return;
	}
	
	flag_set( "player_flying" );
	
	//audio:  set interrior f35 snapshot for greenlight
	clientnotify( "start_f35_snap" );
	
	flag_set( "player_in_f35" );
	//flag_set( "convoy_movement_started" );	
	
	if ( level.skipto_point == "f35_flying" )
	{
		return;
	}
		
	flag_set( "tutorial_done" );
		
	if ( level.skipto_point == "f35_ground_targets" )
	{
		return;
	}	
	
	flag_set( "convoy_at_ground_targets" );
	flag_set( "ground_targets_done" );
	
	if ( level.skipto_point == "f35_pacing" )
	{
		return;
	}	
	
	if ( level.skipto_point == "f35_rooftops" )
	{
		return;
	}	

	flag_set( "rooftops_done" );  
	flag_set( "convoy_at_dogfight" );
	
	if ( level.skipto_point == "f35_dogfights" )
	{
		return;
	}	
	
	flag_set( "dogfights_story_done" );  
	flag_set( "dogfight_done" );  	
	
	if ( level.skipto_point == "f35_trenchrun" )
	{
		return;
	}	
	
	flag_set( "trenchruns_start" );
	flag_set( "trenchrun_done" );  	

	if ( level.skipto_point == "f35_hotel" )
	{
		return;
	}	
	
	flag_set( "hotel_done" ); 	
	
	if ( level.skipto_point == "f35_eject" )
	{
		return;
	}	
	
	flag_set( "eject_done" );  	
	
	if ( !IsDefined( level.trenchruns_struct ) )
	{
		level.trenchruns_struct = SpawnStruct();
		level.trenchruns_struct.missile_deaths = 0;
	}
	
	if ( level.skipto_point == "f35_outro" )
	{
		return;
	}
}

load_gumps_la_1()
{
	fade_to_black( 0 );
	
	if ( level.script == "la_1" )
	{
		if ( is_after_skipto( "g20_group1" ) )
		{
			load_gump( "la_1_gump_1c" );
		}
		else if ( is_after_skipto( "intro" ) )
		{
			load_gump( "la_1_gump_1b" );
		}
		else
		{
			load_gump( "la_1_gump_1a" );
		}
	}
	
	fade_from_black( 0 );
}

player_has_sniper_weapon()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( weapon in a_current_weapons )
	{
		if ( WeaponIsSniperWeapon( weapon ) )
		{
			return true;
		}			
	}
	
	return false;
}

give_max_ammo_for_sniper_weapons()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( weapon in a_current_weapons )
	{
		if ( WeaponIsSniperWeapon( weapon ) )
		{
			self SetWeaponAmmoClip( weapon, 1000 );
			self SetWeaponAmmoStock( weapon, 1000 );
		}			
	}	
}

waittill_player_has_sniper_weapon()
{
	while ( !self player_has_sniper_weapon() )
	{
		self waittill( "weapon_change" );
	}
}

waittill_player_has_brute_force_perk()
{
	while ( !self HasPerk( "specialty_brutestrength" ) )
	{
		wait 0.05;
	}
}

waittill_player_has_intruder_perk()
{
	while ( !self HasPerk( "specialty_intruder" ) )
	{
		wait 0.05;
	}
}

waittill_player_has_lock_breaker_perk()
{
	while ( !self HasPerk( "specialty_trespasser" ) )
	{
		wait 0.05;
	}
}

stick_player( b_look, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom )
{
	if ( !IsDefined( b_look ) )
	{
		b_look = false;
	}
	
	self.m_link = Spawn( "script_model", self.origin );
	self.m_link.angles = self.angles;
	self.m_link SetModel( "tag_origin" );
	
	if ( b_look )
	{
		self PlayerLinkToDelta( self.m_link, "tag_origin", 1, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom, true );
	}
	else
	{
		self PlayerLinkToAbsolute( self.m_link, "tag_origin" );
	}
}

unstick_player()
{
	if ( IsDefined( self.m_link ) )
	{
		self.m_link Delete();
	}
}

waittill_all_axis_are_dead()
{
	while ( GetAIArray( "axis" ).size > 0 )
	{
		wait .2;
	}
}

waittill_player_approaches_ai( ai_goal, n_radius )
{
	do
	{
		wait .05;
		
		v_eye = ai_goal get_eye();
		
		b_looking = self is_player_looking_at( v_eye );
		n_dist = Distance2dSquared( v_eye, self.origin );
	}
	while ( !b_looking || ( n_dist > n_radius * n_radius ) );
}

get_player_cougar()
{
	if ( !IsDefined( level.veh_player_cougar ) )
	{
		level.veh_player_cougar = get_specific_vehicle( "g20_group1_cougar" );
		level.veh_player_cougar thread player_cougar_init();
	}
	
	return level.veh_player_cougar;
}

player_cougar_init()
{
	flag_wait( "la_1_gump_1c" );
	self Attach( "veh_t6_mil_cougar_interior_front" );
	self HidePart( "tag_windshield_d1" );
	self HidePart( "tag_windshield_d2" );
	self MakeVehicleUnusable();
}

get_f35_vtol()
{
	return get_specific_vehicle( "f35_vtol" );
}

get_specific_vehicle( targetname )
{
	veh = GetEnt( targetname, "targetname" );
	if ( !IsDefined( veh ) )
	{
		veh = spawn_vehicle_from_targetname( targetname );
	}
	
	return veh;
}

use_player_cougar()
{
	level.veh_player_cougar = get_player_cougar();
	level.veh_player_cougar godon();
	level.veh_player_cougar MakeVehicleUsable();
	level.veh_player_cougar UseVehicle( level.player, 0 );
	level.veh_player_cougar MakeVehicleUnusable();
	level.player EnableInvulnerability();
	
	level.player hide_hud();
	
	flag_set( "player_in_cougar" );
}

// runs a function on self after death
func_on_death( func_after_death )
{
	Assert( IsDefined( func_after_death ), "func_after_death is a required parameter for func_on_death" );
	
	self waittill( "death" );
	
	self [[ func_after_death ]]();
}

get_vehicles( str_value, str_key )
{
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	a_all_vehicles = GetVehicleArray();
	
	a_veh = [];
	foreach ( veh in a_all_vehicles )
	{
		switch ( str_key )
		{
		case "targetname":			if ( IS_EQUAL( veh.targetname, str_value ) )		ARRAY_ADD( a_veh, veh ); break;
		case "script_noteworthy":	if ( IS_EQUAL( veh.script_noteworthy, str_value ) )	ARRAY_ADD( a_veh, veh ); break;
		case "model":				if ( IS_EQUAL( veh.model, str_value ) )				ARRAY_ADD( a_veh, veh ); break;
		}
	}
	
	return a_veh;
}

get_vehicle_spawners( str_value, str_key )
{
	Assert( IsDefined( str_value ), "Missing <str_value> argument to get_vehicle_spawners()" );
	
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	if ( str_key == "targetname" )
	{
		str_value += "_vehiclespawner";
	}
	
	a_spawners = get_struct_array( str_value, str_key );
	return a_spawners;
}

get_vehicle_spawner( str_value, str_key )
{
	Assert( IsDefined( str_value ), "Missing <str_value> argument to get_vehicle_spawner()" );
	
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	if ( str_key == "targetname" )
	{
		str_value += "_vehiclespawner";
	}	
	
	a_spawners = get_struct_array( str_value, str_key );
	
	Assert( a_spawners.size < 2, "More than one vehicle spawner found with kvp '" + str_key + "/" + str_value );
	
	return a_spawners[0];
}

/@
"Name: debug_hud_elem_add( <func_debug>, [str_custom_dvar] )"
"Summary: Adds a debug hud element that prints to the lower left corner of the screen when dvar 'show_debug_hud' is set to 1. Returns hud element. Supports custom dvars."
"Module: Debug"
"CallOn: N/A"
"MandatoryArg: <func_debug> function that sets the text of the debug hud element. Note this is threaded. All debug hud elems should set text with function 'debug_hud_elem_set_text' for full functionality"
"OptionalArg: [str_custom_dvar] if you want to use a special dvar instead of 'show_debug_hud', pass the name of it here"
"Example: F35_health_elem = debug_hud_elem_add( ::monitor_F35_health, "la_debug" );"
"SPMP: singleplayer"
@/
debug_hud_elem_add( func_debug, str_custom_dvar )
{
	Assert( IsDefined( func_debug ), "func_debug is a required parameter for debug_hud_elem_add" );
	
	if ( !IsDefined( level.debug_hud ) )
	{
		level.debug_hud = SpawnStruct(); 
	}
	
	if ( !IsDefined( level.debug_hud.elems ) )
	{
		level.debug_hud.elems = [];
	}
	
	level.debug_hud.scale_y = 15;
	n_scale = level.debug_hud.scale_y;
	hud_elem = NewHudElem();
	level.debug_hud.elems[ level.debug_hud.elems.size ] = hud_elem;	
		
	// position on screen
	hud_elem.horzAlign = "left";
	hud_elem.vertAlign = "bottom";
	hud_elem.alignX = "left";
	hud_elem.alignY = "bottom";
	hud_elem.x = 0;
	hud_elem.y = ( level.debug_hud.elems.size * n_scale ) * ( -1 );  // move this up as list populates
	
	// font/color
	hud_elem.font = "objective";
	hud_elem.font_scale = 1;
	hud_elem.color = ( 0.0, 0.0, 1.0 );
	
	hud_elem thread _debug_hud_elem_should_show( str_custom_dvar );
	hud_elem thread _debug_hud_elem_func( func_debug );  // this is where text is set and manipulated
	
	return hud_elem;
}



/@
"Name: debug_hud_elem_set_text( <str_text> )"
"Summary: sets text of a debug hud element. This text will not be seen on-screen when the dvar isn't set."
"Module: Debug"
"CallOn: N/A"
"MandatoryArg: <str_text> text to show when the debug hud element dvar is set. By default this is 'show_debug_hud'"
"Example: debug_hud_elem_set_text( "F35 health: + n_health );"
"SPMP: singleplayer"
@/
debug_hud_elem_set_text( str_text )  // self = debug hud elem
{
	Assert( IsDefined( str_text ), "str_text is a required parameter for debug_hud_elem_set_text" );
	
	self.debug_text = str_text;
}


/@
"Name: debug_hud_elem_remove( <hud_elem> )"
"Summary: Removes a debug hud element and moves all other hud elements to lowest available positions. Will automatically kill debug_funcs passed to debug_hud_elem_add"
"Module: Debug"
"CallOn: N/A"
"MandatoryArg: <hud_elem> the hud element to remove"
"Example: debug_hud_elem_remove( F35_health_elem );"
"SPMP: singleplayer"
@/
debug_hud_elem_remove( hud_elem )
{
	Assert( IsDefined( hud_elem ), "hud_elem parameter is required for debug_hud_elem_remove!" );
	
	b_has_removed = false;
	
	for ( i = 0; i < level.debug_hud.elems.size; i++ )
	{
		
		if (level.debug_hud.elems[ i ] == hud_elem )
		{
			hud_to_remove = level.debug_hud.elems[ i ];
			hud_to_remove notify( "debug_hud_remove" );
			wait 0.05;
			hud_to_remove Destroy();
			b_has_removed = true;
			continue;
		}
		
		if ( b_has_removed )
		{
			// move following hud elements down one spot (populates upward, remember)
			n_index = i - 1;
			n_scale = level.debug_hud.scale_y;
			hud_current = level.debug_hud.elems[ i ];
			hud_current.y = ( n_index * n_scale ) * ( -1 );
		}
	}
	
	level.debug_hud.elems = array_removeUndefined( level.debug_hud.elems );
}

 /*==============================================================
 SELF: debug hud element
 PURPOSE: adds endon to function so user doesn't need to worry about manual additions
 RETURNS: nothing
 CREATOR: TravisJ - 6/27/2011
 ===============================================================*/ 
 _debug_hud_elem_func( func_debug )
 {
 	self endon( "debug_hud_remove" );
 	
 	self [[ func_debug ]]();
 }

 /*==============================================================
 SELF: debug hud element
 PURPOSE: checks dvar determine if debug hud text should print or not
 RETURNS: nothing
 CREATOR: TravisJ - 6/27/2011
 ===============================================================*/ 
_debug_hud_elem_should_show( str_custom_dvar ) 
{
	self endon( "debug_hud_remove" );	
	
	str_dvar = "show_debug_hud";
	
	if ( IsDefined( str_custom_dvar ) )
	{
		str_dvar = str_custom_dvar;
	}
	
	self.dvar_name = str_dvar;
	b_should_show_debug = false;
	
	while ( true )
	{
		if( IsDefined( GetDvar( str_dvar ) ) && ( GetDvar( str_dvar ) == "1" ) )
		{
			b_should_show_debug = true;
			
			if ( IsDefined( self.debug_text ) )
			{
				self SetText( self.debug_text );
			}
		}
		else
		{
			b_should_show_debug = false;
			self SetText( "" );
		}
		
		self.hud_should_show = b_should_show_debug;
		
		wait 0.5;
	}
}

press_x_to_continue()
{
	screen_message_create( "press x to continue" );
	level.player waittill_use_button_pressed();
	screen_message_delete();
}

la_1_vehicle_damage( e_inflictor, e_attacker, n_damage, n_flags, str_mod, str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name )
{
	if ( IsDefined( level.veh_player_cougar ) && ( self == level.veh_player_cougar ) )
	{
		return;
	}
	
	b_plane_weapon = IsDefined( e_attacker.vehicleclass ) && ( e_attacker.vehicleclass == "plane" );
	b_explosion = IsDefined( str_mod ) && ( ( str_mod == "MOD_EXPLOSIVE" ) || ( str_mod == "MOD_PROJECTILE" ) || ( str_mod == "MOD_UNKNOWN" ) );
	
	if ( b_explosion && b_plane_weapon )
	{
		vehicle_explosion_launch( v_point );
		self FinishVehicleDamage( e_inflictor, e_attacker, n_damage, n_flags, "MOD_UNKNOWN", str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name, false );
	}
	else
	{
		maps\_callbackglobal::Callback_VehicleDamage( e_inflictor, e_attacker, n_damage, n_flags, str_mod, str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name );
	}
}

// physics launch logic from POW - thanks Gavin	
vehicle_explosion_launch( v_hit_point, n_force )  // self = physics model or vehicle
{
	s_launch = get_launch_params_from_structs();
			
	if ( IsDefined( s_launch ) )
	{
		v_impact_point = s_launch.v_impact;
		v_world_force = s_launch.v_force;
	}
	else
	{
		v_impact_pos = v_hit_point;
		v_rocket_impact_point = v_hit_point;
		
		v_forward = AnglesToforward(self.angles);		
	    v_right = AnglesToright(self.angles);
	    v_up = AnglesToright(self.angles);
	    
	    n_max_x = 500;
	    n_max_y = 400;
	    
	    /*
	    n_max_x = 300;
	    n_max_y = 200;
	    */
	    
	    //-- figure out where the rocket landed in relation to the truck
	    v_impact_pos = v_rocket_impact_point - self.origin;
	    n_dist_in_front = VectorDot(v_forward, v_impact_pos); //-- 208 either way
	    n_dist_to_v_right = VectorDot(v_right, v_impact_pos); //-- 128 either way
	    
	    if(abs(n_dist_in_front) > n_max_x || abs(n_dist_to_v_right) > n_max_y)
	    {
	        return false; //-- not close enough to cause this type of behavior
	    }
	        
	    str_impact_orient = "";
	    
	    if(abs(n_dist_in_front) < n_max_x * .25)
	    {
	        str_impact_orient = "mid_";
	    }
	    else if(n_dist_in_front < 0)
	    {
	        str_impact_orient = "rear_";
	    }
	    else
	    {
	        str_impact_orient = "front_";
	    }
	    
	    if( n_dist_to_v_right < 0 )
	    {
	        str_impact_orient = str_impact_orient + "left";
	    }
	    else
	    {
	        str_impact_orient = str_impact_orient + "v_right";
	    }
	        
	    //-- get the proper v_force data and impact point
	    v_impact_point = (0,0,0);
	    v_force = (0,0,0);
	        
	    switch( str_impact_orient )
	    {
	        case "mid_left":
	            v_impact_point = (28, -46, 50);
	            v_force = (0, 308, 30);
		        break;
	        
	        case "mid_v_right":
	            v_impact_point = (28, 42, 50);
	            v_force = (0, -340, 30);
		        break;
	        
	        case "front_left":
	            v_impact_point = (108, 2, 50);
	            v_force = (-16, 132, 126);
		        break;
	        
	        case "front_v_right":
	            v_impact_point = (108, 2, 50);
	            v_force = (-32, -132, 126);
		        break;
	        
	        case "rear_left":
	            v_impact_point = (-84, -22, 26);
	            v_force = (56, 180, 150);
		        break;
	        
	        case "rear_v_right":
	            v_impact_point = (-92, 18, 26);
	            v_force = (72, -148, 150);
		        break;
	    }
	    
	    //convert the v_force to worldspace
    	v_world_force = (v_forward * v_force[0]) + (v_right * v_force[1]) + (v_up * v_force[2]);
    	
    	if ( IsDefined( n_force ) )
    	{
    		v_world_force = VectorNormalize( v_world_force ) * n_force;
    	}
	}
	
    e_fx = spawn_model( "tag_origin", self.origin, self.angles );
	e_fx LinkTo( self );
	PlayFXOnTag( getfx( "vehicle_launch_trail" ), e_fx, "tag_origin" );
    
	/#
		level thread draw_line_for_time( v_impact_point, v_impact_point + v_world_force, 1, 0, 0, 2 );
	#/
	
    if ( self.classname == "script_vehicle" )
    {
    	self LaunchVehicle( v_world_force, v_impact_point );
    }
    else if (self.classname == "script_model" )
    {
    	self PhysicsLaunch( v_impact_point, v_world_force );
    }
    
    e_fx delay_thread( 4, ::self_delete );
}

get_launch_params_from_structs()
{
	if ( IsDefined( self.target ) )
	{
		s_start = get_struct( self.target );
		
		if ( IsDefined( s_start ) )
		{
			s_end = get_struct( s_start.target );
			
			Assert( IsDefined( s_end ) );
			
			v_start = s_start.origin;
			v_end = s_end.origin;
				
			v_dir = v_end - v_start;
			
			a_trace = BulletTrace( v_start, v_end, false, undefined );
			v_hit_pos = a_trace[ "position" ];
			
			n_intensity = 200;
			if ( IsDefined( s_start.script_float ) )
			{
				n_intensity = s_start.script_float;
			}
			
			s_return = SpawnStruct();
			s_return.v_impact = v_hit_pos;
			s_return.v_force = VectorNormalize( v_dir ) * n_intensity;
		    
		    return s_return;
		}
	}
}

#define VEHICLE_COUNT_MAX 64
#define TARGET_COUNT_MAX 28
#define MIN_SPAWN_DELAY 0.33
#define MAX_SPAWN_DELAY 0.66
#define SPAWN_AERIAL_DT 0.05

spawn_aerial_vehicles( n_aerial_vehicles_max, allies_spawners, axis_spawners )
{
	level notify( "spawn_aerial_vehicles" );
	level endon( "spawn_aerial_vehicles" );
	
	if ( !IsDefined( level.a_aerial_vehicles ) )
	{
		level.a_aerial_vehicles = [];
	}
	
	if ( !IsDefined( level.fly_zone ) )
	{
		level.fly_zone = SpawnStruct();
	}	
	
	spawn_timer = 0;
	
	num_allies = 0;
	
	if ( IsArray( allies_spawners ) && allies_spawners.size > 0 )
	{
		num_allies = RandomIntRange( 1, 3 );
	}
	
	num_axis = RandomIntRange( 2, 4 );
	
	while ( true )
	{
		vehicles = GetVehicleArray();
		
		// Update the fly zone
		level.fly_zone update_fly_zone( 3000, 6000 );
		
		// Update the groups
		_av_check_aerial_vehicles();
		
		// Timer expired
		if ( spawn_timer <= 0 )
		{
			desired_count = ( num_allies + num_axis + level.a_aerial_vehicles.size );
			if ( desired_count <= n_aerial_vehicles_max && vehicles.size < VEHICLE_COUNT_MAX )			
			{
				spawn_group( num_allies, allies_spawners, num_axis, axis_spawners, undefined );
				
				// Spawn a group
				spawn_timer = RandomFloatRange( MIN_SPAWN_DELAY, MAX_SPAWN_DELAY );
				
				if ( num_allies > 0 )
				{
					num_allies = RandomIntRange( 1, 3 );
				}
				
				num_axis = RandomIntRange( 2, 4 );		
			}
		}
		
		// decrement spawn timer
		spawn_timer -= SPAWN_AERIAL_DT;
		
		// wait
		wait( SPAWN_AERIAL_DT );
	}
}

#define BACK  0
#define FRONT  1
#define LEFT  2
#define RIGHT  3
#define NUM_ZONES 4

spawn_group( allies_count, allies_spawners, axis_count, axis_spawners, spawnpoints )
{
	// Pick a spawn point
	e_view_locked = level.player.viewlockedentity;
	if ( IsDefined( e_view_locked ) && e_view_locked.classname == "script_vehicle" && e_view_locked.vehicletype == "wpn_sam_launcher" )
	{
		angles = e_view_locked GetSeatFiringAngles( 1 );
	}
	else
	{
		angles = level.player GetPlayerAngles();
	}
	
	angles = flat_angle( angles );
	forward = AnglesToForward( angles );
	right = AnglesToRight( angles );
	up = AnglesToUp( angles );
	
	offsets = [];
	offsets[0] = ( right * -500 ) + ( up * 500 );
	offsets[1] = ( right * 500 ) + ( up * 500 );	
	offsets[2] = ( right * 500 ) + ( up * -500 );		
	offsets[3] = ( right * -500 ) + ( up * -500 );	

	if ( IsDefined( level.fly_zone ) )
	{
		start_zone = RandomIntRange( BACK, NUM_ZONES );		
		
		start = get_spawn_start( level.fly_zone, start_zone, forward, right, up );
		start_angles = get_spawn_angles( start_zone, forward, right, up );
		
		axis = [];
		
		// Spawn axis guys
		for ( i = 0; i < axis_count; i++ )
		{
			// Spawn a squad mate
			plane = spawn_vehicle_from_targetname( random( axis_spawners ) );
			plane SetForceNoCull();
			
			// set position and angles
			squad_mate_origin = start;
			squad_mate_origin += offsets[i];
			squad_mate_origin += ( RandomIntRange( -250, 250 ), RandomIntRange( -250, 250 ), RandomIntRange( -250, 250 ) );
			
			plane.origin = squad_mate_origin;
			plane SetPhysAngles( ( 0, start_angles[1], 0 ) );
			
			if ( IS_TRUE( level.is_player_in_sam ) )
			{
				plane SetSpeed( 300, 500, 500 );	
			}
			else
			{
				plane SetSpeed( 500, 1000, 1000 );
			}
			
			level.a_aerial_vehicles[level.a_aerial_vehicles.size] = plane;		
			
			axis[i] = plane;
			
			plane thread _av_axis_fly( AnglesToForward( ( 0, start_angles[1], 0 ) ), RandomFloatRange( level.fly_zone.n_range * 2, level.fly_zone.n_range * 3 ), start_zone );
			plane thread _av_death();
		}
	
		start = start + forward * RandomIntRange( -10000, -5000 );
		start = start + up * RandomIntRange( -1000, 1000 );
		
		// Spawn allies guys
		for ( i = 0; i < allies_count; i++ )
		{
			// Spawn a squad mate
			plane = spawn_vehicle_from_targetname( random( allies_spawners ) );
			plane SetForceNoCull();
			
			// set position and angles
			squad_mate_origin = start;
			squad_mate_origin += offsets[i];
			
			plane.origin = squad_mate_origin;
			plane SetPhysAngles( ( 0, angles[1], 0 ) );
			if ( IS_TRUE( level.is_player_in_sam ) )
			{
				plane SetSpeed( 300, 500, 500 );	
			}
			else
			{
				plane SetSpeed( 500, 1000, 1000 );
			}
			
			level.a_aerial_vehicles[level.a_aerial_vehicles.size] = plane;			
			
			if ( plane.vehicleType == "plane_f35_fast" )
			{
				plane HidePart( "tag_gear" );
			}
			
			plane thread _av_allies_fly( axis[i] );
			//plane thread _av_death();
		}
	}
}

get_spawn_start( fly_zone, start_zone, forward, right, up )
{
	start = level.player.origin;	
	if ( start_zone == BACK )
	{
		start = start + forward * -fly_zone.n_range;
		start = start + right * RandomFloatRange( -fly_zone.n_range, fly_zone.n_range );	
	}
	else if ( start_zone == FRONT )
	{
		start = start + forward * ( fly_zone.n_range * 4 );
		start = start + right * RandomFloatRange( -fly_zone.n_range, fly_zone.n_range );			
	}
	else if ( start_zone == LEFT )
	{
		start = start + right * -fly_zone.n_range;
		start = start + forward * RandomFloatRange( fly_zone.n_range / 2, fly_zone.n_range );			
	}
	else if ( start_zone == RIGHT )
	{
		start = start + right * fly_zone.n_range;
		start = start + forward * RandomFloatRange( fly_zone.n_range / 2, fly_zone.n_range );				
	}
	
	// randomize up and down
	start = ( start[0], start[1], RandomFloatRange( fly_zone.mins[2], fly_zone.maxs[2] ) );	
	
	return start;
}

get_spawn_angles( start_zone, forward, right, up )
{
	angles = ( 0, 0, 0 );
	if ( start_zone == BACK )
	{
		angles = VectorToAngles( forward );
	}
	else if ( start_zone == FRONT )
	{
		angles = VectorToAngles( forward );
	}
	else if ( start_zone == LEFT )
	{
		angles = VectorToAngles( right );
	}
	else if ( start_zone == RIGHT )
	{
		angles = VectorToAngles( right );			
		angles = ( angles[0], angles[1] + 180, angles[2] );			
	}

	if ( start_zone == FRONT || start_zone == RIGHT )
	{
		yaw = angles[1] + 180;
		yaw = AbsAngleClamp360( yaw );
		angles = ( angles[0], yaw, angles[2] );
	}
	
	return angles;	
}

update_fly_zone( n_hight_min, n_height_max )
{	
	n_player_x = Int( level.player.origin[0] );
	n_player_y = Int( level.player.origin[1] );
	n_player_z = Int( level.player.origin[2] );

	self.n_range = 15000;
	self.n_x_min = n_player_x - self.n_range;
	self.n_x_max = n_player_x + self.n_range;
	self.n_y_min = n_player_y - self.n_range;
	self.n_y_max = n_player_y + self.n_range;
	self.n_z_min = n_player_z + n_hight_min;
	self.n_z_max = n_player_z + n_height_max;
	
	self.mins = ( self.n_x_min, self.n_y_min, self.n_z_min );
	self.maxs = ( self.n_x_max, self.n_y_max, self.n_z_max );	
	
	if ( !IsDefined( self.corners ) )
	{
		self.corners = [];
	}
	
	self.corners[0] = self.mins;
	self.corners[1] = ( self.mins[0], self.maxs[1], self.mins[2] );
	self.corners[2] = ( self.maxs[0], self.maxs[1], self.mins[2] );	
	self.corners[3] = ( self.maxs[0], self.mins[1], self.mins[2] );		
	self.corners[4] = ( self.mins[0], self.maxs[1], self.maxs[2] );
	self.corners[5] = ( self.maxs[0], self.maxs[1], self.maxs[2] );	
	self.corners[6] = ( self.maxs[0], self.mins[1], self.maxs[2] );
	self.corners[7] = self.maxs;
}

_av_axis_fly( start_dir, dist, start_zone )
{
	self endon( "death" );
	
	goal = self.origin + start_dir * dist;
	
	if ( Target_GetArray().size < 32 )
	{
		Target_Set( self );
	}
	
	self SetNearGoalNotifyDist( 500 );
	self SetVehGoalPos( goal );
	self waittill( "near_goal" );
	
	if ( start_zone != BACK && RandomInt( 100 ) < 40 && IS_TRUE( level.is_player_in_sam ) )
	{
		self SetVehGoalPos( level.player.origin + ( 0, 0, 2048 ) );
		self thread _av_attack_player();
		self waittill( "near_goal" );
		
		self notify( "stop_attacking_player" );
	}
	
	if ( IsDefined( level.fly_zone ) )
	{
		self SetVehGoalPos( level.fly_zone.corners[RandomIntRange( 0, 8 )] );
		self waittill( "near_goal" );
	}

	while ( true )
	{
		plane_origin = 	self.origin;
		plane_origin = ( plane_origin[0], plane_origin[1], level.player.origin[2] );

		vec_to_target = VectorNormalize( plane_origin - level.player.origin );
		
		if ( !IsDefined( self.deleted ) && ( VectorDot( AnglesToForward( flat_angle( level.player.angles ) ), vec_to_target ) < 0 || Distance2D( plane_origin, level.player.origin ) > 20000 ) )
		{	
			if ( self.drivebysoundtime0 > 0 || self.drivebysoundtime1 > 0 )
			{
				if ( self.drivebysoundtime0 > self.drivebysoundtime1 )
					self _av_delete( self.drivebysoundtime0 );
				else
					self _av_delete( self.drivebysoundtime1 );
			}
			else
			{
				self _av_delete();
			}
		}
		else
		{
			goal = level.player.origin + AnglesToForward( flat_angle( level.player.angles ) ) * -10000.0;
			goal = ( goal[0], goal[1], self.origin[2] );
			self SetVehGoalPos( goal );
		}
		
		self waittill( "near_goal" ); 
	}
}

_av_attack_player()
{
	self endon( "death" );
	self endon( "stop_attacking_player" );
	
	while ( true )
	{
		self _av_axis_fire_turrets( level.player );
		
		wait 0.05;
	}
}

_av_valid_target( ent )
{
	if ( !isDefined( ent ) )
		return false;
	if ( IS_TRUE( self.isacorpse ) )
		return false;
	if ( IsDefined(self.classname ) && ( self.classname == "script_vehicle_corpse" ) )
		return false;
	if ( ent.health <= 0 )
		return false;

	return true;
}

_av_allies_fly( target )
{
	self endon( "death" );
	
	self.firing = false;
	
	while ( _av_valid_target( target ) )
	{
		self SetVehGoalPos( target.origin );
		
		if ( VectorDot( AnglesToForward( self.angles ), VectorNormalize( target.origin - self.origin ) ) > 0.9 )
		{
			if ( !self.firing )
			{
				self thread _av_allies_fire_turrets( target );
			}
		}		
		
		wait( 0.1 );
	}
	
	self.check_vis = true;
	
	max_speed = self GetMaxSpeed();
	goal = self.origin + AnglesToForward( self.angles ) * max_speed * 2.2;
	
	self SetVehGoalPos( goal );
		
	wait( 1 );
	
	if ( !IsDefined( self ) )
		return;
	
	if ( IsDefined( level.fly_zone ) )
	{
		self SetNearGoalNotifyDist( 500 );		
		self SetVehGoalPos( level.fly_zone.corners[ RandomIntRange( 0, 8 ) ] );
		self waittill( "near_goal" );
	}
	
	while ( true )
	{
		plane_origin = 	self.origin;
		plane_origin = ( plane_origin[0], plane_origin[1], level.player.origin[2] );

		vec_to_target = VectorNormalize( plane_origin - level.player.origin );
		
		if ( !IsDefined( self.deleted ) && ( VectorDot( AnglesToForward( flat_angle( level.player.angles ) ), vec_to_target ) < 0 || Distance2D( plane_origin, level.player.origin ) > 20000 ) )
		{	
			if ( self.drivebysoundtime0 > 0 || self.drivebysoundtime1 > 0 )
			{
				if ( self.drivebysoundtime0 > self.drivebysoundtime1 )
					self _av_delete( self.drivebysoundtime0 );
				else
					self _av_delete( self.drivebysoundtime1 );
			}
			else
			{
				self _av_delete();
			}
			
			return;
		}
		else
		{
			goal = level.player.origin + AnglesToForward( flat_angle( level.player.angles ) ) * -10000.0;
			goal = ( goal[0], goal[1], self.origin[2] );
			self SetVehGoalPos( goal );
		}
		
		self waittill( "near_goal" ); 
	}
}

_av_allies_fire_turrets( target )
{
	self endon( "death" );
	
	self.firing = true;
	
	wait ( RandomIntRange( 1, 4 ) );
	
	if ( self.health <= 0 )
		return;
	
	if ( IsDefined( target ) )
	{
		self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 1 );
		self thread maps\_turret::fire_turret_for_time( 2, 1 ); 
	
		self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 2 );
		self thread maps\_turret::fire_turret_for_time( 2, 2 ); 
	}

	wait ( 2 );
	
	if ( _av_valid_target( target ) && is_false( level.is_player_in_sam ) )
	{
		self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 0 );
		self thread maps\_turret::fire_turret_for_time( 2, 0 ); 	
	}
	
	self.firing = false;	
}

_av_axis_fire_turrets( target )
{
	self endon( "death" );
	
	self.firing = true;
	
	wait ( RandomIntRange( 1, 4 ) );
	
	if ( self.health <= 0 )
		return;
	
	if ( IsDefined( target ) )
	{
		self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 0 );
		self thread maps\_turret::fire_turret_for_time( 2, 0 ); 
	}

	wait ( 2 );

	self.firing = false;	
}

_av_death( )
{
	self waittill( "death", e_attacker );
	
	if ( IsDefined( self ) && Target_IsTarget( self ) )
	{
		Target_Remove( self );
	}
	
	if ( IsDefined( self ) && IsDefined( e_attacker ) )
	{
		if ( self.targetname == "avenger_fast" || self.targetname == "pegasus_fast" )
		{
			if ( e_attacker == level.player )
			{
				level notify( "rooftop_drone_killed" );
				level notify( "sam_hint_drone_killed" );
			}
		}
	}
	
	self thread _av_out_of_world();

	if ( IsDefined( self.deleted ) && self.deleted )
		return;
	
	level.a_aerial_vehicles = array_remove( level.a_aerial_vehicles, self );
	level.a_aerial_vehicles = array_removeundefined( level.a_aerial_vehicles );		
	
	self waittill_notify_or_timeout( "crash_done", 3 );

	if ( !IsDefined( self ) )
		return;
	
	self notify( "crash_move_done" );
	
	if ( IsDefined( self.deathmodel_pieces ) )
	{
		array_delete( self.deathmodel_pieces );
	}

	self Delete();
}

_av_delete( delay )
{
	self.deleted = true;
	
	level.a_aerial_vehicles = array_remove( level.a_aerial_vehicles, self );
	level.a_aerial_vehicles = array_removeundefined( level.a_aerial_vehicles );		
	
	if ( IsDefined( self ) && Target_IsTarget( self ) )
	{
		Target_Remove( self );
	}
		
	if ( IsDefined( delay ) )
	{
		wait ( delay / 1000 );
	}
	
	if ( !IsDefined( self ) )
		return;
	
	if ( IsDefined( self.deathmodel_pieces ) )
	{
		array_delete( self.deathmodel_pieces );
	}
				
	VEHICLE_DELETE( self )
}

_av_check_aerial_vehicles()
{
	corpses = GetEntArray( "script_vehicle_corpse", "classname" );
	//IPrintLn( "Corpses: " + corpses.size );
	
	for ( i = 0; i < corpses.size; i++ )
	{
		if ( !IS_PLANE( corpses[i] ) )
			continue;
		
		if ( !IsDefined( corpses[i].dead_time ) )
		{
			corpses[i].dead_time = 0.0;
		}
		else
		{
			corpses[i].dead_time += 0.05;			
		}
		
		if ( corpses[i].dead_time > 0.1 )
		{
			if ( IsDefined( corpses[i].deathmodel_pieces ) )
			{
				array_delete( corpses[i].deathmodel_pieces );
			}			
			
			corpses[i] Delete();			
		}
	}	
	
/*
	e_view_locked = level.player.viewlockedentity;
	if ( IsDefined( e_view_locked ) && e_view_locked.classname == "script_vehicle" && e_view_locked.vehicletype == "wpn_sam_launcher" )
	{
		angles = e_view_locked GetSeatFiringAngles( 1 );
	}
	else
	{
		angles = level.player GetPlayerAngles();
	}
	
	forward = AnglesToForward( flat_angle( angles ) );
	player_origin = level.player.origin;
	
	//foreach( i, plane in level.a_aerial_vehicles )
	for ( i = 0; i < level.a_aerial_vehicles.size; i++ )
	{
		plane = level.a_aerial_vehicles[i];
		
		if ( !IsDefined( plane ) )
		{
			level.a_aerial_vehicles = array_removeUndefined( level.a_aerial_vehicles );
		}
		else if ( IS_TRUE( plane.isacorpse ) || ( IsDefined( plane.deleted ) && IS_TRUE( plane.deleted ) ) )
		{
			level.a_aerial_vehicles = array_remove( level.a_aerial_vehicles, plane );
			level.a_aerial_vehicles = array_removeUndefined( level.a_aerial_vehicles );			
		}
		else
		{
			if ( IsDefined( plane ) && IsDefined( plane.check_vis ) && plane.check_vis )
			{
				plane_origin = 	plane.origin;
				plane_origin = ( plane_origin[0], plane_origin[1], player_origin[2] );
				
				vec_to_target = VectorNormalize( plane_origin - player_origin );

				dot = VectorDot( forward, vec_to_target );
				if ( dot < 0 )
				{	
					if ( plane.drivebysoundtime0 > 0 || plane.drivebysoundtime1 > 0 )
					{
						delay = 0;
						if ( plane.drivebysoundtime0 > plane.drivebysoundtime1 )
							delay = plane.drivebysoundtime0;
						else
							delay = plane.drivebysoundtime1;
						
						plane thread _av_delete( delay );		
					}
					else
					{
						plane thread _av_delete();
					}										
				}
			}
		}
	}
*/
}

_av_out_of_world()
{
	self endon( "death" );
	
	while ( true )
	{
		if ( self.origin[ 2 ] < -30000 )
		{
			self notify( "crash_move_done" );
	
			if ( IsDefined( self.deathmodel_pieces ) )
			{
				array_delete( self.deathmodel_pieces );
			}

			if ( IsDefined( self.deleted ) && self.deleted )
			{
				self Delete();
			}
			else
			{
				VEHICLE_DELETE( self );
			}
		}
		
		wait 0.05;
	}
}

fxanim_aerial_vehicles( n_fxanim_av_max )
{
	level notify( "fxanim_aerial_vehicles" );
	level endon( "fxanim_aerial_vehicles" );
	
	if ( !IsDefined( level.n_av_models ) )
	{
		level.n_av_models = 0;
	}
	
	n_player_fov = GetDvarFloat( "cg_fov" );
	n_cos_player_fov = cos( n_player_fov );
	
	if ( !IsDefined( level.fxanim_fly_zone ) )
	{
		level.fxanim_fly_zone = SpawnStruct();
	}
	
	s_fly_zone = level.fxanim_fly_zone;
	a_bb_ambient_anims = [];
	a_f35_ambient_anims = [];
	
	s_bb_ambient_1 = _create_fxanim_ambient_info( "drone_ambient_1", 10 );
	ARRAY_ADD( a_bb_ambient_anims, s_bb_ambient_1 );
	
	s_bb_ambient_2 = _create_fxanim_ambient_info( "drone_ambient_2", 15 );
	ARRAY_ADD( a_bb_ambient_anims, s_bb_ambient_2 );
	
	s_f35_ambient_1 = _create_fxanim_ambient_info( "f35_ambient_1", 10 );
	ARRAY_ADD( a_f35_ambient_anims, s_f35_ambient_1 );
	
	s_f35_ambient_2 = _create_fxanim_ambient_info( "f35_ambient_2", 15 );
	ARRAY_ADD( a_f35_ambient_anims, s_f35_ambient_2 );
	
	level.is_player_in_sam = false;
	
	while ( true )
	{
		if ( level.n_av_models < n_fxanim_av_max && !level.is_player_in_sam )
		{
			s_fly_zone update_fly_zone( 6000, 12000 );
	
			v_av_origin = ( RandomIntRange( s_fly_zone.n_x_min, s_fly_zone.n_x_max ), RandomIntRange( s_fly_zone.n_y_min, s_fly_zone.n_y_max ), RandomIntRange( s_fly_zone.n_z_min, s_fly_zone.n_z_max ) );
			while ( within_fov( level.player.origin, level.player.angles, v_av_origin, n_cos_player_fov ) )
			{
				wait 0.05;
				
				v_av_origin = ( RandomIntRange( s_fly_zone.n_x_min, s_fly_zone.n_x_max ), RandomIntRange( s_fly_zone.n_y_min, s_fly_zone.n_y_max ), RandomIntRange( s_fly_zone.n_z_min, s_fly_zone.n_z_max ) );
			}
			
			v_av_angles = ( 0, RandomIntRange( 0, 360 ), 0 );
			
			n_random_anim = RandomInt( 2 );
			//s_bb_ambient = random( a_bb_ambient_anims );
			s_bb_ambient = a_bb_ambient_anims[ n_random_anim ];
			str_ambient_anim = s_bb_ambient.str_ambient_anim;
		
			n_random_drone = RandomIntRange( 1, 3 );
			m_aerial_vehicle = spawn_anim_model( "fxanim_ambient_drone_" + n_random_drone, v_av_origin, v_av_angles );
//			m_aerial_vehicle = spawn_anim_model( "fxanim_ambient_drone_1", v_av_origin, v_av_angles );
			m_aerial_vehicle SetForceNoCull();
			m_aerial_vehicle.targetname = "fxanim_ambient_drone";
	
			level thread anim_loop( m_aerial_vehicle, str_ambient_anim );
	
			m_aerial_vehicle thread _remove_fxanim_av( n_cos_player_fov, s_bb_ambient.n_seconds );
			
			level.n_av_models++;
			
			if ( RandomInt( 2 ) == 1 )
			{
				a_f35_ambient_anims thread _fxanim_aerial_f35( v_av_origin, v_av_angles, n_random_anim, m_aerial_vehicle, n_cos_player_fov );
			}
		}
		
		wait 0.05;
	}
}

_fxanim_aerial_f35( v_av_origin, v_av_angles, n_random_anim, m_drone, n_cos_player_fov )
{
	wait 0.4;
	
	can_player_see_f35 = within_fov( level.player.origin, level.player.angles, v_av_origin, n_cos_player_fov );
	if ( !can_player_see_f35 )
	{
		s_f35_ambient = self[ n_random_anim ];
		str_ambient_anim = s_f35_ambient.str_ambient_anim;
		
		m_f35 = spawn_anim_model( "fxanim_ambient_f35", v_av_origin, v_av_angles );
		m_f35 SetForceNoCull();
		m_f35.targetname = "fxanim_ambient_drone";
		
		level thread anim_loop( m_f35, str_ambient_anim );
		
		//m_f35 thread _fxanim_shoot( m_drone );
		m_f35 thread _remove_fxanim_av( n_cos_player_fov, s_f35_ambient.n_seconds );
		
		level.n_av_models++;
	}
}

_fxanim_shoot( m_drone )
{
	self endon( "death" );
	
	while ( true )
	{
		//v_missile_org = self GetTagOrigin( "tag_turret" );
		v_gunner_org_1 = self GetTagOrigin( "tag_flash_gunner1" );
		v_gunner_org_2 = self GetTagOrigin( "tag_flash_gunner2" );
		
		if ( IsDefined( m_drone ) )
		{
			//MagicBullet( "f35_missile_turret", v_missile_org, m_drone.origin );
			MagicBullet( "f35_side_minigun", v_gunner_org_1, m_drone.origin );
			MagicBullet( "f35_side_minigun", v_gunner_org_2, m_drone.origin );
		}
		
		wait 0.24;
	}
}

_create_fxanim_ambient_info( str_ambient_anim, n_seconds )
{
	s_bb_ambient = SpawnStruct();
	s_bb_ambient.str_ambient_anim = str_ambient_anim;
	s_bb_ambient.n_seconds = n_seconds;
	
	return s_bb_ambient;
}

_remove_fxanim_av( n_cos_player_fov, n_seconds )
{
	self endon( "death" );
	
	wait n_seconds;
	
	while ( within_fov( level.player.origin, level.player.angles, self.origin, n_cos_player_fov ) )
	{
		wait 1;
	}
	
	level.n_av_models--;
	
	self Delete();
}

fade_to_black( n_time )
{
	hud = get_fade_hud();
	hud.alpha = 0;
	
	if ( IsDefined( n_time ) && ( n_time > 0 ) )
	{
		hud FadeOverTime( n_time );
		hud.alpha = 1;
		
		wait n_time;
	}
	else
	{
		hud.alpha = 1;
	}
}

fade_from_black( n_time )
{
	hud = get_fade_hud();
	hud.alpha = 1;
	
	if ( IsDefined( n_time ) && ( n_time > 0 ) )
	{
		hud FadeOverTime( n_time );
		hud.alpha = 0;
		
		wait n_time;
	}
	
	if ( IsDefined( level.fade_hud ) )
	{
		level.fade_hud Destroy();
	}	
}

get_fade_hud()
{
	if ( !IsDefined( level.fade_hud ) )
	{
		level.fade_hud = NewHudElem();
		level.fade_hud.x = 0;
		level.fade_hud.y = 0;
		level.fade_hud.horzAlign  = "fullscreen";
		level.fade_hud.vertAlign  = "fullscreen";
		level.fade_hud.foreground = false; //Arcade Mode compatible
		level.fade_hud.sort = 0;
		level.fade_hud.alpha = 0;
		level.fade_hud SetShader( "black", 640, 480 );
	}
	
	return level.fade_hud;
}

fade_with_shellshock_and_visionset()
{
	current_vision_set = level.player GetVisionSetNaked();
	if ( current_vision_set == "" )
	{
		current_vision_set = "default";
	}
	
	level thread maps\_shellshock::main( level.player.origin, 13, 256, 0, 0, 0, undefined, "khe_sanh_woods", 0 ); 
		
	VisionSetNaked( "la_1_crash_exit" );
		
	wait 13;
		
	fade_from_black( 0 );
		
	VisionSetNaked( current_vision_set, 10);
}

veh_brake_unload()
{
	self endon( "death" );
	self waittill( "brake" );
	
	self playsound( "evt_van_incoming" );
	
	while ( self GetSpeedMPH() > 2 )
	{
		wait .1;
	}
	
	self notify( "unload" );
}

/@
"Name: func_on_notify( <str_notify>, <func>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: self waits for a notify, then runs a function with up to five optional input arguments."
"Module: Utility"
"CallOn: Anything. Entities, vehicles, level, etc."
"MandatoryArg: <str_notify> : notify that self will wait for"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: [param_1] : parameter 1 to pass to the func"
"OptionalArg: [param_2] : parameter 2 to pass to the func"
"OptionalArg: [param_3] : parameter 3 to pass to the func"
"OptionalArg: [param_4] : parameter 4 to pass to the func"
"OptionalArg: [param_5] : parameter 5 to pass to the func"
"Example: vh_van thread func_on_notify( "break_formation", ::roadblock_behavior );"
"SPMP: SP"
@/ 
func_on_notify( str_notify, func, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( IsDefined( str_notify ), "str_notify is a required parameter for func_on_notify" );
	Assert( IsDefined( func ), "func is a required parameter for func_on_notify" );
	
	self thread _func_on_notify( str_notify, func, param_1, param_2, param_3, param_4, param_5 );
}

_func_on_notify( str_notify, func, param_1, param_2, param_3, param_4, param_5 )
{
	self endon( "death" );
	self waittill( str_notify );	
	single_thread( self, func, param_1, param_2, param_3, param_4, param_5 );
}

/@
"Name: add_trigger_function( <str_trig_targetname>, <func>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: Runs a function when a trigger is hit."
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_trig_targetname> : targetname of the trigger"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: [param_1] : parameter 1 to pass to the func"
"OptionalArg: [param_2] : parameter 2 to pass to the func"
"OptionalArg: [param_3] : parameter 3 to pass to the func"
"OptionalArg: [param_4] : parameter 4 to pass to the func"
"OptionalArg: [param_5] : parameter 5 to pass to the func"
"Example: add_trigger_function( "my_trigger", ::my_trigger_function );"
"SPMP: SP"
@/ 
add_trigger_function( str_trig_targetname, func, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( IsDefined( str_trig_targetname ), "str_trig_targetname is a required parameter for add_trigger_function" );
	Assert( IsDefined( func ), "func is a required parameter for add_trigger_function" );
	
	t_trig = GetEnt( str_trig_targetname, "targetname" );
	Assert( IsDefined( t_trig ), "Trigger \"" + str_trig_targetname + "\" doesn't exist for add_trigger_function." );
	
	t_trig thread _do_trigger_function( func );
}

_do_trigger_function( func )
{
	self endon( "death" );
	self waittill( "trigger", e_who );
	single_func( self, func, e_who );
}

get_forward( b_flat, str_tag )
{
	if ( !IsDefined( b_flat ) )
	{
		b_flat = false;
	}
	
	if ( IsPlayer( self ) )
	{
		v_angles = level.player GetPlayerAngles();
	}
	else
	{
		if ( IsDefined( str_tag ) )
		{
			v_angles = self GetTagAngles( str_tag );
		}
		else
		{
			v_angles = self.angles;
		}
	}
	
	if ( b_flat )
	{
		v_angles = FLAT_ANGLES( v_angles );
	}
	
	v_forward = AnglesToForward( v_angles );
	return v_forward;
}

/@
"Name: delete_ents( <str_name>, [str_key] )"
"Summary: Deletes entities and ingores if they don't exist."
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_name> : identifier of entity."
"OptionalArg: [str_key] : the key of the specified id. defaults to targetname."
"Example: delete_ents( "event3_ents", "script_noteworthy" );"
"SPMP: SP"
@/ 
delete_ents( str_name, str_key )
{
	Assert( IsDefined( str_name ), "str_name is a required argument for delete_ents()" );
	
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	array_func( GetEntArray( str_name, str_key ), ::self_delete );
}


// get the local coordinates to a common volume between LA_1 and LA_2, which is centered at the F35
get_transition_vector_string()
{
	// get common volume
	e_volume = get_ent( "la_transition_volume", "targetname", true );	
	
	// get object position in world space
	v_player_origin_world = self.origin;
	
	// convert object position to local space of volume
	v_player_origin_local = e_volume WorldToLocalCoords( v_player_origin_world );
	
	// convert local space vector to string that can be parsed correctly by GetDvarVector
	str_local_coordinates = ( v_player_origin_local[ 0 ] + " "
						  	+ v_player_origin_local[ 1 ] + " "
							+ v_player_origin_local[ 2 ] );
	
	return str_local_coordinates;
}

// use vector from GetDvarVector within la_1 volume and change it to la_2 world coordinates
la_convert_local_position_to_world( v_local )
{
	e_volume = get_ent( "la_transition_volume", "targetname", true );
	v_world = e_volume LocalToWorldCoords( v_local );
	
	return v_world;
}

/@
"Name: play_fx( <fx>, <v_origin>, <v_angles>, <n_time_to_delete>, [b_link_to_self], [str_tag] )"
"Summary: Deletes entities and ingores if they don't exist."
"Module: Utility"
"CallOn: level or entity to link fx to"
"MandatoryArg: <fx> : identifier of fx."
"MandatoryArg: <v_origin> : origin to play fx."
"MandatoryArg: <v_angles> : angles to play fx."
"MandatoryArg: <n_time_to_delete> : when to delete to fx entity. can be undefined if linking to an ent. it will die when it dies."
"OptionalArg: [b_link_to_self] : set to true to link to the entity this function is called on."
"OptionalArg: [str_tag] : tag to link to if linking."
"Example: delete_ents( "event3_ents", "script_noteworthy" );"
"SPMP: SP"
@/ 
play_fx( fx, v_origin, v_angles, n_time_to_delete, b_link_to_self, str_tag )
{
	m_fx = spawn_model( "tag_origin", v_origin, v_angles );
	
	if ( IS_TRUE( b_link_to_self ) )
	{
		if ( IsDefined( str_tag ) )
		{
			m_fx LinkTo( self, str_tag, (0, 0, 0), (0, 0, 0) );
		}
		else
		{
			m_fx LinkTo( self );
		}
	}
	
	PlayFXOnTag( getfx( fx ), m_fx, "tag_origin" );
	m_fx thread _play_fx_delete( self, n_time_to_delete );
}

_play_fx_delete( ent, n_time_to_delete )
{
	if ( IsDefined( n_time_to_delete ) )
	{
		if ( IsString( n_time_to_delete ) )
		{
			ent waittill_either( "death", n_time_to_delete );
		}
		else if ( n_time_to_delete > 0 )
		{
			ent waittill_notify_or_timeout( "death", n_time_to_delete );
		}
		else
		{
			ent waittill( "death" );
		}
	}
	else
	{
		ent waittill( "death" );
	}
	
	self Delete();
}

cleanup( ent )
{
	if ( IsDefined( ent ) )
	{
		ent Delete();
	}
}

cleanup_array( a_ents )
{
	array_delete( a_ents );
}

cleanup_kvp( str_value, str_key )
{
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	a_ents = GetEntArray( str_value, str_key );
	cleanup_array( a_ents );
}

set_goal_to_current_pos()
{
	self SetGoalPos( self.origin );
}

police_car()
{
	self endon( "death" );
	wait RandomFloatRange( .05, 2 );
	self thread police_car_audio();
	play_fx( "siren_light", undefined, undefined, -1, true, "tag_fx_siren_lights" );
}

police_car_audio()
{
	sound_ent = spawn( "script_origin" , self.origin);
	sound_ent playloopsound( "amb_radio_chatter_loop" ,  .5 );
	self waittill( "death" );
	sound_ent delete();
}

police_motorcycle()
{
	self endon( "death" );
	wait RandomFloatRange( .05, 2 );
	play_fx( "siren_light", undefined, undefined, -1, true, "tag_fx_siren_lights" );
}

is_police_car( ent )
{
	if ( IsDefined( ent.model ) )
	{
		if ( ent.model == "veh_iw_civ_policecar_whole"
		    || ent.model == "veh_iw_civ_policecar_radiant"
		    || ent.model == "veh_iw_civ_policecar_static" )
		{
			return true;
		}
	}
	
	return false;
}

is_police_motorcycle( ent )
{
	if ( IsDefined( ent.model ) )
	{
		if ( ent.model == "veh_t6_civ_police_motorcycle" )
		{
			return true;
		}
	}
	
	return false;
}

waittill_not_god_mode()
{
	while ( IsGodMode( self ) )
	{
		wait .05;
	}
}

new_timer()
{
	s_timer = SpawnStruct();
	s_timer.n_time_created = GetTime();
	return s_timer;
}

get_time()
{
	t_now = GetTime();
	return t_now - self.n_time_created;
}

get_time_in_seconds()
{
	return get_time() / 1000;
}


/@
"Name: add_scripted_damage_state( <n_percentage_to_change_state>, <func_on_state_change> )"
"Summary: Adds a custom damage state to an entity, such as a vehicle. To add several states, just call this function multiple times. Also supports custom health values (.armor)."
"Module: level"
"CallOn: Any entity that can take damage. Use as a spawn function."
"MandatoryArg: <n_percentage_to_change_state>: Percentage health to change state and run func_on_state_change. Should be between 0 and 1."
"MandatoryArg: <func_on_state_change>: function pointer that points to a function to run when state changes. For instance, it could play a sound and FX."
"Example: vh_presidents_vehicle add_scripted_damage_state( 0.25, ::play_low_health_fx );"
"SPMP: singleplayer"
@/ 
add_scripted_damage_state( n_percentage_to_change_state, func_on_state_change )  // self = entity that can receive the 'damage' notify
{
	Assert( IsDefined( n_percentage_to_change_state ), "n_percentage_to_change_state is a required argument for add_scripted_damage_state!" );
	Assert( ( ( n_percentage_to_change_state > 0 ) && ( n_percentage_to_change_state < 1 ) ), "add_scripted_damage_state was passed an invalue percentage to change state. Passed " + n_percentage_to_change_state + ", but valid range is between 0 and 1." );
	Assert( IsDefined( func_on_state_change ), "func_on_state_change is a required argument for add_scripted_damage_state!" );
	Assert( ( IsDefined( self.health ) || IsDefined( self.armor ) ), "no .health or .armor parameter found on entitiy" + self GetEntityNumber() + " at position " + self.origin );

	// use .health if no .armor value is used	
	b_use_custom_health = IsDefined( self.armor );
	
	n_health_max = self.health;
	
	if ( b_use_custom_health )
	{
		n_health_max = self.armor;
	}
	
	b_state_changed = false;
	n_damage_to_change_state = n_health_max * n_percentage_to_change_state;
	
	while ( !b_state_changed )
	{
		self waittill( "damage", n_damage );
		
		n_current_health = self.health;
		
		if ( b_use_custom_health )
		{
			n_current_health = self.armor;
		}
		
		if ( n_current_health < n_damage_to_change_state )
		{
			b_state_changed = true;
		}
	}
	
	self [[ func_on_state_change ]]();
}


// checks dvar to see if this is a green light build. to skip, put '+set skip_greenlight_build 1' in remote console
is_greenlight_build()
{
	b_is_greenlight_build = true;
	
	if ( GetDvar( "skip_greenlight_build" ) != "" && GetDvarInt( "skip_greenlight_build" ) == 1 )
	{
		b_is_greenlight_build = false;
	}
	
	return b_is_greenlight_build;
}

end_greenlight_demo()
{
	iprintlnbold( "Green Light section ends" );
	
	wait 2;
	
	nextmission();
}

sam_visionset()
{
	self endon( "death" );
	
	while ( true ) 
	{
		self waittill( "missileTurret_on" );
		ClientNotify( "sam_on" );
		
		battlechatter_off( "allies" );
		battlechatter_off( "axis" );
		
		visionset = self GetVisionSetNaked();
		self VisionSetNaked( "sam_turret", 0.5 );
		
		level thread sam_hint();
		
		self waittill( "missileTurret_off" );
		ClientNotify( "sam_off" );
		
		battlechatter_on( "allies" );
		battlechatter_on( "axis" );
		
		self VisionSetNaked( visionset, 0 );
		
		level notify( "sam_event_done" );
	}
}

sam_hint()
{
	level endon( "sam_event_done" );
	
	screen_message_create( &"LA_1_SAM_HINT_ADS", &"LA_1_SAM_HINT_FIRE" );
	
	level waittill( "sam_hint_drone_killed" );
	
	screen_message_delete();
}

scale_model_LODs( n_lod_scale_rigid, n_lod_scale_skinned )
{
	Assert( IsDefined( n_lod_scale_rigid ), "n_lod_scale_rigid is a required parameter for scale_model_LODs!" );
	Assert( IsDefined( n_lod_scale_skinned ), "n_lod_scale_skinned is a required parameter for scale_model_LODs!" );
	
	level.player SetClientDvar( "r_lodScaleRigid", n_lod_scale_rigid );
	level.player SetClientDvar( "r_lodScaleSkinned", n_lod_scale_skinned );
}