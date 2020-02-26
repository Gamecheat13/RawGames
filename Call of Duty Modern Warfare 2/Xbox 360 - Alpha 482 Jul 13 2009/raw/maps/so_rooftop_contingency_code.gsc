#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_vehicle;

get_wave_count()
{
	return level.wave_spawn_structs.size;
}

get_wave_ai_count( wave_num )
{
	return level.wave_spawn_structs[ wave_num ].hostile_count;
}

get_wave_vehicles( wave_num )
{
	return level.wave_spawn_structs[ wave_num ].vehicles;
}

get_vehicle_type_count( wave_num, type )
{
	count = 0;

	vehicles = get_wave_vehicles( wave_num );
	foreach ( vehicle in vehicles )
	{
		if ( vehicle.type == type )
		{
			count++;
		}
	}

	return count;
}


// UAV Section ---------------------------------------------- //
uav_pickup_setup()
{
	uav_pickup = GetEnt( "uav_controller", "targetname" );
	AssertEx( IsDefined( uav_pickup ), "Missing UAV controller pickup objective model in level." );

	uav_pickup Hide();
	flag_wait( "wave_2_started" );

	while ( 1 )
	{
		//level waittill( "new_wave_started" );
		wait( 2 );
		uav_pickup Show();

		uav_pickup MakeUsable();
		uav_pickup SetCursorHint( "HINT_NOICON" );
		// Hold &&1 to pick up
		uav_pickup SetHintString( &"SO_ROOFTOP_CONTINGENCY_DRONE_PICKUP" );
		uav_pickup waittill( "trigger", player );

		level.so_uav_picked_up = true;
		level.so_uav_player = player;

		if ( !isdefined( player.already_displayed_hint ) )
		{
			player.already_displayed_hint = 1;
			player display_hint( "use_uav" );
		}

		flag_set( "uav_in_use" );
		player GiveWeapon( level.remote_detonator_weapon );
		player SetActionSlot( 4, "weapon", level.remote_detonator_weapon );

		//player SetWeaponAmmoStock( level.remote_detonator_weapon, level.allowed_uav_ammo );
//		player SetWeaponAmmoClip( level.remote_detonator_weapon, level.allowed_uav_ammo );
//		player thread take_weapon_when_no_ammo( level.remote_detonator_weapon );

		uav_pickup MakeUnusable();
		uav_pickup Hide();

		if ( !level.UAV_pickup_respawn )
		{
			return;
		}

		flag_waitopen( "uav_in_use" );
		wait level.uav_spawn_delay;// delay between uav spawns
	}
}

//take_weapon_when_no_ammo( weapon )
//{
//	self endon( "death" );
//
//	level.uav.ammo_count = level.allowed_uav_ammo;
//	self thread missile_ammo_think();
//
//	// self is player
//	while ( 1 )
//	{
//		wait 2;
//		if ( level.uav.ammo_count <= 0 )
//		{
//			self TakeWeapon( weapon );
//			self SetActionSlot( 4, "" );
//			flag_clear( "uav_in_use" );
//			return;
//		}
//		flag_set( "uav_in_use" );
//	}
//}
//
//missile_ammo_think()
//{
//	level.uav endon( "death" );
//	self endon( "death" );
//
//	while ( 1 )
//	{
//		level waittill( "player_fired_remote_missile" );
//		level.uav.ammo_count--;
//		self SetWeaponAmmoClip( level.remote_detonator_weapon, level.uav.ammo_count );
//		RefreshHudAmmoCounter();
//	}
//}

uav()
{
	flag_wait( "wave_2_started" );
	thread dialog_uav();

	level.uav = spawn_vehicle_from_targetname_and_drive( "second_uav" );

	level.uav PlayLoopSound( "uav_engine_loop" );
	level.uavRig = Spawn( "script_model", level.uav.origin );
	level.uavRig SetModel( "tag_origin" );
	thread uav_rig_aiming();

	//thread do_loop_path( GetVehicleNode( "uav_detour", "targetname" ) );

	/*
	if ( level.players.size > 1 )
		array_thread( level.players, ::monitor_uav_usage );
	
	foreach( player in level.players )
	{
		player GiveWeapon( level.remote_detonator_weapon );
		player SetActionSlot( 4, "weapon", level.remote_detonator_weapon );
	}
	*/
}

/*
monitor_uav_usage()
{
	level.uav endon( "death" );
	self endon( "death" );
	
	while( 1 )
	{
		last_weapon = self GetCurrentWeapon();
		self waittill( "weapon_change" );

		if ( self GetCurrentWeapon() != level.remote_detonator_weapon )
			continue;
			
		if ( level.uav.in_use )
		{
			// force switch weapon out of remote missile
			weaponlist = self GetWeaponsListAll();
			newweapon = weaponlist[0];
			foreach ( weapon in weaponlist )
			{
				if( weapon != level.remote_detonator_weapon )
					newwapon = weapon;
			}
			self SwitchToWeapon( newweapon );

			/#
			so_debug_print( "UAV is in use by other player" );
			#/
			continue;
		}

		if ( self GetCurrentWeapon() == level.remote_detonator_weapon )
		{
			/#
			so_debug_print( "a player uses UAV" );
			#/
			level.uav.in_use = 1;
			self waittill( "weapon_change" );
			level.uav.in_use = 0;
			
			/#
			so_debug_print( "a player stops using UAV" );
			#/
		}
	}
}
*/

/*
do_loop_path( vnode )
{
	end_node = GetVehicleNode( "uav_path_end", "targetname" );
	end_node waittill( "trigger" );
	level.uav thread vehicle_paths( vnode );
}*/

dialog_uav()
{
	//The UAV is almost in position.	
	radio_dialogue( "cont_cmt_almostinpos" );
}

uav_rig_aiming()
{
	if ( !isalive( level.uav ) )
	{
		return;
	}

	if ( IsDefined( level.uav_is_destroyed ) )
	{
		return;
	}

	focus_points = GetEntArray( "uav_focus_point", "targetname" );

	level endon( "uav_destroyed" );
	level.uav endon( "death" );
	for ( ;; )
	{
		closest_focus = getClosest( level.player.origin, focus_points );
		targetPos = closest_focus.origin;
		angles = VectorToAngles( targetPos - level.uav.origin );
		level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
		level.uavRig RotateTo( ANGLES, 0.10, 0, 0 );
		wait( 0.05 );
	}
}

// Vehicles -----------------------------------------------

setup_base_vehicles()
{
	self endon( "death" );

	self thread maps\_remotemissile::setup_remote_missile_target();

	self thread unload_when_stuck();
	self waittill( "unloaded" );

    if ( IsDefined( self.has_target_shader ) )
    {
		self.has_target_shader = undefined;
		Target_Remove( self );
    }

	level.remote_missile_targets = array_remove( level.remote_missile_targets, self );
}

unload_when_stuck()
{
	self endon( "unloaded" );
	self endon( "unloading" );

	self endon( "death" );
	while ( 1 )
	{
		wait( 2 );
		if ( self Vehicle_GetSpeed() < 2 )
		{
			self Vehicle_SetSpeed( 0, 15 );
			self thread maps\_vehicle::vehicle_unload();
			return;
		}
	}
}

spawn_vehicle_and_go( struct )
{
	spawner = struct.ent;

	if ( IsDefined( struct.delay ) )
	{
		wait( struct.delay );
	}

	if ( IsDefined( struct.alt_node ) )
	{
		targetname = struct.alt_node.targetname;

		spawner.target = targetname;
	}

	vehicle = spawner spawn_vehicle();

	vehicle StartPath();
//	vehicle thread force_unload( spawner.target + "_end" );

	/#
	so_debug_print( "vehicle[" + spawner.targetname + "] spawned" );
	vehicle waittill( "unloading" );
	so_debug_print( "vehicle[" + spawner.targetname + "] unloading guys" );
	vehicle waittill( "unloaded" );
	so_debug_print( "vehicle[" + spawner.targetname + "] unloading complete" );
	#/
}

force_unload( end_name )
{
//	end_node = get_last_ent_in_chain( sEntityType );

	end_node = GetVehicleNode( end_name, "targetname" );
	end_node waittill( "trigger" );

	self Vehicle_SetSpeed( 0, 15 );
	wait 1;
	self maps\_vehicle::vehicle_unload();
}

// HUD ----------------------------------------------------
hud_hostile_count()
{
	// Hostiles:
	hudelem_title = so_create_hud_item( 2, so_hud_ypos(), &"SO_ROOFTOP_CONTINGENCY_HOSTILES", self );
	hudelem_count = so_create_hud_item( 2, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH", self );
	hudelem_count.alignx = "left";

/*	thread info_hud_handle_fade( hudelem_title, "stop_fading_count" );
	thread info_hud_handle_fade( hudelem_count, "stop_fading_count" );*/

	while ( !flag( "challenge_success" ) )
	{
		curr_count = level.hostile_count;
		if ( curr_count > 0 )
			hudelem_count.label = level.hostile_count;
		else
			hudelem_count.label = &"SPECIAL_OPS_DASHDASH";

		while ( !flag( "challenge_success" ) && ( curr_count == level.hostile_count ) )
		{
			wait( 0.05 );
		}
	}

	// --
	hudelem_count.label = &"SPECIAL_OPS_DASHDASH";

	hudelem_title SetPulseFX( 0, 1500, 500 );
	hudelem_count SetPulseFX( 0, 1500, 500 );

	wait( 2 );

	hudelem_title Destroy();
	hudelem_count Destroy();
	level notify( "stop_fading_count" );
}

hud_new_wave()
{
	current_wave = level.current_wave + 1;

	if ( current_wave > get_wave_count() )
	{
		return;
	}

	// Next Wave in: 
	wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_STARTS";
	wave_delay = 0.75;
	if ( current_wave == get_wave_count() )
	{
		// Final Wave in: 
		wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_FINAL_STARTS";
	}
	else
	{
		if ( current_wave == 2 )
		{
			// Second Wave in: 
			wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_SECOND_STARTS";
		}

		if ( current_wave == 3 )
		{
			// Third Wave in: 
			wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_THIRD_STARTS";
		}

		if ( current_wave == 4 )
		{
			// Fourth Wave in: 
			wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_FOURTH_STARTS";
		}
	}

	thread enable_countdown_timer( level.wave_delay, false, wave_msg, wave_delay );
	wait 2;
	hud_wave_splash( current_wave, level.wave_delay - 2 );


/*
	hudelem = so_create_hud_item( 0, so_hud_ypos(), wave_msg );
	hudelem SetPulseFX( 50, level.wave_delay * 1000, 500 );

	hudelem_time = so_create_hud_item( 0, so_hud_ypos(), "" );
	hudelem_time.alignX = "left";
	hudelem_time SetTenthsTimer( level.wave_delay );
	hudelem_time SetPulseFX( 50, level.wave_delay * 1000, 500 );

	wait( level.wave_delay );*/
}

// Returns structs...
hud_get_wave_list( wave_num )
{
	list = [];

	list[ 0 ] = SpawnStruct();

	switch( wave_num )
	{
		case 1:
			// - Wave 1 -
			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE1";
			break;

		case 2:
			// - Wave 2 -
			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE2";
			break;

		case 3:
			// - Wave 3 -
			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE3";
			break;

		case 4:
			// - Wave 4 -
			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE4";
			break;

		case 5:
			// - Wave 5 -
			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE5";
			break;

		default:
			AssertMsg( "Wrong wave_num passed in" );
			break;
	}

	list[ 1 ] = SpawnStruct();
	// &&1 Hostiles
	list[ 1 ].text = &"SO_ROOFTOP_CONTINGENCY_HOSTILES_COUNT";
	list[ 1 ].count = get_wave_ai_count( wave_num );

	index = 2;

	// Figure out vehicles
	uaz_count = get_vehicle_type_count( wave_num, "uaz" );
	if ( uaz_count > 0 )
	{
		if ( uaz_count == 1 )
		{
			// &&1 UAZ Vehicle
			str = &"SO_ROOFTOP_CONTINGENCY_UAZ_COUNT_SINGLE";
		}
		else
		{
			// &&1 UAZ Vehicles
			str = &"SO_ROOFTOP_CONTINGENCY_UAZ_COUNT";
		}

		list[ index ] = SpawnStruct();
		list[ index ].text = str;
		list[ index ].count = uaz_count;
		index++;
	}

	bm21_count = get_vehicle_type_count( wave_num, "bm21" );
	if ( bm21_count > 0 )
	{
		if ( bm21_count == 1 )
		{
			// &&1 BM21 Troop Carrier
			str = &"SO_ROOFTOP_CONTINGENCY_BM21_COUNT_SINGLE";
		}
		else
		{
			// &&1 BM21 Troop Carriers
			str = &"SO_ROOFTOP_CONTINGENCY_BM21_COUNT";
		}

		list[ index ] = SpawnStruct();
		list[ index ].text = str;
		list[ index ].count = bm21_count;
	}

	return list;
}

hud_create_wave_splash( yLine, message )
{
	hudelem = so_create_hud_item( yLine, 0, message );
	hudelem.alignX = "center";
	hudelem.horzAlign = "center";

	return hudelem;
}

hud_wave_splash( wave_num, timer )
{
	hudelems = [];
	list = hud_get_wave_list( wave_num );
	for ( i = 0; i < list.size; i++ )
	{
		hudelems[ i ] = hud_create_wave_splash( i, list[ i ].text );

		if ( IsDefined( list[ i ].count ) )
		{
			hudelems[ i ] SetValue( list[ i ].count );
		}

		hudelems[ i ] SetPulseFX( 60, ( ( timer - 1 ) * 1000 ) - ( i * 1000 ), 1000 );

		wait( 1 );
	}

	wait( timer - ( list.size * 1 ) );

	foreach ( hudelem in hudelems )
	{
		hudelem Destroy();
	}
}

// DEBUG ---------------------------------------------------
so_debug_print( msg, delay )
{
	message = "> " + msg;

	if ( IsDefined( delay ) )
	{
		wait delay;
		message = "+>" + message;
	}
	else
	{
		message = ">>" + message;
	}

	if ( GetDvar( "specialops_debug" ) == "1" )
		IPrintLn( message );
}