#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_hud_util;

//--------------------------
// Init section
//--------------------------
init_level()
{
	set_empty_promotion_order( "y" );
	set_empty_promotion_order( "o" );

	PrecacheMenu( "offensive_skip" );

	init_sas_squad();
	init_dvars();
	init_level_flags();
	init_sound_settings();
	init_spawn_funcs();
	maps\_drone_civilian::init(); 
	maps\_drone_ai::init(); 
    maps\london_amb::main();

	level.friendlyfire_destructible_attacker = true;
	level.friendly_respawn_lock_func = ::friendly_respawn_lock;

	maps\_compass::setupMiniMap( "compass_map_london_start", "start_minimap_corner" );
}

init_sas_squad()
{
/#
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
#/

	sas = GetEntArray( "sas_squad", "targetname" );
	level.sas_squad = [];
	foreach ( guy in sas )
	{
		guy thread magic_bullet_shield();

		if ( IsDefined( guy.script_noteworthy ) && guy.script_noteworthy == "sas_leader" )
		{
			guy.animname = "sas_leader";
			level.sas_leader = guy;
			level.sas_squad = array_insert( level.sas_squad, guy, 0 );
			continue;
		}
		else
		{
			guy.animname = "sas_guy";
		}

		level.sas_squad = array_add( level.sas_squad, guy ); 
	}
}

// TODO: Cleanup flags, remove unused.
init_level_flags()
{
	// UAV section ----------------------------------------
	flag_init( "trucks_are_moving" );
	flag_init( "uav_focusing_on_player" );
	flag_init( "uav_focusing_on_enemies" );
	flag_init( "uav_focusing_on_enemies2" );
	flag_init( "uav_slamzoom" );
	flag_init( "uav_slamzoom_done" );
	flag_init( "uav_dialog_done" );

	// Alley/Docks Section --------------------------------
	flag_init( "start_fence_climb" );
	flag_init( "docks_assault" );
	flag_init( "docks_on_the_trail" );
	flag_init( "docks_entrance" );
	flag_init( "docks_check_truck" );
	flag_init( "docks_open_truck_door" );
	flag_init( "docks_truck_door_opened" );
	flag_init( "docks_truck_searched" );
	flag_init( "docks_ambush" );
	flag_init( "docks_shoot_catwalk" );
	flag_init( "docks_almost_to_street" );
	flag_init( "docks_street" );
	flag_init( "slamzoom_rotate" );
	flag_init( "docks_littlebird_rocket" );
	flag_init( "warehouse_sniper_done" );

	flag_init( "alley_start" );
	flag_init( "alley_begin_movement" );
	flag_init( "alley_leader_headstart" );

	flag_init( "alley_enemy_cellphone_dead" );
	flag_init( "alley_enemy_sleeping_dead" );
	flag_init( "alley_enemy_warehouse_dead" );
	flag_init( "last_alley_dialogue_done" );
	flag_count_set( "alley_enemy_warehouse_dead", 2 );

	flag_init( "docks_enemy_fallback" );
	flag_init( "alley_sas_breacher_dialog" );

	flag_init( "warehouse_breacher_enter" );
	flag_init( "warehouse_breacher_in_position" );

	flag_init( "warehouse2_breach_go" );
	flag_count_set( "warehouse2_breach_go", 3 );
	flag_init( "warehouse2_breach_enter" );
	flag_init( "warehouse2_breach_go_dialog" );
	flag_init( "warehouse2_done" );

	flag_init( "warehouse_melee_ready" );

	flag_init( "warehouse_exit_dialogue_done" );
	flag_init( "warehouse_complete" );
	flag_init( "warehouse_exit" );
	flag_init( "sas_van_destroyed" );
	flag_init( "snipers_in_position" );

	flag_init( "player_open_doors" );

	flag_init( "docks_after_ambush" );
	flag_init( "docks_sas_get_in_position" );
	flag_init( "docks_assault_start" );

	flag_init( "london_warehouse_door_kicked" );

	flag_init( "docks_reiterate_action" );

	flag_init( "sewer_pipes_done" );

	flag_init( "littlebird_at_catwalk" );
	flag_init( "littlebird_rpg_shot" );
	
	flag_init( "ride_without_wait" );
	flag_init( "riding_train_already" );
	flag_init( "friendly_truck_fast_load" );
	
	flag_init( "friendly_truck_other_fast_load" );
	
	//train chase
	flag_init( "transition_to_train" );
    flag_init( "train_goes" );
    flag_init( "player_mount_car_complete" );
    flag_init( "train_chase_ended" );
    flag_init( "last_guy_running_to_train" );
    flag_init( "player_mounts_car" );
    flag_init( "start_train_encounter" );
    flag_init( "teleport_to_west" );
    flag_init( "train_crashed" );
    flag_init( "train_crashing" );
    flag_init( "rocky_road" );
    flag_init( "guys_shot_enough_at_train" );
    flag_init( "train_crash_fast_forward" );
//	flag_init( "slow_mo" );



	// Westminster station	
	flag_init( "escalator_grenade_thrown" );
	flag_init( "start_station_music" ); 
	flag_init( "start_train_traverse" );
	flag_init( "player_has_flashed" );
//	flag_init( "cleared_station_tunnel" );
	flag_init( "enemy_takedown" );
	flag_init( "truck_spawned" );
//	flag_init( "shots_fired" );
//	flag_init( "bomber_spawned" );
	flag_init( "setup_blockade" );
	flag_init( "truck_stopped" );
	flag_init( "truck_hit" );
//	flag_init( "bombs_light_up" );  
	flag_init( "truck_explodes" );
//	flag_init( "player_knocked_back" );
//	flag_init( "player_got_exploded" );
//	flag_init( "player_got_gassed" );
//	flag_init( "start_ending_music" );
	
	flag_init( "take_down_finished" );
//	flag_init( "start_innocent_scene" );

	flag_init( "westminster_entity_cleanup" );

//	flag_init( "show_objective_failed" );
	flag_init( "ending_police_car_stopped" );
//	flag_init( "gas_scene" );
//	flag_init( "gas_expand" );
//	flag_init( "gas_full" );
//	flag_init( "revive_flash" );
//	flag_init( "player_lookup" );
//	flag_init( "player_lookdown" );
//	flag_init( "player_explosion_anim_done" );
}

level_precache()
{
	// Strings
	PrecacheString( &"LONDON_OBJECTIVE_STACK_UP" );
	PrecacheString( &"LONDON_OBJECTIVE_CLEAR_WAREHOUSE" );
	PrecacheString( &"LONDON_OBJECTIVE_ASSAULT_DOCKS" );
	PrecacheString( &"LONDON_OBJECTIVE_CHASE_HOSTILES" );
	PrecacheString( &"LONDON_OBJECTIVE_CHASE_HOSTILES_TO_STATION" );
	PrecacheString( &"LONDON_OBJECTIVE_TRAIN_CHASE" );
	PrecacheString( &"LONDON_OBJECTIVE_TRAIN_TAILGATE" );
	PrecacheString( &"LONDON_OBJECTIVE_CLEAR_STATION" );

//    maps\_global_fx::main_pre_load();
	
//	london_west_fx_volume = GetEntArray( "london_west_fx_volume", "script_noteworthy" );
//	mask_destructibles_in_volumes( london_west_fx_volume );
//	mask_interactives_in_volumes( london_west_fx_volume );
//    mask_exploders_in_volume( london_west_fx_volume );

    westminster_tunnels_fx_volume = GetEntArray( "westminster_tunnels_fx_volume", "script_noteworthy" );
	mask_destructibles_in_volumes( westminster_tunnels_fx_volume );
	mask_interactives_in_volumes( westminster_tunnels_fx_volume );
    mask_exploders_in_volume( westminster_tunnels_fx_volume );
    
    westminster_tunnels_crash_fx_volume = GetEntArray( "westminster_tunnels_crash_fx_volume", "script_noteworthy" );
	mask_destructibles_in_volumes( westminster_tunnels_crash_fx_volume );
	mask_interactives_in_volumes( westminster_tunnels_crash_fx_volume );
    mask_exploders_in_volume( westminster_tunnels_crash_fx_volume );
        
	
}

init_sound_settings()
{
	//set up dynamic sound channels that will only be partially affected by slomo (taken from breach code)
	SoundSetTimeScaleFactor( "Music", 0 );
	SoundSetTimeScaleFactor( "Menu", 0 );
	SoundSetTimeScaleFactor( "local3", 0.0 );
	SoundSetTimeScaleFactor( "Mission", 0.0 );
	SoundSetTimeScaleFactor( "Announcer", 0.0 );
	SoundSetTimeScaleFactor( "Bulletimpact", .60 );
	SoundSetTimeScaleFactor( "Voice", 0.40 );
	SoundSetTimeScaleFactor( "effects1", 0.20 );
	SoundSetTimeScaleFactor( "effects2", 0.20 );
	SoundSetTimeScaleFactor( "local", 0.20 );
	SoundSetTimeScaleFactor( "local2", 0.20 );
	SoundSetTimeScaleFactor( "physics", 0.20 );
	SoundSetTimeScaleFactor( "ambient", 0.50 );
	SoundSetTimeScaleFactor( "auto", 0.50 );
}

init_dvars()
{
	// Spotlight
//	SetSavedDvar( "r_spotlightbrightness", "6" );
//	SetSavedDvar( "r_spotlightStartradius", "100" );
//	SetSavedDvar( "r_spotlightEndradius", "1000" );
//	SetSavedDvar( "r_spotlightfovinnerfraction", "0" );
//	SetSavedDvar( "r_spotlightexponent", "10" );
}

init_spawn_funcs()
{
	array_spawn_function_noteworthy( "rpg_vehicle", 			 ::postspawn_rpg_vehicle );
}

skip_ending_popup()
{
	if ( level.player GetLocalPlayerProfileData( "canSkipOffensiveMissions" ) != 1 )
	{
		return;
	}

	level.player OpenPopUpMenu( "offensive_skip" ); // this menu pauses the script
}

//--------------------------
// Start section
//--------------------------
set_start_locations( targetname, extra_guys, ignore_player )
{
	guys = GetEntArray( "sas_squad", "targetname" );
	structs = getstructarray( targetname, "targetname" );

    if ( !IsDefined( ignore_player ) )
        ignore_player = false;
        
    if( !ignore_player )
    	guys[ guys.size ] = level.player;

	if ( IsDefined( extra_guys ) )
	{
		guys = array_combine( guys, extra_guys );
	}

	// Move the AI/Player to "assigned" structs
	foreach ( guy in guys )
	{
		foreach ( struct in structs )
		{
			if ( IsDefined( struct.script_noteworthy ) )
			{
				if ( IsDefined( guy.script_noteworthy ) && struct.script_noteworthy == guy.script_noteworthy )
				{
					guy set_start_location_internal( struct );
					break;
				}
				else if ( IsPlayer( guy ) && struct.script_noteworthy == "player" )
				{
					guy set_start_location_internal( struct );
					break;
				}
			}
		}
	}

	// Move everyone else that hasn't been moved yet
	foreach ( guy in guys )
	{
		if ( IsDefined( guy._start_location_done ) )
		{
			continue;
		}

		foreach ( struct in structs )
		{
			if ( IsDefined( struct._start_location_done ) )
			{
				continue;
			}

			guy set_start_location_internal( struct );
			break;
		}
	}

	// Everyone is done moving to their starts, now remove the _start_lcoation_done
	foreach ( guy in guys )
	{
		guy._start_location_done = undefined;
	}

	foreach ( struct in structs )
	{
		struct._start_location_done = undefined;
	}
}

set_start_location_internal( struct )
{
	if ( IsPlayer( self ) )
	{
		self SetOrigin( struct.origin );
		self SetPlayerAngles( struct.angles );
	}
	else
	{
		self ForceTeleport( struct.origin, struct.angles );
		self SetGoalPos( struct.origin );

		// If the start point is targeting something
		// then have the AI target it as well.
		if ( IsDefined( struct.target ) )
		{
			self.target = struct.target;
		}
	}

	self._start_location_done = true;
	struct._start_location_done = true;
}

//---------------------------------------------------------
// Game Related section
//---------------------------------------------------------
friendly_respawn_lock()
{
	if ( !flag( "docks_street" ) )
	{
		wait( 7 );
	}
	else
	{
		wait( 2 );
	}
}

//---------------------------
// Utility Section
//---------------------------
spawn_and_animate()
{
	node = self;
	if ( IsDefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );

		if ( !IsDefined( node ) )
		{
			node = GetEnt( self.target, "targetname" );
		}		

		if ( !IsDefined( node ) )
		{
			node = getstruct( self.target, "targetname" );
		}
	}

	if ( !IsDefined( self.animname ) )
	{
		self.animname = "generic";
	}

	if ( IsDefined( self.script_animation ) )
	{
		anime = self.script_animation;
	}
	else
	{
		anime = node.script_animation;	
	}

	if ( IsDefined( self.script_parameters ) )
	{
		if ( self.script_parameters == "allowdeath" )
		{
			self.allowdeath = true;
		}
	}

	node anim_single_solo( self, anime );
}

MAX_SPOT_LIGHTS = 1;

stop_spotlight( struct )
{
    if ( !IsDefined( struct.entity ) )
        return;
    struct.entity endon ( "death" );

    StopFXOnTag( struct.effect_id , struct.entity, struct.tag_name );
    //waits here are paranoia, fx system can be weird about stopping and starting 
    if( ! spot_light_effect_pause() )
            return;

    // start the low budge version
    if ( IsDefined( struct.cheap_effect_id ) && IsDefined( struct.entity ) )
    {
        playFXOnTag( struct.cheap_effect_id , struct.entity, struct.tag_name );
        if( ! spot_light_effect_pause() )
            return;
    }
}

//whoever calls spot light last gets the spotlight
spot_light( fxname, cheapfx, tag_name, death_ent )
{
    //only let one go at a time.
    while ( IsDefined( level.spot_lighting_this_frame ) )
        wait 0.05;

    level.spot_lighting_this_frame = true;
    
    if ( !IsDefined( level.last_spot_light ) )
        level.last_spot_light = [];
        
    if( level.last_spot_light.size >= MAX_SPOT_LIGHTS  )
    {
        foreach( spotlight in level.last_spot_light )   
        {
            if( isdefined( spotlight.entity ) && spotlight.entity == self )
            {
                level.spot_lighting_this_frame = undefined;
                return;
            }
        }
        struct = level.last_spot_light[0];
        level.last_spot_light = array_remove( level.last_spot_light, struct );

        // stop the spotlight shadowmap version
        stop_spotlight( struct );

    }
    
    if( IsDefined( self.cheap_effect_id ) )
    {
        StopFXOnTag( self.spot_light.cheap_effect_id, self, self.spot_light.tag_name );
        self.cheap_effect_playing = undefined;
        self.cheap_effect_playing_tag = undefined;
        if( ! spot_light_effect_pause() )
            return;
    }
    
    struct = SpawnStruct();
    struct.effect_id = getfx( fxname );
    struct.cheap_effect_id = getfx( cheapfx );
    struct.entity = self;
    self.spot_light = struct;
    struct.tag_name = tag_name;
    
    playFXOnTag( struct.effect_id , struct.entity, struct.tag_name );
    
    if( isdefined( death_ent ) )
        thread spot_light_death( death_ent );

    level.last_spot_light[ level.last_spot_light.size ] = struct;
    level.spot_lighting_this_frame = undefined;

}

spot_light_effect_pause()
{
    // I only pause here because I don't trust StopFXOnTag / playFXOnTag happening on the same frame potentially on the same entity.
    wait 0.05;
    if( IsDefined( self ) )
        return true;
    level.spot_lighting_this_frame = undefined;
    return false;
}

stop_last_spot_light()
{
    if( !IsDefined( level.last_spot_light ) )
        return;
        
    foreach( spotlight in level.last_spot_light )
    {
        if ( !IsDefined( spotlight.entity ) )
            continue;
        // stop the spotlight shadowmap version
    	StopFXOnTag( spotlight.effect_id , spotlight.entity, spotlight.tag_name );
    }
    
	level.last_spot_light = [];
}

spot_light_death( death_ent )
{
    self notify ( "new_spot_light_death" );
    self endon ( "new_spot_light_death" );
    self endon ( "death" );
    death_ent waittill ( "death" );
    self Delete();
}

can_show_wip()
{
	return GetDvarInt( "show_wip" );
}

get_world_relative_offset( origin, angles, offset )
{
	cos_yaw = cos( angles[ 1 ] );
	sin_yaw = sin( angles[ 1 ] );

	// Rotate offset by yaw
	x = ( offset[ 0 ] * cos_yaw ) - ( offset[ 1 ] * sin_yaw );
	y = ( offset[ 0 ] * sin_yaw ) + ( offset[ 1 ] * cos_yaw );

	// Translate to world position
	x += origin[ 0 ];
	y += origin[ 1 ];
	return ( x, y, origin[ 2 ] + offset[ 2 ] );
}

wait_for_animtime_percent( animation, percent )
{
	self endon( "death" );
	while ( self GetAnimTime( animation ) < percent )
	{
		wait( 0.05 );
	}
}

view_cone_open( duration, left, right, up, down )
{
	level.player LerpViewAngleClamp( duration, duration * 0.5, duration * 0.5, left, right, up, down );
}

temp_print_pulse( msg, locked, time )
{
	ent = undefined;
	if ( IsDefined( locked ) )
	{
		ent = Spawn( "script_origin", level.player.origin );
		level.player PlayerLinkTo( ent );
	}

	if ( !IsDefined( time ) )
	{
		time = 5;
	}

	hud = newHudElem();
	hud.alignX = "center";
	hud.alignY = "middle";
	hud.sort = 1;
	hud.x = 320;
	hud.y = 240 + 100;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.fontscale = 2;
	hud.alpha = 1;
	hud.foreground = true;
	hud SetText( msg );

	hud thread temp_print_pulse_internal();

	wait( time );

	hud notify( "stop_pulse" );

	hud FadeOverTime( 0.5 );
	hud.alpha = 0;

	if ( IsDefined( locked ) )
	{
		level.player Unlink();
		ent Delete();
	}
	hud Destroy();
}

temp_print_pulse_internal()
{
	self endon( "stop_pulse" );

	time = 0.5;
	while ( 1 )
	{
		self FadeOverTime( time );
		self.alpha = 0;
		wait( time );

		self FadeOverTime( time );
		self.alpha = 1;
		wait( time + 0.5 );
	}

}

is_start_point_before( start_point )
{
	start_point_index = get_index_of_start( start_point );
	curr_point_index = get_index_of_start( level.start_point );

	if ( IsDefined( start_point_index ) && IsDefined( curr_point_index ) )
	{
		return curr_point_index < start_point_index;
	}

	assertmsg( "start point is wrong!" );
	return undefined;
}

is_start_point_after( start_point )
{
	start_point_index = get_index_of_start( start_point );
	curr_point_index = get_index_of_start( level.start_point );

	if ( IsDefined( start_point_index ) && IsDefined( curr_point_index ) )
	{
		return curr_point_index > start_point_index;
	}

	assertmsg( "start point is wrong!" );
	return undefined;
}

is_start_point_or_before( start_point )
{
	start_point_index = get_index_of_start( start_point );
	curr_point_index = get_index_of_start( level.start_point );

	if ( IsDefined( start_point_index ) && IsDefined( curr_point_index ) )
	{
		return curr_point_index <= start_point_index;
	}

	assertmsg( "start point is wrong!" );
	return undefined;
}

get_index_of_start( start_point )
{
	foreach ( idx, start in level.start_functions )
	{
		if ( start[ "name" ] == start_point )
		{
			return idx;
		}
	}

	return undefined;
}

print3d_on_pos( msg, origin, color )
{
	if ( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	while ( 1 )
	{
		wait( 0.05 );
		print3d( origin, msg, color );
	}
}

postspawn_rpg_vehicle()
{
	self SetModel( "projectile_rpg7" );
	fx = getfx( "rpg_trail" );
	PlayFXOnTag( fx, self, "tag_origin" );

	fx = getfx( "rpg_muzzle" );
	PlayFXOnTag( fx, self, "tag_origin" );

	self PlaySound( "weap_rpg_fire_npc" );

	if ( IsDefined( self.script_sound ) )
	{
		if ( IsDefined( self.script_wait ) )
		{
			self delaycall( self.script_wait, ::PlaySound, self.script_sound );
		}
		else
		{
			self PlaySound( self.script_sound );
		}
	}
	else
	{
		self PlayLoopSound( "weap_rpg_loop" );
	}

	self waittill( "reached_end_node" );
	self notify( "explode", self.origin );

	if ( IsDefined( self.script_exploder ) )
	{
		exploder( self.script_exploder );
	}

	self Delete();
}

player_linked_death()
{
	while ( level.player IsLinked() )
	{
		if ( !IsAlive( level.player ) )
		{
			level.player Unlink();
			return;
		}

		wait( 0.05 );
	}
}

//---------------------------------------------------------
// Limp Section
//---------------------------------------------------------
limp()
{
	if ( !flag_exist( "limp" ) )
	{
		flag_init( "limp" );
	}

	flag_set( "limp" );

	level.limping = true;
	level.ground_ref_ent = spawn( "script_model", ( 0, 0, 0 ) );
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );

	thread limp_stun( undefined, true );

	// Threads.
	thread limp_slowmo();
//	thread limp_swivel();

	unsteady_scale = 4.1;
	unsteady_max = 4.1;
	limp_time = 15 * 20; // 20 is for server framerate
	unsteady_inc = 4.1 / limp_time;

	movement_slow = 0.2;
	movement_slow_inc = ( 1 - movement_slow  ) / limp_time;
	movement_fast = 0.8;
	movement_fast_inc = ( 1 - movement_fast  ) / limp_time;
	level.player SetMoveSpeedScale( 0.3 );

	time = 0.1;
	half_time = time * 0.5;
	pitch_sin = 0;
	last_angles = level.player GetPlayerAngles()[ 1 ];
	prev_s = 0;

	limp_dir = "down";

	for ( ;; )
	{
		new_angles = level.player GetPlayerAngles()[ 1 ];
		dif = new_angles - last_angles;
		yaw = dif;
		last_angles = new_angles;

		player_speed = Length( level.player GetVelocity() );

		if ( player_speed == 0 )
		{
			wait( 0.05 );
			continue;
		}

		unsteady_ratio = unsteady_scale / unsteady_max;
		pitch_sin += player_speed * 0.06;

		s = sin( pitch_sin );
		s = abs( s );

		movement_fast += movement_fast_inc;
		movement_slow += movement_slow_inc;

		if ( prev_s != s )
		{
			if ( prev_s - s > 0  )
			{
				if ( limp_dir != "up" )
				{
					limp_dir = "up";
					level.player blend_movespeedscale( movement_fast, 0.25 );
				}
			}
			else 
			{
				if ( limp_dir != "down" )
				{
					thread limp_stun( unsteady_ratio );
					limp_dir = "down";
					level.player blend_movespeedscale( movement_slow, 0.1 );
				}
			}
		}

		if ( unsteady_scale > 0 )
		{
			unsteady_scale -= unsteady_inc;
			unsteady_scale = Max( unsteady_scale, 0 );
		}

		pitch = s * 4 * unsteady_scale;
		prev_s = s;

		angles = ( pitch * 0.5 * -1, 0, pitch * 0.6 );
		level.ground_ref_ent RotateTo( angles, time, time * 0.5, time * 0.5 );
			
		wait( 0.05 );

		if ( unsteady_scale == 0 )
		{
			break;
		}
	}

	flag_clear( "limp" );
	SetSlowMotion( 0.95, 1, 0.5 );

	level.limping = undefined;

	overlay = get_black_overlay();
	overlay FadeOverTime( 0.5 );
	overlay.alpha = 0;
	wait( 1 );
	overlay Destroy();

	// Make sure we don't have any blur when fully recovered
	SetBlur( 0, 1 );
}

limp_stun( scale, skip_speed )
{
	level endon( "limp" );
	level notify( "stop_limp_stun" );
	level endon( "stop_limp_stun" );

	if ( !flag( "limp" ) )
	{
		return;
	}

	if ( !IsDefined( scale ) )
	{
		scale = 1;
	}

	if ( scale < 0.2 )
	{
		return;
	}

	if ( !IsDefined( skip_speed ) )
	{
		while ( 1 )
		{
			player_speed = Distance( ( 0, 0, 0 ), level.player GetVelocity() );
	
			if ( player_speed > 80 )
			{
				break;
			}
	
			wait( 0.05 );
		}
	}

	stun_time = 2.3 * scale;
//	level.player thread swivel_stunplayer( stun_time );
	level.player thread play_sound_on_entity( "breathing_hurt" );
	noself_delayCall( .5, ::setblur, 4 * scale, .25 );
	noself_delayCall( 1.2, ::setblur, 0, 1 );

	delaythread( stun_time, ::limp_random_blur );
	thread limp_fade( stun_time );

	level.player PlayRumbleOnEntity( "damage_light" );
}

limp_fade( stun_time )
{
	if ( !flag( "limp" ) )
	{
		return;
	}
	
	black_overlay = get_black_overlay();
	black_overlay FadeOverTime( stun_time * 3 );
	black_overlay.alpha = RandomFloatRange( 0.9, 0.95 );

	wait( stun_time );

	if ( !flag( "limp" ) )
	{
		return;
	}

	black_overlay FadeOverTime( stun_time );
	black_overlay.alpha = 0;
}

limp_random_blur()
{
	level endon( "limp" );
	level notify( "stop_random_blur" );
	level endon( "stop_random_blur" );

	if ( !flag( "limp" ) )
	{
		return;
	}

	while ( true )
	{
		wait( 0.05 );
		if ( RandomInt( 100 ) > 10 )
		{
			continue;
		}

		blur = randomint( 3 ) + 2;
		blur_time = randomfloatrange( 0.3, 0.7 );
		recovery_time = randomfloatrange( 0.3, 1 );

		setblur( blur * 1.2, blur_time );
		wait( blur_time );
		setblur( 0, recovery_time );
		wait( 3 );
	}
}

limp_slowmo()
{
	level endon( "limp" );
	timescale = 1;
	time = 3;

	if ( !flag( "limp" ) )
	{
		return;
	}

	wait( 3 );

	for ( ;; )
	{
		SetSlowMotion( timescale, 0.89, time );
		wait( time + RandomFloat( 1 ) );
		SetSlowMotion( timescale, 1.06, time );
		wait( time + RandomFloat( 1 ) );
	}
}

//limp_swivel( ent )
//{
//	level endon( "stop_drunk_walk" );
//	next_switch = 1;	
//	
//	original_range = 7; // 25;
//	
//	for ( ;; )
//	{
//		range = original_range * level.unsteady_scale;
//		yaw = randomfloatrange( range * 0.5, range );
//		
//		next_switch--;
//		if ( next_switch <= 0 )
//		{
//			next_switch = randomint( 3 );
//			yaw *= -1;
//		}
//			
//		dif = yaw - ent.origin[0];
//		dif = abs( dif );
//
//		time = dif * 0.05;
//		if ( time < 0.05 )
//			time = 0.05;
//
//		start_time = gettime();
//		ent moveto( ( yaw, 0, 0 ), time, time * 0.5, time * 0.5 );
//		wait time;
//		
//		wait_for_buffer_time_to_pass( start_time, 0.6 );
//		for ( ;; )
//		{
//			player_speed = distance( (0,0,0), level.player getvelocity() );
//			if ( player_speed >= 80 )
//				break;
//			wait 0.05;
//		}
//
//	}	
//}

fade_in( fade_time )
{
	if ( level.MissionFailed )
	{
		return;
	}

	level notify( "now_fade_in" );
		
	black_overlay = get_black_overlay();
	if ( fade_time )
	{
		black_overlay FadeOverTime( fade_time );
	}

	black_overlay.alpha = 0;

//	thread eq_changes( 0.0, fade_time );
	wait( fade_time );
}

fade_out( fade_out_time )
{
	black_overlay = get_black_overlay();
	if ( fade_out_time )
	{
		black_overlay FadeOverTime( fade_out_time );
	}

	black_overlay.alpha = 1;
	wait( fade_out_time );
}

get_black_overlay()
{
	if ( !IsDefined( level.black_overlay ) )
	{
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	}

	level.black_overlay.sort = -1;
	level.black_overlay.foreground = false;
	return level.black_overlay;
}

callback( ref, parm1 )
{
	if ( !IsDefined( level.level_callback[ ref ] ) )
	{
		return;
	}

	func = level.level_callback[ ref ];

	if ( IsDefined( parm1 ) )
	{
		self [[ func ]]( parm1 );
	}
	else
	{
		self [[ func ]]();
	}
}

add_callback( ref, func )
{
	level.level_callback[ ref ] = func;
}

safe_playeruse_trigger()
{
	while ( 1 )
	{
		self waittill( "trigger" );

		if ( level.player IsMeleeing() )
		{
			wait( 1 );
			continue;
		}

		if ( level.player IsThrowingGrenade() )
		{
			continue;
		}

		break;
	}
}

//---------------------------------------------------------
// Shared Chopper Logic between splits
//---------------------------------------------------------
chopper_follow_path( path_targetname, earlyout_func )
{
	self notify( "stop_chopper_hover" );
	self notify( "stop_follow_path" );
	self endon( "stop_follow_path" );
	self ent_flag_set( "follow_path" );

	if ( IsDefined( earlyout_func ) )	
	{
		self thread [[ earlyout_func ]]();
	}
	
	path_start = getstruct( path_targetname, "targetname" );
	path_point = path_start;
	going_to_start = true;

	while ( IsDefined( path_point ) )
	{
		chopper_set_speed( path_point );

		radius = 100;
		if ( IsDefined( path_point.radius ) )
		{
			radius = path_point.radius;
		}

		self SetNearGoalNotifyDist( radius );

		stop_at_goal = is_chopper_stop_node( path_point );

		ignore_yaw = false;
		if ( IsDefined( path_point.script_forceyaw ) )
		{
			ignore_yaw = !path_point.script_forceyaw;
		}

		if ( !ignore_yaw )
		{
			self SetGoalYaw( path_point.angles[ 1 ] );
			self SetTargetYaw( path_point.angles[ 1 ] );
		}

		if ( IsDefined( path_point.script_helimove ) )
		{
			switch ( path_point.script_helimove )
			{
				case "fast":
					self SetMaxPitchRoll( 80, 80 );	
					break;
				case "rocketing":
					self SetMaxPitchRoll( 20, 50 );
					break;
				case "strafing":
					self SetMaxPitchRoll( 40, 50 );
					break;
				default:
					self SetMaxPitchRoll( 25, 45 );
			}
		}

		self SetVehGoalPos( path_point.origin, stop_at_goal );
		self waittill_either( "near_goal", "goal" );

		if ( IsDefined( path_point.script_delete ) )
		{
			self Delete();
			return;
		}

		if ( IsDefined( path_point.script_noteworthy ) )
		{
			if ( path_point.script_noteworthy == "mgon" )
			{
				self mgon();
			}
			else if ( path_point.script_noteworthy == "mgoff" )
			{
				foreach ( mg in self.mgturret )
				{
					if ( IsDefined( mg.straight_target ) )
					{
						mg.straight_target Delete();
					}

					mg ClearTargetEntity();
				}

				self notify( "stop_mg" );
				self mgoff();
			}
			else if ( path_point.script_noteworthy == "start_firing" )
			{
				foreach ( mg in self.mgturret )
				{
					mg SetMode( "manual" );
					mg startfiring();
					//self thread maps\_mgturret::burst_fire( mg );
				}
			}
			else if ( path_point.script_noteworthy == "stop_firing" )
			{
				foreach ( mg in self.mgturret )
				{
					mg Stopfiring();
					mg notify( "stopfiring" );
				}
			}
			else if ( path_point.script_noteworthy == "mgon_straight" )
			{
				self chopper_set_straight_target();
//				self notify( "start_mg" );
//				self mgon();
				foreach ( mg in self.mgturret )
				{
					mg SetMode( "manual" );
					mg startfiring();
				}
			}
			else if ( path_point.script_noteworthy == "fire_rockets" )
			{
				self notify( "fire_rockets" );
				self thread chopper_fire_rockets();
			}
			else if ( path_point.script_noteworthy == "stop_fire_rockets" )
			{
				self notify( "stop_fire_rockets" );
				self ClearLookAtEnt();
			}
			else if ( path_point.script_noteworthy == "prep_stop_rockets" )
			{
				self notify( "prep_stop_rockets" );
			}
			else if ( path_point.script_noteworthy == "spotlight_off" )
			{
				thread littlebird_spotlight_off();
			}
			else if ( path_point.script_noteworthy == "clear_lookat" )
			{
				self ClearLookAtEnt();
			}
		}

		if ( stop_at_goal )
		{
			dist = 100;

			// If we're at our goal and going to hover, then set goalyaw
			self SetGoalYaw( path_point.angles[ 1 ] );

			if ( IsDefined( path_point.script_radius ) )
			{
				dist = path_point.script_radius;
			}
			else if ( IsDefined( path_point.radius ) )
			{
				dist = path_point.radius;
			}

			if ( dist > 0 )
			{
				self thread chopper_hover( path_point.origin, dist, "stop_follow_path" );
			}
			waittillframeend;
		}

		if ( IsDefined( path_point.script_flag_set ) )
		{
			flag_set( path_point.script_flag_set );
		}

		if ( IsDefined( path_point.script_flag_wait ) )
		{
			flag_wait( path_point.script_flag_wait );
		}

		if ( IsDefined( path_point.script_ent_flag_set ) )
		{
			ent_flag_set( path_point.script_ent_flag_set );
		}

		if ( IsDefined( path_point.script_ent_flag_wait ) )
		{
			ent_flag_wait( path_point.script_ent_flag_wait );
		}

		path_point script_delay();

		self notify( "stop_chopper_hover" );
		going_to_start = false;

		if ( !IsDefined( path_point.target ) )
		{
			break;
		}

		path_point = getstruct( path_point.target, "targetname" );
	}

	self ClearTargetYaw();
	self ent_flag_clear( "follow_path" );
	self notify( "follow_path_done" );
}

chopper_set_straight_target()
{
	dist = 500;
	
	foreach ( mg in self.mgturret )
	{
		forward = AnglesToForward( self.angles );
		origin = mg GetTagOrigin( "tag_flash" );
		origin = origin + ( forward * dist );

		mg.straight_target = Spawn( "script_origin", origin );
		mg.straight_target LinkTo( self );
	
		mg SetTargetEntity( mg.straight_target );

		self thread chopper_extra_strafe_damage( mg );
	}
}

chopper_extra_strafe_damage( mg )
{
	self endon( "stop_mg" );

	tag = "tag_flash";
	dist = 500;
	while ( 1 )
	{
		wait( 0.05 );

		if ( self.angles[ 0 ] < 0 )
		{
			continue;
		}

		angles = mg GetTagAngles( tag );
		forward = AnglesToForward( angles );
		origin = self GetTagOrigin( tag );

		adj = origin[ 2 ] - 460;
		h = adj / sin( angles[ 0 ] );
		pos = origin + ( forward * h );

		RadiusDamage( pos, 64, 100, 20, self );

	}
}

chopper_fire_rockets()
{
	self endon( "stop_follow_path" );
	self endon( "stop_fire_rockets" );

	self SetVehWeapon( "missile_attackheli" );

//	fire_time = WeaponFireTime( "missile_attackheli" );
	fire_time = 0.2;
	count = 0;
	while ( 1 )
	{
		if ( count % 2 == 0 )
		{
			tag = "tag_missile_left";
			right = AnglesToRight( ( 0, self.angles[ 1 ], 0 ) + ( 0, 180, 0 ) );
		}
		else
		{
			tag = "tag_missile_right";
			right = AnglesToRight( ( 0, self.angles[ 1 ] , 0 ) );
		}

		offset = ( right * 60 );

		self FireWeapon( tag, self.target_ent, offset );

		wait( fire_time );
		count++;
	}
}

is_chopper_stop_node( path_point )
{
	if ( IsDefined( path_point.script_delay ) || IsDefined( path_point.script_delay_min ) )
	{
		return true;
	}

	if ( IsDefined( path_point.script_stopnode ) )
	{
		return true;
	}

	if ( IsDefined( path_point.script_flag_wait ) )
	{
		// If the flag is set, then we're not stopping.
		if ( !flag( path_point.script_flag_wait ) )
		{
			return true;
		}
	}

	return false;
}

chopper_set_speed( path_point )
{
	if ( IsDefined( path_point.speed ) )
	{
		speed = path_point.speed;

		accel = 20;
		decel = 10;

		if ( IsDefined( path_point.script_accel ) )
		{
			accel = path_point.script_accel;
		}

		if ( IsDefined( path_point.script_decel ) )
		{
			decel = path_point.script_decel;
		}

		self Vehicle_SetSpeed( path_point.speed, accel, decel );
	}
	
	if ( IsDefined( path_point.script_speed ) )
	{
		speed = path_point.script_speed;

		accel = 20;
		decel = 10;

		if ( IsDefined( path_point.script_accel ) )
		{
			accel = path_point.script_accel;
		}

		if ( IsDefined( path_point.script_decel ) )
		{
			decel = path_point.script_decel;
		}

		self Vehicle_SetSpeedImmediate( path_point.script_speed, accel, decel );
	}
}

chopper_move_till_goal()
{
	self SetVehGoalPos( self.hover.pathpoint[ "point" ] );
	self waittill_either( "near_goal", "goal" );
}

chopper_get_next_pathpoint( num )
{
	points = chopper_get_pathpoints();

	if ( num < 0 )
	{
		num = self.hover.circle_segments - 1;
	}
	else
	{
		num++;
	}

	if ( num >= points.size )
	{
		num = 0;
	}

	point_and_index = [];
	point_and_index[ "point" ] = points[ num ];
	point_and_index[ "index" ] = num;

	return point_and_index;
}

chopper_get_pathpoints()
{
	points = [];

	for ( i = 0; i < self.hover.circle_segments; i++ )
	{
		points[ i ] = chopper_get_pathpoint( i );
	}

	return points;
}

chopper_get_pathpoint( num )
{
	add_angles = ( 360 / self.hover.circle_segments ) * self.hover.direction;

	angles = ( 0, add_angles * num, 0 );
	forward = AnglesToForward( angles );

	point = self.hover.hover_point.origin + ( forward * self.hover.hover_point.radius );

	return point;
}

chopper_hover( origin, dist, extra_endon )
{
	self endon( "stop_chopper_hover" );

	if ( IsDefined( extra_endon ) )
	{
		self endon( extra_endon );
	}

	if ( !IsDefined( dist ) )
	{
		dist = 100;
	}

	while ( 1 )
	{
		x = RandomFloatRange( dist * -1, dist );
		y = RandomFloatRange( dist * -1, dist );
		z = RandomFloatRange( dist * -1, dist );

		self SetVehGoalPos( origin + ( x, y, z ), 1 );

		self Vehicle_SetSpeed( 5 + RandomInt( 10 ), 3, 3 );
		self waittill( "goal" );
	}
}

littlebird_spotlight_off()
{
	//StopFXonTag( getfx( "docks_heli_spotlight" ), self.spotlight, "tag_flash" );
	stop_last_spot_light();
}