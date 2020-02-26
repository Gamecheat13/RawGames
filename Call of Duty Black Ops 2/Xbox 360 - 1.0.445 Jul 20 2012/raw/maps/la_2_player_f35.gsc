/*
la_2_player_f35.gsc - this file contains all scripted gameplay functionality associated with the player controlled F35 in LA_2
 */

#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;

#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

main()
{
	wait_for_first_player();
	f35_setup();
		
	flag_wait( "player_flying" );

	f35_lock_to_mesh();
	OnSaveRestored_Callback( ::save_restored_function );	
}

f35_scripted_functionality()
{
	flag_wait( "player_in_f35" );
	//level.f35 delay_thread( 5, ::veh_toggle_tread_fx, true );  // TODO: update anim to use notetrack instead	
	flag_wait( "player_flying" );
	
	// general functionality
	level.f35 thread f35_health_regen();
	//level.f35 thread f35_ambient_console_lights();
	level.f35 thread f35_fire_guns();
	level.f35 thread f35_enable_ads();
	level.f35 thread f35_setup_visor();	
	level.f35 thread f35_collision_detection();  // will F35 hit an object?
	level.f35 thread f35_collision_watcher();  // F35 hit an object
	level.f35 thread height_mesh_threshold_low();
	level.f35 thread height_mesh_threshold_high();
	level.f35 thread flyby_feedback_watcher();
	level.f35 thread f35_interior_damage_anims();
	//level.f35 thread f35_ads_toggle();
	//level.f35 thread material_test();
	
	// dogfights specific functionality
	flag_wait( "convoy_at_dogfight" );
	level.f35 thread f35_switch_modes();
	level.f35 thread death_blossom_think();
	level.f35 thread missile_incoming_watcher();
	level.f35 thread missile_impact_watcher();
	level.f35 thread _watch_for_boost();
}

material_test()
{
	self endon( "death" );
	
	while ( true )
	{
		a_trace = BulletTrace( level.player get_eye(), ( level.player GetPlayerAngles() * 9000 ), false, self );
		
		str_surface_type = "NONE";
		
		if ( IsDefined( a_trace[ "surfacetype" ] ) )
		{
			str_surface_type = a_trace[ "surfacetype" ];
		}		
		
		iprintln( str_surface_type );
		
		wait 0.25;
	}
}

// setup damage system for F35
f35_health_regen()  // self = F35
{
	self.health_regen = SpawnStruct();
	
	switch( GetDifficulty() )
	{
		case "easy":
			self.health_regen.health_max = 4500;
			self.health_regen.time_before_regen = 6;
			self.health_regen.percent_life_at_checkpoint = 1;
			break;
		case "medium":
			self.health_regen.health_max = 4000;
			self.health_regen.time_before_regen = 7;
			self.health_regen.percent_life_at_checkpoint = 1;
			break;
		case "hard":
			self.health_regen.health_max = 3500;
			self.health_regen.time_before_regen = 8;
			self.health_regen.percent_life_at_checkpoint = 1;
			break;
		case "fu":
			self.health_regen.health_max = 3000;
			self.health_regen.time_before_regen = 9;
			self.health_regen.percent_life_at_checkpoint = 1;
			break;
	}
	
	self.health_regen.health = self.health_regen.health_max;
	self.overrideVehicleDamage = ::f35_damage_callback;		
	self.health_regen.health_regen_per_frame = Int( self.health_regen.health_max / self.health_regen.time_before_regen / 20 );  // 20 frames per second
	self thread f35_health_regen_think();
	self thread f35_health_warning_audio( self.health_regen.health_max );
}

f35_health_warning_audio( max_health )
{
	self endon( "death" );

	last_health = "max";
	
	while(1)
	{
		self waittill_any( "damage", "health_at_max" );
		
		ratio = self.health_regen.health/max_health;
		
		if( ratio >= .7 )
		{
			if( last_health != "max" )
			{
				last_health = "max";
				level clientnotify( "f35_h_max" );
			}
		}
		else if( ratio >= .4 )
		{
			if( last_health != "mid" )
			{
				last_health = "mid";
				level clientnotify( "f35_h_mid" );
			}
		}
		else
		{
			if( last_health != "low" )
			{
				last_health = "low";
				level clientnotify( "f35_h_low" );
			}
		}
	}
}

f35_health_regen_think()  // self = F35
{
	self endon( "death" );
	self.health_regen.time_since_last_damaged = 0;
	
	self thread f35_health_regen_update_last_damaged_timer();
	self thread f35_health_regen_wait_for_damage();
	self thread f35_hud_damage();
	
	while ( true )
	{
		if ( self.health_regen.time_since_last_damaged > self.health_regen.time_before_regen )
		{
			//C. Ayers: Commented this out as it prevented health regen from ever happening, which is confusing as to why it was in
			//self waittill( "damage" );
			self thread f35_health_regen_start();
		}
		
		wait 0.05;
	}
}

#define F35_DAMAGE_SHADER_TIME 500
f35_player_damage_watcher()
{
	self endon( "death" );
	level endon( "sam_success" );	
	
	while ( 1 )
	{	
		self waittill( "damage",  damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		self play_fx( "f35_console_blinking", undefined, undefined, "health_at_max", true, "tag_origin" );
		self notify( "stop_ambient_console_lights" );
		
		//IPrintLn( "damage: " + damage );
		//self ClearDamageIndicator();
		Earthquake( 0.25, 0.1, self.origin, 512, self );
		
		time = GetTime();
		if ( ( time - level.n_last_damage_time ) > F35_DAMAGE_SHADER_TIME )
		{	
			if ( IsDefined( level.f35_hud_damage_ent ) )
			{			
				level.n_hud_damage = true;
				
				if ( damage > 5 )
				{
					level.f35_hud_damage_ent SetClientFlag( CLIENT_FLAG_DAMAGE_HEAVY );					
				}
				else
				{
					level.f35_hud_damage_ent SetClientFlag( CLIENT_FLAG_DAMAGE_LIGHT );
				}
				level.f35_hud_damage_ent ClearClientFlag( CLIENT_FLAG_DAMAGE_OFF );
				level.n_last_damage_time = GetTime();							
			}
		}
	}
}

f35_ambient_console_lights()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self play_fx( "f35_console_ambient", undefined, undefined, "stop_ambient_console_lights", true, "tag_origin" );
		self waittill( "health_at_max" );
	}
}

f35_hud_damage()
{
	self endon( "death" );

	if ( !IsDefined( level.f35_hud_damage_ent ) )
	{
		level.f35_hud_damage_ent = Spawn( "script_model", level.player.origin );
		level.f35_hud_damage_ent SetModel( "tag_origin" );
	}
	
	level.n_last_damage_time = GetTime();		

	self thread f35_player_damage_watcher();
	
	while ( flag( "player_flying" ) )
	{
		if ( IS_TRUE( level.n_hud_damage ) )
		{
			time = GetTime();
			if ( ( time - level.n_last_damage_time ) > F35_DAMAGE_SHADER_TIME )
			{
				if ( IsDefined( level.f35_hud_damage_ent ) )
				{
					level.f35_hud_damage_ent SetClientFlag( CLIENT_FLAG_DAMAGE_OFF );
					level.f35_hud_damage_ent ClearClientFlag( CLIENT_FLAG_DAMAGE_LIGHT );
					level.f35_hud_damage_ent ClearClientFlag( CLIENT_FLAG_DAMAGE_HEAVY );					
					level.n_hud_damage = false;
				}
			}
		}
		
		wait 0.05;
	}	
	
	if ( IsDefined( level.f35_hud_damage_ent ) )
	{	
		level.f35_hud_damage_ent SetClientFlag( CLIENT_FLAG_DAMAGE_OFF );
		level.f35_hud_damage_ent ClearClientFlag( CLIENT_FLAG_DAMAGE_LIGHT );		
		level.f35_hud_damage_ent ClearClientFlag( CLIENT_FLAG_DAMAGE_HEAVY );				
	}
	
	wait( 0.05 );
	
	level.f35_hud_damage_ent Delete();
}

// thread constantly updates 'time since last damaged' parameter. this gets set to zero in f35_health_regen_wait_for_damage() when damage event occurs
f35_health_regen_update_last_damaged_timer()  // self = F35
{
	self endon( "death" );
	
	while ( true )
	{
		self.health_regen.time_since_last_damaged += 0.05;
		wait 0.05;
	}
}

// waits for damage event, then sets 'time since last damaged' to zero
f35_health_regen_wait_for_damage()  // self = f35
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "damage" );
		level thread f35_hud_damage_event();
		self.health_regen.time_since_last_damaged = 0;
	}
}

// this function performs the actual health regeneration. stops on damage
f35_health_regen_start()  // self = f35
{
	self endon( "damage" );  // kill thread if damaged during regen
	self endon( "death" );
	
	b_health_at_full = false;
	
	while ( !b_health_at_full )
	{
		self.health_regen.health += self.health_regen.health_regen_per_frame;
		
		// if regen exceeds max, clamp to max
		if ( self.health_regen.health > self.health_regen.health_max )
		{
			self.health_regen.health = self.health_regen.health_max;
		}
		
		if ( self.health_regen.health == self.health_regen.health_max )
		{
			b_health_at_full = true;
		}
		
		wait 0.05;
	}
	
	self notify( "health_at_max" );  // tell think function regen is done
}

save_restored_function()
{
	level.f35 _restore_f35_health();
	level.f35 _restore_f35_hud();
	
	// trenchruns placement - player should be on top of convoy vehicles, and facing the same direction they are
	if ( flag( "convoy_at_trenchrun" ) )
	{
		s_restart = get_struct( "trenchruns_restart_point_1", "targetname", true );
		
		if ( flag( "convoy_at_trenchrun_turn_3" ) )
		{
			s_restart = get_struct( "trenchruns_restart_point_2", "targetname", true );
		}
		
		Assert( IsDefined( s_restart.angles ), "struct " + s_restart.targetname + " at " + s_restart.origin + " is missing angles for f35_save_restored function!" );
		
		level.f35.origin = s_restart.origin;
		level.f35 SetPhysAngles( s_restart.angles );
	}
}

_restore_f35_hud()
{
	// hide console texture
//	level.f35 HidePart( "tag_message" );
//	
//	// if a cinematic bink isn't playing, make the default one play
//	if ( !flag( "pip_playing" ) )
//	{
//		if( isdefined(level.f35.current_bink_id) )
//		{
//			Stop3DCinematic( level.f35.current_bink_id );
//		}
//		level.f35 play_f35_loop();
//	}
	
	// restore lui hud
	LUINotifyEvent( &"hud_update_vehicle" );
}

f35_lock_to_mesh()
{
	// attach F35 to flight mesh after hover button pressed - TODO: block off player's vehicle so he has to use hover to leave
	level.F35 SetHeliHeightLock( true );
}

get_player_aim_pos( n_range, e_to_ignore )  // self = player
{
	v_start_pos = self GetEye();
	v_dir = AnglesToForward( self GetPlayerAngles() );
	v_end_pos = v_start_pos + v_dir * n_range;

	//v_hit_pos = PlayerPhysicsTrace( v_start_pos, v_end_pos, (-10,-10,0), (10,10,0), e_to_ignore );
	v_hit_pos = v_end_pos; // test to see if this helps performance

	//DebugStar( hit_pos, 20, (0.9, 0.7, 0.6) );

	return v_hit_pos;
}

f35_fire_guns()
{
	self endon( "death" );
	self endon( "stop_f35_minigun" );

	//level.player thread player_unlimited_ammo();
	gunner_weapon_name = self SeatGetWeapon( 1 );
	n_fire_time = WeaponFireTime( gunner_weapon_name );
	n_fov = GetDvarFloat( "cg_fov" );
	v_offset = ( 0, 0, 0 );
	n_radius = 32;
	const n_radius_vtol = 32;
	const n_distance_max = 8000;
	n_distance_max_sq = n_distance_max * n_distance_max;

	const n_heat_time = 3;
	const n_cooldown_time = 1;
	n_current_heat = 0;
	const n_max_heat = 100;

	while ( IsAlive( self ) )
	{
		b_do_damage = false;
		v_aim_pos = level.player get_player_aim_pos( 20000 );

		a_axis_vehicles = GetVehicleArray( "axis" );
		a_temp = [];
		b_has_target = false;

		if ( IsDefined( self.vtol) && self.is_vtol )
		{
			n_radius = n_radius_vtol;
		}

		for ( i = 0; i < a_axis_vehicles.size; i++ )
		{
			if ( Target_IsInCircle( a_axis_vehicles[ i ], level.player, n_fov, n_radius ) )
			{
				a_temp[ a_temp.size ] = a_axis_vehicles[ i ];
				//v_aim_pos = a_axis_vehicles[ i ].origin;
				//level thread draw_line_for_time( self.origin, v_aim_pos, 1, 1, 1, 0.05 );
			}
		}

		if ( a_temp.size > 0 )
		{
			if ( IsDefined( level.f35_lockon_target ) && IsInArray( a_temp, level.f35_lockon_target ) )
			{
				e_target = level.f35_lockon_target;
			}
			else
			{
				e_target = get_closest_element( self.origin, a_temp );
			}

			if ( IsDefined( e_target ) )
			{
				b_has_target = true;
			}
		}

		if ( b_has_target )
		{
			//level thread draw_line_for_time( self.origin, e_target.origin, 1, 1, 1, 0.05 );
			self SetGunnerTargetEnt( e_target, v_offset, 0 );
			self SetGunnerTargetEnt( e_target, v_offset, 1 );
			//level thread draw_line_for_time( self.origin, e_target.origin, 1, 1, 1, 0.05 );
		}
		else
		{
			self SetGunnerTargetVec( v_aim_pos, 0 );
			self SetGunnerTargetVec( v_aim_pos, 1 );
		}

		if ( level.player AttackButtonPressed() )
		{
			self FireGunnerWeapon(0);
			self FireGunnerWeapon(1);

			if ( b_has_target )
			{
				n_distance_to_target = DistanceSquared( e_target.origin, self.origin );

				if ( self _can_bullet_hit_target( self.origin, e_target ) )
				{
					b_do_damage = true;
				}

				/*
				if ( n_distance_to_target > n_distance_max_sq )  // 8000 is max bullettrace distance
				{
					if ( self _can_bullet_hit_target( self.origin, e_target ) )
					{
						b_do_damage = true;
					}
				}
				*/

				if ( b_do_damage )
				{
					n_damage = f35_guns_get_damage( e_target );
					e_target DoDamage( n_damage, e_target.origin, level.player, level.player, "riflebullet", "", gunner_weapon_name );
				}
			}

			n_current_heat += ( n_max_heat / n_heat_time ) * n_fire_time;
			if ( n_current_heat > n_max_heat )
			{
				n_current_heat = n_max_heat;
			}

			LUINotifyEvent( &"hud_weapon_heat", 1, Int( n_current_heat ) );

			wait ( n_fire_time );
		}
		else
		{
			if ( n_current_heat > 0 )
			{
				n_current_heat -= ( n_max_heat / n_cooldown_time ) * 0.05;
				if ( n_current_heat < 0 )
				{
					n_current_heat = 0;
				}

				LUINotifyEvent( &"hud_weapon_heat", 1, Int( n_current_heat ) );
			}

			wait ( 0.05 );
		}
	}
}

// doesn't run a function for distance comparison like getClosest; a_elements = anything with .origin
get_closest_element( v_reference, a_elements ) 
{
	Assert( IsDefined( v_reference ), "v_reference is a required parameter for get_closest_element" );
	Assert( IsDefined( a_elements ), "a_elements is a required parameter for get_closest_element" );
	Assert( ( a_elements.size > 0 ), "get_closest_elements was passed a zero sized array" );
	
	e_closest = a_elements[ 0 ];
	
	n_dist_lowest = 99999;
	for ( i = 0; i < a_elements.size; i++ )
	{
		n_dist_current = DistanceSquared( v_reference, a_elements[ i ].origin );
		
		if ( n_dist_current < n_dist_lowest )
		{
			n_dist_lowest = n_dist_current;
			e_closest = a_elements[ i ];
		}
	}
	
	return e_closest;
}

// taper off damage based on distance, like non-turret bullet weapons GDT would do if we weren't faking damage
f35_guns_get_damage( e_target )
{
	const n_damage_closest = 125;
	const n_distance_closest = 3000;
	
	const n_damage_1 = 100;
	const n_distance_1 = 6000;
	
	const n_damage_2 = 75;
	const n_distance_2 = 13000;
	
	const n_damage_3 = 50;
	const n_distance_3 = 20000;
	
	const n_damage_farthest = 0;
	const n_distance_farthest = 30000;
	
	n_distance = Distance( self.origin, e_target.origin );
	n_damage = 0;
	if ( is_alive( e_target ) )
	{
		if ( n_distance < n_distance_closest )
		{
			n_damage = n_damage_closest;
		}
		else if ( ( n_distance > n_distance_closest ) && ( n_distance < n_distance_2 ) )
		{
			n_damage = linear_map( n_distance, n_distance_closest, n_distance_2, n_damage_1, n_damage_closest );
		}
		else if ( ( n_distance > n_distance_2 ) && ( n_distance < n_distance_3 ) )
		{
			n_damage = linear_map( n_distance, n_distance_2, n_distance_3, n_damage_3, n_damage_2 );
		}
		else if ( ( n_distance > n_distance_3 ) && ( n_distance < n_distance_farthest ) )
		{
			n_damage = linear_map( n_distance, n_distance_3, n_distance_farthest, n_damage_farthest, n_damage_3 );
		}
		else
		{
			n_damage = n_damage_farthest;
		}
	}
	
	return Int( n_damage );
}

f35_setup_visor()
{	
	if ( flag( "player_flying" ) )  // conditional for skipto. player puts on helmet with notetrack during F35 startup scene
	{
		level.player VisionSetNaked( "helmet_f35_low", 0.5 );
	}
}

F35_remove_visor()
{
	level.player ClearClientFlag( 0 );
	level.player VisionSetNaked( "default", 0 );
}


player_boards_f35()
{
	level.player StartCameraTween( 0.05 );
	// put player in vehicle then disable leaving it
	level.f35 MakeVehicleUsable();
	level.f35 UseBy( level.player );
	level.f35 MakeVehicleUnusable(); 	
//	level.player hide_hud();
	level.f35 HidePart( "tag_gear" );
	// set F35 parameters		
	level.player SetClientDvar( "cg_fov", 70 );		
	level.player SetClientDvar( "compass", 0 );
	level.player SetClientDvar("cg_tracerSpeed", 25000 );    	
	level.player SetClientDvar( "cg_objectiveIndicatorFarFadeDist", 400000 ); 
	level.player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", 16 );
//	level.player EnableInvulnerability();  // make player invulnerable while in F35 - handle F35 damage elsewhere
	//OnPlayerDamage_Callback( ::f35_player_damage_callback );
	level.player.overridePlayerDamage = ::f35_player_damage_callback;
	
	// start in VTOL mode by default when boarding
	level.f35 _f35_set_vtol_mode( true );  
	
	// disable 'get to cover' message
	level.enable_cover_warning = false;
	
	// disable melee noise from playing during ADS button click
	//level.player AllowMelee( false );
	
	LUINotifyEvent( &"hud_update_vehicle" );	
}

// play ember fx that follow player
update_ember_fx( str_fx_name )  // self = player
{	
	if ( IsDefined( self.e_temp_fx ) )
	{
		self.e_temp_fx Unlink();
		self.e_temp_fx Delete();
	}
	
	if ( IsDefined( str_fx_name ) && GetDvarint( "fa38_disable_hud_damage" ) != 1 )
	{
		self.e_temp_fx = Spawn( "script_model", self.origin );
		self.e_temp_fx.angles = self.angles;
		self.e_temp_fx LinkTo( self );
		self.e_temp_fx SetModel( "tag_origin" );
		PlayFXOnTag( level._effect[ str_fx_name ], self.e_temp_fx, "tag_origin" );  	
	}
}


f35_player_damage_callback( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{	
	if ( ( self.health - iDamage ) < 1 )
	{
		if ( self.health > 1 )
		{
			iDamage = self.health - 1;
		}
		else 
		{
			iDamage = 0;
		}
	}
	
	return iDamage;
}


player_exits_f35()
{
	// remove player from F35
	SetHeliHeightPatchEnabled( "air_section_height_mesh", false );
	SetHeliHeightPatchEnabled( "ground_section_height_mesh", false );	
	level clientnotify( "player_turn_off_sonar" );
	level.F35 SetHeliHeightLock( false );
	level.player notify( "exit_f35" );
	// restore standard dvars
	level.player SetClientDvar( "compass", 1 );
	level.player SetClientDvar("cg_tracerSpeed", 7500 );    	
	level.player SetClientDvar( "cg_objectiveIndicatorFarFadeDist", 8192 );
	level.player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", 64 );
//	level.player DisableInvulnerability();
	
	level.player update_ember_fx();  // remove fx
	
	level.player AllowMelee( true );
}



/* ------------------------------------------------------------------------------------------
Set up F35
-------------------------------------------------------------------------------------------*/
F35_setup()
{
	wait_for_first_player();
	
	level.F35 = get_ent( "F35", "targetname", true );
	level.f35 MakeVehicleUnusable(); 
	level.F35 SetHeliHeightLock( false );
	level.f35 SetVehicleAvoidance( true );	
	level.f35 SetVehicleAvoidance( true );	
	level.f35 veh_toggle_tread_fx( false );
	level.f35 setup_approach_points();	
	
	// setup global values for plane speed matching
	level.f35.max_speed_vtol = ( level.f35 GetMaxSpeed() ) / 17.6;  // max GDT speed. used for clamp value on npc plane speeds - returns units/sec, need mph
	
	// fast vtol settings
	level.f35.speed_plane_min = 125;  // jet mode - 200
	level.f35.speed_plane_max = 350;
	level.f35 SetVehicleType( "plane_f35_player_vtol_fast" );
	level.f35.speed_plane_max = ( level.f35 GetMaxSpeed() ) / 17.6;  // convert units/sec to MPH
	level.f35.speed_plane_min = 100;
	
	// jet mode settings
//	level.f35 SetVehicleType( "plane_f35_player" );  	
//	level.f35.speed_plane_max = ( level.f35 GetMaxSpeed() ) / 17.6;  // convert units/sec to MPH
//	level.f35.speed_plane_min = 100;
//	level.f35.speed_plane_max = 200;  // jet mode - 300
	
	level.f35 SetVehicleType( "plane_f35_player_vtol" );  // back to vtol mode to start
	
	// drone tuning parameters
	level.f35.speed_drone_min = 300;
	level.f35.speed_drone_max = 375;
	
	level.f35 ent_flag_init( "playing_bink_now" );
	level thread f35_scripted_functionality();
	//level.f35 HidePart( "tag_message" );  // hides material on console so player can see bink playing
	
	f35_init_console();
	
	level.player.missile_turret_lock_lost_time = 2000; // time it takes to lose a locked target once it's out of targeting cone. in milliseconds
}

missile_impact_watcher()
{
	self endon( "death" );

	n_earthquake_scale_catastrophic = 0.6;
	n_earthquake_duration_catastrophic = 3;
	n_rumble_count_catastrophic = 5;
	n_rumble_delay_catastrophic = 0.1;
	str_rumble_catastrophic = "damage_heavy";
	
	while ( true )
	{
		self waittill( "missile_hit_player" );
		self notify( "f35_destroy_panels" );
		Earthquake( n_earthquake_scale_catastrophic, n_earthquake_duration_catastrophic, level.player.origin, 2000, level.player );
		level.player thread rumble_loop( n_rumble_count_catastrophic, n_rumble_delay_catastrophic, str_rumble_catastrophic );
		level.player playsound( "prj_missile_impact_f35" );
	}
}

missile_incoming_watcher()
{
	self endon( "death" );
	
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	
	while ( true )
	{
		flag_wait( "missile_event_started" );
		//iprintlnbold( "incoming missile!" );
		
		n_index = RandomInt( 4 );
		if ( n_index == 0 )
		{
			self thread say_dialog( "missile_warning_028" );  // Missile warning!
		}
		else if ( n_index == 1 )
		{
			self thread say_dialog("incoming_missile_029" );//Incoming missile.
		}
		else if ( n_index == 2 )
		{
			e_harper thread say_dialog("dammit_septic__th_011" );  //Dammit Septic!  They?ve got a lock on you!
		} 
		else 
		{
			e_harper thread say_dialog("missiles_on_your_013" );  //Missile?s on your ass!
		}
		
		//SOUND - Shawn J
		level.player playsound ("wpn_sam_warning");
		
		flag_waitopen( "missile_event_started" );
	}
}

setup_approach_points()
{
	n_distance_side = 1000;  // distance from the body of the plane that all points surrounding the plane are projected
	n_distance_side_bottom_addition = 1500;  // bottom row uses special distances
	n_distance_goal = 4500;  // distance in front of the player we want the plane to be. the 'sweet spot'.
	n_distance_behind = -20000;  // distance behind the plane where enemy plane will approach
	
	v_origin = self.origin;
	v_angles = self.angles;
	
	v_forward = AnglesToForward( v_angles );
	v_right = AnglesToRight( v_angles );
	v_up = AnglesToUp( v_angles );
	
	v_back = v_forward * ( -1 );
	v_left = v_right * ( -1 );
	v_down = v_up * ( -1 );
	
	v_forward_scaled = v_forward * n_distance_side;
	v_right_scaled = v_right * n_distance_side;
	v_up_scaled = v_up * n_distance_side;
	
	v_back_scaled = v_back * n_distance_side;
	v_left_scaled = v_left * n_distance_side;
	v_down_scaled = v_down * n_distance_side;
	
	/*
	ARRAY ORDER
	------------- 	 ----------------------------------------------------------------
	| 0 | 1 | 2 | -> |	[left][top]		|	[center][top]		| [right][top]		|
	-------------	 ----------------------------------------------------------------
	| 3 | 4 | 5 |	 |	[left][center]	| 	[center][center]	| [right][center]	|
	-------------	 ----------------------------------------------------------------
	| 6 | 7 | 8 |	 |	[left][bottom]	|	[center][bottom]	| [right][bottom]	|
	-------------	 ----------------------------------------------------------------
	NAMING CONVENTION: left/right/center_top/bottom/center
	*/
	a_base_grid = [];
	a_base_grid[ "left" ] = [];
	
	v_grid_left_top = v_origin + v_up_scaled + v_left_scaled;
	a_base_grid[ "left" ][ "top" ] = v_grid_left_top;
	
	v_grid_center_top = v_origin + v_up_scaled;
	a_base_grid[ "center" ][ "top" ] = v_grid_center_top;
	
	v_grid_right_top = v_origin + v_up_scaled + v_right_scaled;
	a_base_grid[ "right" ][ "top" ] = v_grid_right_top;	
	
	v_grid_left_center = v_origin + v_left_scaled;
	a_base_grid[ "left" ][ "center" ] = v_grid_left_center;
	
	v_grid_center_center = v_origin;
	a_base_grid[ "center" ][ "center" ] = v_grid_center_center;
	
	v_grid_right_center = v_origin + v_right_scaled;
	a_base_grid[ "right" ][ "center" ] = v_grid_right_center;
	
	v_grid_left_bottom = v_origin + v_down_scaled + v_left_scaled + ( v_left * n_distance_side_bottom_addition );
	a_base_grid[ "left" ][ "bottom" ] = v_grid_left_bottom;
	
	v_grid_center_bottom = v_origin + v_down_scaled;
	a_base_grid[ "center" ][ "bottom" ] = v_grid_center_bottom;
	
	v_grid_right_bottom = v_origin + v_right_scaled + v_down_scaled + ( v_right * n_distance_side_bottom_addition );
	a_base_grid[ "right" ][ "bottom" ] = v_grid_right_bottom;	
	
	a_approach_ents = [];
	a_approach_ents[ "left" ] = [];
	a_goal_ents = [];	
	a_goal_ents[ "left" ] = [];
	a_approach_ents_index = [];
	
	a_keys_row = GetArrayKeys( a_base_grid );
	a_keys_col = GetArrayKeys( a_base_grid[ a_keys_row[ 0 ] ] );  // will follow same naming convention in each index
	
	for ( i = 0; i < a_keys_row.size; i++ )
	{
		for ( j = 0; j < a_keys_col.size; j++ )
		{		
			// approach points - behind player
			v_temp_approach_point = a_base_grid[ a_keys_row[ i ] ][ a_keys_col[ j ] ] + ( v_forward * n_distance_behind );
			e_temp_approach = Spawn( "script_origin", v_temp_approach_point );
			e_temp_approach.angles = level.f35.angles;
			e_temp_approach LinkTo( self );
			a_approach_ents[ a_keys_row[ i ] ][ a_keys_col[ j ] ] = e_temp_approach;
			a_approach_ents_index[ i + j ] = e_temp_approach;
			
			// goal points (in front of player)
			v_temp_goal_point = a_base_grid[ a_keys_row[ i ] ][ a_keys_col[ j ] ] + ( v_forward * n_distance_goal );
			e_temp_goal = Spawn( "script_origin", v_temp_goal_point );
			e_temp_goal.angles = level.f35.angles;
			e_temp_goal LinkTo( self );
			a_goal_ents[ a_keys_row[ i ] ][ a_keys_col[ j ] ] = e_temp_goal;
			//level thread draw_line_for_time( self.origin, v_temp_goal_point, 1, 1, 1, 10 );   // debug
		}
	}
	
	// make all these points and ents accessible on player's vehicle
	self.a_approach_ents = a_approach_ents;
	self.a_goal_ents = a_goal_ents;
	self.a_approach_ents_index = a_approach_ents_index;
	
	// array 
	a_goal_index = [];
	a_goal_index[ 0 ] = false;
	a_goal_index[ 1 ] = false;
	a_goal_index[ 2 ] = false;
	a_goal_index[ 3 ] = false;
	a_goal_index[ 4 ] = true;
	a_goal_index[ 5 ] = false;  // don't fly to the center point
	a_goal_index[ 6 ] = false;
	a_goal_index[ 7 ] = false;
	a_goal_index[ 8 ] = false;

	a_flyby_index = [];
	a_flyby_index[ 0 ] = GetVehicleNode( "flyby_grid_top_left", "targetname" );
	a_flyby_index[ 1 ] = GetVehicleNode( "flyby_grid_center_top", "targetname" );
	a_flyby_index[ 2 ] = GetVehicleNode( "flyby_grid_top_right", "targetname" );
	a_flyby_index[ 3 ] = GetVehicleNode( "flyby_grid_left_center", "targetname" );
	a_flyby_index[ 4 ] = undefined;
	a_flyby_index[ 5 ] = GetVehicleNode( "flyby_grid_right_center", "targetname" );
	a_flyby_index[ 6 ] = GetVehicleNode( "flyby_grid_left_bottom", "targetname" );
	a_flyby_index[ 7 ] = GetVehicleNode( "flyby_grid_center_bottom", "targetname" );
	a_flyby_index[ 8 ] = GetVehicleNode( "flyby_grid_right_bottom", "targetname" );
	
	level.f35.a_goal_index = a_goal_index;
	level.f35.a_flyby_index = a_flyby_index;
	level.f35.n_goal_ents_occupied = 0;
	level.f35.n_max_flyby_count = 8;
	
	//level.f35 thread approach_point_debug();  // debug
}
/#
approach_point_debug()
{
	a_keys_row = GetArrayKeys( self.a_goal_ents );
	a_keys_col = GetArrayKeys( self.a_goal_ents[ a_keys_row[ 0 ] ] );  // will follow same naming convention in each index	
	
	while ( true )
	{
		for ( i = 0; i < a_keys_row.size; i++ )
		{
			for ( j = 0; j < a_keys_col.size; j++ )
			{
				// debug
				level thread draw_line_for_time( self.origin, self.a_goal_ents[ a_keys_row[ i ] ][ a_keys_col[ j ] ].origin, 1, 1, 1, 1 );
			}
		}		
		
		wait 1;
	}
}
#/
f35_get_available_approach_point()
{
	n_max_occupants = level.f35.n_max_flyby_count;
	
	if ( level.f35.n_goal_ents_occupied >= n_max_occupants )
	{
		n_available_index = 20;  // reserved value for unavailable
	}
	else 
	{
		a_temp = level.f35.a_goal_index;
		a_pool = [];
		
		// create a temporary pool of available positions, then select one randomly
		for ( i = 0; i < level.f35.a_goal_index.size; i++ )
		{
			if ( IsDefined( a_temp[ i ] ) && !a_temp[ i ] )
			{
				a_pool[ a_pool.size ] = i;
			}
		}
		
		n_available_index = random( a_pool );
	}
	
	return n_available_index;
}

f35_get_approach_point( str_row, str_col )
{
	e_temp = self.a_approach_ents[ str_row ][ str_col ];
	return e_temp;
}

f35_get_goal_point( str_row, str_col )
{
	e_temp = level.f35.a_goal_ents[ str_row ][ str_col ];
	return e_temp;
}

height_mesh_threshold_low()
{
	self endon( "death" );
	
	while ( IsAlive( self ) )
	{
		self waittill( "veh_heightmesh_min" );
		//iprintln( "heightmesh min" );
		
		wait 0.05;
	}
}

height_mesh_threshold_high()
{
	self endon( "death" );
	
	while ( IsAlive( self ) )
	{
		self waittill( "veh_heightmesh_max" );
		//iprintln( "heightmesh max" );
		
		wait 0.05;
	}
}

f35_collision_detection()
{
	self endon( "death" );
	level endon( "eject_done" );
	self endon( "midair_collision" );
	
	n_update_time = 0.25;
	n_scale_forward = 9000;
	
	if ( !IsDefined( self.is_vtol ) )
	{
		self.is_vtol = true;
	}
	
	while ( IsAlive( self ) )
	{
		// only use in conventional flight mode
		b_is_vtol = self.is_vtol;
		
		b_collision_imminent = false;
		// draw line forward, ignore player and F35
		v_forward_normalized = AnglesToForward( level.player GetPlayerAngles() );
		v_forward_scaled = v_forward_normalized * n_scale_forward;
		v_end_pos = self.origin + v_forward_scaled;
		
		a_trace = BulletTrace( level.player.origin, v_end_pos, false, self );
		
		if ( ( a_trace[ "surfacetype" ] != "none" ) && ( !IsDefined( a_trace[ "entity" ] ) ) )
		{
			b_collision_imminent = true;
		}
		
		if ( b_collision_imminent )
		{
			//iprintln( "COLLISION IMMINENT" );
		}
		
		self.is_collision_imminent = b_collision_imminent;
		
		wait n_update_time;
	}
}

f35_collision_watcher()
{
	self endon( "death" );
	level endon( "eject_sequence_started" );
	
	// damage threshold parameters
	n_impact_major = 1500;
	n_impact_catastrophic = 5000;
	
	// earthquake parameters
	n_earthquake_scale_minor = 0.1;
	n_earthquake_scale_major = 0.4;
	n_earthquake_scale_catastrophic = 0.7;
	n_earthquake_duration_minor = 0.5;
	n_earthquake_duration_major = 1;
	n_earthquake_duration_catastrophic = 2;
	
	// rumble parameters
	str_rumble_minor = "damage_light";
	str_rumble_major = "tank_damage_light_mp";
	str_rumble_catastrophic = "tank_damage_heavy_mp";
	n_rumble_count_minor = 1;
	n_rumble_count_major = 1;
	n_rumble_count_catastrophic = 1;
	n_rumble_delay_minor = 0.05;
	n_rumble_delay_major = 1;
	n_rumble_delay_catastrophic = 1;
	
	// feedback parameters
	n_feedback_delay_minor = n_rumble_count_minor * n_rumble_delay_minor;
	n_feedback_delay_major = n_rumble_count_major * n_rumble_delay_major;
	n_feedback_delay_catastrophic = n_rumble_count_catastrophic * n_rumble_delay_catastrophic;
	self.collision_feedback_time_last = 0;
	self.collision_feedback_ready = true;
	
	while ( true )
	{
		self waittill( "veh_collision", v_impact_velocity, v_normal );
		b_impact_major = _f35_collision_magnitude_test( v_impact_velocity, n_impact_major );
		b_impact_catastrophic = _f35_collision_magnitude_test( v_impact_velocity, n_impact_catastrophic );
		n_time = GetTime();
		
		if ( b_impact_major && !b_impact_catastrophic )  // you can only get this in plane mode
		{
			//iprintlnbold( "major impact" );
			if ( self.collision_feedback_ready )
			{
				Earthquake( n_earthquake_scale_major, n_earthquake_duration_major, level.player.origin, 512, level.player );
				level.player thread rumble_loop( n_rumble_count_major, n_rumble_delay_major, str_rumble_major );
				self thread _f35_collision_feedback_watcher( n_feedback_delay_major );
				self DoDamage( 100, self.origin );
			}
		}
		else if ( b_impact_catastrophic )
		{
			//iprintlnbold( "catastrophic impact" );
			if ( self.collision_feedback_ready )
			{
				Earthquake( n_earthquake_scale_catastrophic, n_earthquake_duration_catastrophic, level.player.origin, 512, level.player );
				level.player thread rumble_loop( n_rumble_count_catastrophic, n_rumble_delay_catastrophic, str_rumble_catastrophic );
				self thread _f35_collision_feedback_watcher( n_feedback_delay_catastrophic );
				self DoDamage( 1000, self.origin );			
			}
			
			//self thread f35_hit_object_switch_to_vtol();
		}		
		else 
		{
			//iprintlnbold( "minor impact" );			
			// minor collision
			if ( self.collision_feedback_ready )
			{
				Earthquake( n_earthquake_scale_minor, n_earthquake_duration_minor, level.player.origin, 512, level.player );
				level.player thread rumble_loop( n_rumble_count_minor, n_rumble_delay_minor, str_rumble_minor );
				self thread _f35_collision_feedback_watcher( n_feedback_delay_minor );				
				self DoDamage( 100, self.origin );				
			}
		}
	}
}

_f35_collision_magnitude_test( v_impact_velocity, n_threshold )
{
	b_passed_threshold = false;
	
	for ( i = 0; i < 2; i++ )  // don't test z since we fly low a lot in F35 ground section. collisions aren't apparent.
	{
		if ( Abs( v_impact_velocity[ i ] ) > n_threshold )
		{
			b_passed_threshold = true;
		}
	}
	
	return b_passed_threshold;
}

_f35_collision_feedback_watcher( n_delay )
{
	self endon( "death" );
	
	self.collision_feedback_ready = false;
	
	wait n_delay;
	
	self.collision_feedback_ready = true;
}

f35_enable_ads()
{
	self endon( "death" );
	level endon( "eject_sequence_started" );
	
	n_fov_zoomed = 40;  // fov when player is zoomed in with ads
	n_fov_normal = GetDvarInt( "cg_fov" );
	b_using_ads = false;
	e_player = level.player;	
	b_pressed_last_frame = false;	
	
	while ( IsAlive( self ) )
	{	
		if ( e_player MeleeButtonPressed() ) 
		{
			//b_is_vtol_mode = ( self.is_vtol );
			b_is_vtol_mode = true;
			b_can_toggle_ads = ( ( !b_pressed_last_frame ) && ( b_is_vtol_mode ) );
			n_fov = n_fov_zoomed;
			
			if ( b_using_ads || !b_is_vtol_mode )
			{
				n_fov = n_fov_normal;
			}
		
			if ( b_can_toggle_ads )
			{
				e_player SetClientDvar( "cg_fov", n_fov );
				b_using_ads = !b_using_ads;
			}
			
			b_pressed_last_frame = true;
		}
		else 
		{
			b_pressed_last_frame = false;
		}
					
		wait 0.05;
	}
}

f35_hit_object_switch_to_vtol()
{
	if ( !IsDefined( self.vtol_mode_collision ) )
	{
		self.vtol_mode_collision = false;
	}
	
	if ( self.vtol_mode_collision )
	{
		return;
	}
	
	//iprintlnbold( "collision detected. switching to vtol mode..." );
	
	level.f35 thread _f35_stop_from_collision();
	self.vtol_mode_collision = true;
	
	// play anim
	self _f35_set_vtol_mode();
	
	level.f35 f35_wait_until_path_clear( false );
	
	//iprintlnbold( "clear path detected. switching to jet mode..." );
	self.vtol_mode_collision = false;
		
	// scale back to jet mode
	n_speed_current = self GetSpeedMPH();
	n_speed_clamped = clamp( n_speed_current, level.f35.max_speed_vtol, level.f35.speed_plane_max );  // scale from VTOL max to plane max
	self.plane_mode_speed = n_speed_clamped;
	//iprintln( self.plane_mode_speed );
//	self thread say_dialog( "conventional_fligh_034" );  //Conventional flight mode engaged.
	//Eckert - Big jet blast sound
	level.player playsound( "evt_dogfight_blast" );
	self _f35_set_conventional_flight_mode();
	self SetSpeed( self.plane_mode_speed, 150, 150 );	
	f35_scale_speed_to_max();
}

f35_wait_until_path_clear( b_require_push_forward )
{
	// wait until player has clear path forward
	n_frame_counter_collision = 0;
	n_frame_counter_collision_threshold = 20;
	n_update_time = 0.05;
	b_has_clear_path = false;
	b_jet_mode_ready = false;
	
	n_frame_counter_forward = 0;
	n_frame_counter_forward_threshold = 5;  // 0.25s
	
	if ( !IsDefined( b_require_push_forward ) )
	{
		b_require_push_forward = true;
	}
	
	while ( !b_jet_mode_ready )
	{
		// are we going to collide with geo?
		if ( !self.is_collision_imminent )
		{
			n_frame_counter_collision++;
		}
		else 
		{
			n_frame_counter_collision = 0;
		}
		
		b_has_clear_path = ( n_frame_counter_collision > n_frame_counter_collision_threshold );

		// is player pushing forward on the thumbstick?
		if ( player_pressing_forward_on_throttle() )
		{
			n_frame_counter_forward++;
		}
		else 
		{
			n_frame_counter_forward = 0;
		}
		
		b_player_pushing_forward = ( n_frame_counter_forward > n_frame_counter_forward_threshold );
		
		if ( !b_require_push_forward )
		{
			b_player_pushing_forward = true;
		}
		
		//iprintln( "forward: " + n_frame_counter_forward + " collision clear: " + n_frame_counter_collision );
		
		if ( b_has_clear_path && b_player_pushing_forward )
		{
			b_jet_mode_ready = true;
		}
		
		wait n_update_time;
	}	
}

_f35_stop_from_collision()
{	
	e_temp = Spawn( "script_origin", self.origin );
	e_temp.angles = self.angles;
	
	self LinkTo( e_temp );
	
	self waittill( "f35_switch_modes_now" );  // notify sent by mode switch anim on screen touch
	
	self Unlink();
	e_temp Delete();
}

death_blossom_think()
{
	self endon( "death" );
	self endon( "stop_turret_shoot" );
	
	// don't use if Anderson is dead or we're too far along in level
	if ( !flag( "F35_pilot_saved" ) || flag( "trenchrun_done" ) )
	{
		return;
	}
	
	LUINotifyEvent( &"hud_f35_death_blossom" );
	f35_show_console( "tag_display_skybuster" );
	
	e_player = level.player;
	self.death_blossom_active = false;
	n_death_blossom_time_last = 0;	
	n_death_blossom_cooldown = 5;
	n_death_blossom_cooldown_ms = n_death_blossom_cooldown * 1000;
	
	level.player thread f35_death_blossom_watcher();
	death_blossom_cooldown_notification();
	
	while ( IsAlive( self ) )
	{	
		// if guy has target, and presses A, death blossom active
		self.death_blossom_active = false;	
		
		if ( IsDefined( e_player.missileTurretTarget ) && IsDefined( e_player.missileTurretTarget.locked_on ) && ( e_player.missileTurretTarget.locked_on ) && (  e_player SecondaryOffhandButtonPressed() ) )
		{
			n_current_time = GetTime();
			b_cooldown_ok = ( ( n_current_time - n_death_blossom_time_last ) > n_death_blossom_cooldown_ms );
				
			if ( b_cooldown_ok )
			{
				self.death_blossom_active = true;
				n_death_blossom_time_last = n_current_time;
				self FireWeapon();
				delay_thread( n_death_blossom_cooldown, ::death_blossom_cooldown_notification );
				
				wait 0.5;
			}
		}
		
		wait 0.05;
	}
}

death_blossom_cooldown_notification()
{
	//iprintln( "death blossom ready for use" );
}

f35_death_blossom_watcher()
{
	self endon( "death" );
	self endon( "stop_turret_shoot" );
	
	while ( true )
	{
		self waittill( "missile_fire", e_missile, str_weapon_name, e_target );
		
		if ( str_weapon_name == "f35_missile_turret_player" && IsDefined( e_target ) && level.f35.death_blossom_active )
		{
			//iprintln( "death blossom fired" );
			e_missile thread f35_death_blossom( e_target );	
		}
	}
}

f35_death_blossom( target )
{
	self waittill( "death" );
	
	vehicles = GetVehicleArray( "axis" );
	
	excluded = [];
	excluded[0] = target;
	
	blossom_radius = 100000;
	
	if ( IsDefined( self ) && IsDefined( self.origin ) )
	{
		v_origin = self.origin;
	}
	else
	{
		v_origin = target.origin;
	}
	
	sort_vehicles = get_array_of_closest( v_origin, vehicles, excluded, 8, blossom_radius );
	
	for ( i = 0; i < sort_vehicles.size; i++ )
	{
		MagicBullet( "f35_death_blossom", self.origin, sort_vehicles[i].origin, level.player, sort_vehicles[i], ( 0, 0, 0 ) );
	}
	
	self delete();
}

f35_damage_callback(eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName)
{
	n_heavy_threshold = 100;
	
	if ( IsPlayer( eAttacker ) )
	{			
		iDamage = 0;
	}
	else if ( IsDefined( type ) && ( type == "MOD_CRUSH" ) )
	{
		iDamage = 0;
	}
	else if ( IsAI( eAttacker ) )
	{
		str_team = eAttacker.team;
		
		if ( str_team == "allies" )  // don't take damage from friendly AI
		{
			return 0;
		}
		else if ( str_team == "axis" )
		{
			iDamage = 1;
			
			if ( IsSubstr( sWeapon, "rpg" ) )
			{
				// Play sound of RPG hitting plane
				level.player PlaySound ("prj_missile_impact_f35");
				iDamage = 150;
			}
		}
	}
	else if ( eAttacker == level.convoy.vh_van )
	{
		iDamage = 0;
	}
	else if ( IS_VEHICLE( eAttacker ) )
	{
	    if ( eAttacker.vteam == "allies" )  // don't take damage from other cougars
	    {
			iDamage = 0;
	    }
	    else if ( sWeapon == "pegasus_missile_turret_doublesize" )
	    {
	    	iDamage = 0;
	    	
	    	if ( flag( "missile_can_damage_player" ) )
	    	{
	    		iDamage = 2500;
	    		level.f35 notify( "missile_hit_player" );
	    	}
	    }
	    else if ( IS_PEGASUS( eAttacker ) )
		{
//			iDamage = 100;
		}
	    else if ( IS_AVENGER( eAttacker ) )
		{
//			iDamage = 100;
		} 
		else if ( eAttacker.vehicletype == "civ_pickup_red_wturret_la2" )
		{
			iDamage = 10;
		}
		else 
		{
			/#println( "unhandled vehicle type on F35" + self.vehicletype );#/
		}
	}
	else
	{
		str_weapon = "UNKNOWN";
		
		if ( IsDefined( sWeapon ) )
		{
			str_weapon = sWeapon;
		}
		
		/#println( "unhandled damage source on F35: " + eAttacker.classname + " weapon = " + str_weapon );#/
	}
	
	str_rumble = "damage_light";  // both damage_light and damage_heavy precached in _load.gsc
	n_earthquake_magnitude = 0.05;
	n_earthquake_duration = 0.3;
	
	if ( iDamage > n_heavy_threshold )
	{
		str_rumble = "damage_heavy";
		n_earthquake_magnitude = 0.3;
		n_earthquake_duration = 0.5;
	}
	
	if ( iDamage > 0 )
	{
		level.player PlayRumbleOnEntity( str_rumble );
		Earthquake( n_earthquake_magnitude, n_earthquake_duration, level.player.origin, 512, level.player );
		self f35_try_to_play_damage_bink();	
	}
	
	if ( !IsGodMode( level.player ) )
	{
		self.health_regen.health -= iDamage;
	}
	
	if ( ( iDamage > 0 ) && ( flag( "convoy_at_dogfight" ) ) )
	{
		//level.player DoDamage( iDamage, level.player.origin );
		iDamage = 1;	
	}
	
	if ( IsDefined( level.f35_damage_shader ) )
	{
		time = GetTime();
		if ( ( time - level.n_last_damage_time ) > 1000 )
		{			
			level.f35_damage_shader.alpha = 0.1;
			level.f35_damage_shader FadeOverTime( 0.1 );
			level.n_last_damage_time = GetTime();
		}
	}		
	
	//C. Ayers: Play Sounds on Bullet Impacts - Shawn J adding in building impacts/alarm
	if (type == "MOD_UNKNOWN")
	{
		level.player playsound( "evt_collision_alarm" );	
	}
	else if( iDamage > 0 && !IsSubstr( sWeapon, "rpg" ) && sWeapon != "pegasus_missile_turret_doublesize" )
	{
		level.player playsound( "prj_bullet_impact_f35" );
	}
	
	// handle death
	if ( ( ( self.health_regen.health - iDamage ) <= 0 ) || ( ( self.health - iDamage ) <= 0 ) )
	{
		if ( !flag( "eject_sequence_started" ) )
		{
//			if( !IsDefined( level.deadquote_override ) )  // check to see if we're using deadquote already
//			{
//				SetDvar( "ui_deadquote", &"LA_2_F35_DEAD" );
//			}
			
			if( !level.sndF35_death_sound )
			{
				level.player PlayLocalSound( "evt_player_death" ); 
				level.sndF35_death_sound = true;
			}
			
			if ( !maps\la_utility::is_greenlight_build() )
			{
				PlayFXOnTag( level._effect[ "fa38_exp_interior" ], level.f35, "tag_origin" );
				MissionFailed();
			}
		}
		else 
		{
			iDamage = self.health;
		}
	}
	
	iDamage = 1;
	return iDamage;
}

f35_hud_damage_event()
{
	if ( flag( "missile_event_started" ) )
	{
		if ( IsDefined( level.f35_damage_shader ) )
		{
			level.f35_damage_shader.alpha = 0.0;
			level.f35_damage_shader FadeOverTime( 0.5 );
		}			
		
		return;
	}
	
	LUINotifyEvent( &"hud_damage", 1, 1 );	
	
	while ( 1 )
	{
		wait( 0.5 );
		
		time = GetTime();
		if ( ( time - level.n_last_damage_time ) > 1000 )
		{
			if ( !flag( "missile_event_started" ) )
			{
				LUINotifyEvent( &"hud_damage", 1, -1 );
			}
			
			if ( IsDefined( level.f35_damage_shader ) )
			{
				level.f35_damage_shader.alpha = 0.0;
				level.f35_damage_shader FadeOverTime( 0.5 );
			}				

			return;			
		}
	}
}

f35_scale_speed_to_max()  // self = f35
{
	Assert( IsDefined( self.speed_change_per_frame ), ".speed_change_per_frame is missing on F35! can't use f35_scale_speed_to_max!" );
	Assert( IsDefined( level.f35.speed_plane_max ), "level.f35.speed_plane_max is missing! can't use f35_scale_speed_to_max!" );
	
	// scale speed up to max
	while ( self.plane_mode_speed < level.f35.speed_plane_max )
	{
		f35_scale_speed_up( self.speed_change_per_frame );
		wait 0.05;
	}	
}

f35_scale_speed_to_min()  // self = F35
{
	Assert( IsDefined( self.speed_change_per_frame ), ".speed_change_per_frame is missing on F35! can't use f35_scale_speed_to_min!" );
	Assert( IsDefined( level.f35.speed_plane_min ), "level.f35.speed_plane_min is missing! can't use f35_scale_speed_to_min!" );
	
	// scale speed down to minimum
	while ( self.plane_mode_speed > level.f35.speed_plane_min )
	{
		f35_scale_speed_down( self.speed_change_per_frame );
		wait 0.05;
	}	
}

flyby_feedback_watcher()
{	
	// t_flyby should have vehicle and notplayer checked in Radiant to disable spam
	t_flyby = get_ent( "flyby_feedback_trigger", "targetname", true );
	t_flyby EnableLinkTo();
	
	// trigger_radius height is based at bottom of cylinder, so put in middle of plane
	n_z_offset = ( t_flyby.height * 0.5 );  
	v_link_offset = ( 0, 0, n_z_offset );
	
	t_flyby.origin = self.origin - v_link_offset;
	t_flyby LinkTo( self );
	
	while ( true )
	{
		t_flyby waittill( "trigger", e_triggered );
		
		if ( ( e_triggered != self ) && IS_PLANE( e_triggered ) )
		{
			e_triggered thread flyby_feedback( t_flyby );
		}
	}
}

flyby_feedback( t_flyby )
{
	self endon( "death" );
	
	if ( !IsDefined( self.flyby_feedback_active ) )
	{
		self.flyby_feedback_active = false;
	}
	
	if ( !self.flyby_feedback_active )
	{
		self.flyby_feedback_active = true;
		
		n_earthquake_magnitude = 0.1;
		n_earthquake_duration = 0.6;
		str_rumble = "tank_damage_light_mp";
		n_rumble_delay = 0.5;
		n_rumble_count = 2;
		
		Earthquake( n_earthquake_magnitude, n_earthquake_duration, level.player.origin, 512, level.player );
		level.player thread rumble_loop( n_rumble_count, n_rumble_delay, str_rumble );
		
		while ( self IsTouching( t_flyby ) )
		{
			wait 0.5;
		}
		
		self.flyby_feedback_active = false;
	}
	
	
}


f35_switch_modes()  // self = f35
{
	self endon( "death" );
	
	//iprintlnbold( "F35 switching to jet mode..." );
	
	e_player = level.player;
	n_throttle_threshold_forward = 0.7;
	n_throttle_threshold_reverse = -0.7;	
	n_speed_max = level.f35.speed_plane_max; 
	n_idle_to_max_time = 2.5;
	n_idle_to_max_frames = n_idle_to_max_time * 20;
	n_speed_change_per_frame = n_speed_max / n_idle_to_max_frames;	
	self.speed_change_per_frame = n_speed_change_per_frame;
	n_speed_current = self GetSpeedMPH();
	n_speed_clamped = clamp( n_speed_current, level.f35.max_speed_vtol, level.f35.speed_plane_max );  // scale from VTOL max to plane max
	self.plane_mode_speed = n_speed_clamped;	
	
	flag_wait( "dogfights_story_done" );  
	
	//level.f35 f35_wait_until_path_clear( false );
	
	// transition to jet mode
	if ( !flag( "dogfight_done" ) )
	{
		//iprintln( self.plane_mode_speed );
//		self thread say_dialog( "conventional_fligh_034" );  //Conventional flight mode engaged.
		//self _f35_set_conventional_flight_mode();
		//Eckert - Big jet blast sound
		level.player playsound( "evt_dogfight_blast" );
		self thread _f35_set_vtol_mode_v2();
		//self _f35_set_vtol_fast_mode();
		//self SetSpeed( self.plane_mode_speed, 1000, 1000 );	
	
		//f35_scale_speed_to_max();
		
		level.player thread f35_tutorial( false, false, false, false, true, true );
	}
	
	flag_wait( "dogfight_done" );
	
	if ( !flag( "trenchruns_start" ) )
	{
		f35_scale_speed_to_min();
	
		// transition to VTOL mode smoothly
		b_player_within_range = false;
		n_distance = 16000;
		n_distance_sq = n_distance * n_distance;
		
		while ( !b_player_within_range )
		{
			n_distance_current_sq = DistanceSquared( level.convoy.vh_potus.origin, level.player.origin );
			
			if ( n_distance_sq > n_distance_current_sq )
			{
				b_player_within_range = true;
			}
			
			wait 0.1;
		}	
		
		if ( !self.is_vtol )
		{
			self _f35_set_vtol_mode( undefined, true );
		}	
	}
}

_f35_set_vtol_fast_mode()
{

//	self thread _f35_conventional_flight_mode_throttle();
	
	n_airspeed_max = 300;
	n_acceleration = 150;
	n_decceleration = 150;
	n_aim_assist_distance = 100000;
	n_height_mesh_max_dist = 7000;  // 7000
	n_height_mesh_min_dist = -2300;  // -4300
	
//	self SetVehMaxSpeed( n_airspeed_max );
//	self SetSpeed( n_airspeed_max, n_acceleration, n_decceleration );	
	
	level.f35 thread anim_f35_mode_switch();
	level.f35 waittill( "f35_switch_modes_now" );
	self SetVehicleType( "plane_f35_player_vtol_fast" );  		
	level.player VisionSetNaked( "helmet_f35", 0.5 );
	
	SetSavedDvar( "vehicle_sounds_cutoff", 30000 );
	level.player SetClientDvar( "cg_fov", 70 );	
	level.player SetClientDvar("aim_assist_min_target_distance", n_aim_assist_distance );   	
	
	// enable air flight mesh then lock to it
	self SetHeliHeightLock( false );
	/*
	SetHeliHeightPatchEnabled( "air_section_height_mesh", true );
	SetHeliHeightPatchEnabled( "ground_section_height_mesh", false );
	self SetHeliHeightLock( true );
	*/
	
	// set min/max offset from height mesh
	level.player SetClientDvar( "vehHelicopterMaxHeightLockOffset", n_height_mesh_max_dist );
	level.player SetClientDvar( "vehHelicopterMinHeightLockOffset", n_height_mesh_min_dist );	
	
	//SOUND - Shawn J
	//iprintlnbold ("conventional flight");
	self playsound ("veh_vtol_disengage_c");
	
	self.is_vtol = false;
	
	level.player update_ember_fx( "embers_on_player_in_f35_plane" );
}

f35_scale_speed_up( n_change, n_manual )
{
	n_speed_max = level.f35.speed_plane_max; 
	// n_speed_max = level.f35.speed_plane_max;  // implement when executables posted
	n_speed_current = self.plane_mode_speed;
	n_speed_new = n_speed_current + n_change;
	n_acceleration = 150;
	n_decceleration = 150;	
	b_use_manual = IsDefined( n_manual );
	
	if ( b_use_manual )
	{
		self.plane_mode_speed = n_manual;
		self SetSpeed( n_manual, n_acceleration, n_decceleration );
	}
	else if ( n_speed_new < n_speed_max )
	{
		self.plane_mode_speed = n_speed_new;
		self SetSpeed( n_speed_new, n_acceleration, n_decceleration );
		//iprintln( self.plane_mode_speed );
	}
	else if ( n_speed_new >= n_speed_max )  // clamp to max speed if we're just below it
	{
		self.plane_mode_speed = n_speed_max;
		self SetSpeed( n_speed_max, n_acceleration, n_decceleration );
	//	iprintln( self.plane_mode_speed );
	}
}

f35_scale_speed_down( n_change, n_manual )
{
	n_speed_current = self.plane_mode_speed;
	n_speed_new = n_speed_current - n_change;
	n_speed_min = level.f35.speed_plane_min;
	n_acceleration = 150;
	n_decceleration = 150;	
	b_use_manual = IsDefined( n_manual );
	
	if ( b_use_manual )
	{
		self.plane_mode_speed = n_manual;
		self SetSpeed( n_manual, n_acceleration, n_decceleration );
	}
	else if ( n_speed_new > n_speed_min )
	{
		self.plane_mode_speed = n_speed_new;	
		self SetSpeed( n_speed_new, n_acceleration, n_decceleration );
	}
	else if ( n_speed_new <= n_speed_min )
	{
		self.plane_mode_speed = n_speed_min;
		self SetSpeed( n_speed_min, n_acceleration, n_decceleration );
	}
	
//	iprintln( self.plane_mode_speed );
}

// get x coordinate of left thumbstick
get_throttle_position()  // self = player
{
	v_stick_position = self GetNormalizedMovement();
	
	n_throttle_forward = v_stick_position[ 0 ];
	
	return n_throttle_forward;
}

_f35_set_conventional_flight_mode()
{	
//	self thread _f35_conventional_flight_mode_throttle();
	
	n_airspeed_max = 300;
	n_acceleration = 150;
	n_decceleration = 150;
	n_aim_assist_distance = 100000;
	n_height_mesh_max_dist = 7000;  // 7000
	n_height_mesh_min_dist = -2300;  // -4300
	
//	self SetVehMaxSpeed( n_airspeed_max );
//	self SetSpeed( n_airspeed_max, n_acceleration, n_decceleration );	
	
	level.f35 thread anim_f35_mode_switch();
	level.f35 waittill( "f35_switch_modes_now" );
	self SetVehicleType( "plane_f35_player" );  		
	
	SetSavedDvar( "vehicle_sounds_cutoff", 30000 );
	level.player SetClientDvar( "cg_fov", 70 );	
	level.player SetClientDvar("aim_assist_min_target_distance", n_aim_assist_distance );   	
	
	// enable air flight mesh then lock to it
	self SetHeliHeightLock( false );
	SetHeliHeightPatchEnabled( "air_section_height_mesh", true );
	SetHeliHeightPatchEnabled( "ground_section_height_mesh", false );
	self SetHeliHeightLock( true );
	
	// set min/max offset from height mesh
	level.player SetClientDvar( "vehHelicopterMaxHeightLockOffset", n_height_mesh_max_dist );
	level.player SetClientDvar( "vehHelicopterMinHeightLockOffset", n_height_mesh_min_dist );	
	
	//SOUND - Shawn J
	//iprintlnbold ("conventional flight");
	self playsound ("veh_vtol_disengage_c");
	
	self.is_vtol = false;
	
	level.player update_ember_fx( "embers_on_player_in_f35_plane" );
}



f35_startup_console( e_player_rig )
{
	if ( !IsDefined( level.f35.base_console ) )
	{
		level.f35.base_console = "tag_display_flight";		
	}
	
	level.f35 ShowPart( level.f35.base_console );
	f35_show_console();
}

f35_init_console()
{
	if ( level.f35.model == "veh_t6_air_fa38" )
	{
		level.f35 HidePart( "tag_display_flight" );
		level.f35 HidePart( "tag_display_standby" );
		level.f35 HidePart( "tag_display_message" );	
		level.f35 HidePart( "tag_display_damage" );		
		level.f35 HidePart( "tag_display_eject" );	
		level.f35 HidePart( "tag_display_skybuster" );
		level.f35 HidePart( "tag_display_malfunction" );
		level.f35 HidePart( "tag_display_missiles_agm" );
		level.f35 HidePart( "tag_display_missiles_aam" );		
	
		level.f35.base_console = "tag_display_flight";
		level.f35.current_console = undefined;
		
		f35_show_console( "tag_display_standby" );	
	}
}

f35_show_console( console )
{
	if ( level.f35.model == "veh_t6_air_fa38" )
	{
		// Flight off when damage and standby
		if ( IsDefined( level.f35.current_console ) )
		{
			level.f35 HidePart( level.f35.current_console );
		}

		level.f35.current_console = console;			
		
		if ( IsDefined( console ) )
		{
			if ( console == "tag_display_damage" )
			{
				level.f35 HidePart( level.f35.base_console );			
			}
			
			level.f35 ShowPart( level.f35.current_console );
		}	
	}
}

f35_show_base_console()
{
	level.f35 ShowPart( level.f35.base_console );		
}

f35_try_to_play_damage_bink()  // self = f35
{
	if ( !IsDefined( self.current_console ) || self.current_console != "tag_display_damage" )
	{
		level.f35 thread f35_damage_bink();
	}
}

f35_damage_bink()
{
	//C. Ayers: Adding in Static Hits for this
	level.player playsound( "prj_bullet_impact_f35_static" );
	
	f35_show_console( "tag_display_damage" );
	
	wait 0.40;  // hardcoded bink duration since GetCinematicTimeRemaining could return incorrect value
	
	f35_show_console();
	f35_show_base_console();

}

anim_f35_mode_switch() 
{
	// note: "F35_mode_switch_now" notify comes from anim notetrack	
		
	//maps\_scene::run_scene( "f35_switch_modes_now" );
	level.player.body = spawn_anim_model( "player_body", level.player.origin );
	level.player.body.angles = level.player.angles;
	level.player.body LinkTo( level.f35, "tag_driver" );
	level.player.body maps\_anim::anim_single( level.player.body, "F35_mode_switch" );
	
	if ( IsDefined( level.player.body ) )
	{
		level.player.body Delete();		
	}
}

_f35_conventional_flight_mode_throttle()
{
	self endon( "F35_mode_switch_vtol" );
	
	n_mode_switch_time = 1;  // in seconds
	n_mode_switch_frames = n_mode_switch_time * 20;
	b_using_throttle = false;
	n_counter = 0;
	
	while ( !b_using_throttle )
	{
		if ( player_pressing_forward_on_throttle() )
		{
			n_counter++;
		}
		else 
		{
			n_counter = 0;
		}
		
		if ( n_counter > n_mode_switch_frames )
		{
			b_using_throttle = true;
		}
		
		wait 0.05;
	}
	
	//SOUND - Shawn J
	//iprintlnbold ("conventional flight");
	self playsound ("veh_vtol_disengage_c");
	
	self SetVehicleType( "plane_f35_player" );  
}

player_pressing_forward_on_throttle()
{
	n_threshold = 0.7;
	b_pressing_forward = false;
	
	v_movement = level.player GetNormalizedMovement();
	//iprintln( v_movement[0] );
	
	if ( v_movement[ 0 ] > n_threshold )
	{
		b_pressing_forward = true;
	}
	
	return b_pressing_forward;
}

_f35_set_vtol_mode( b_is_first_time, b_use_force_protection_vo )
{	
	n_airspeed_max = 120;
	n_acceleration = 200;
	n_decceleration = 200;
	n_aim_assist_distance = 100000;
	n_height_mesh_max_dist = 120;  // 800
	n_height_mesh_min_dist = -120;	 // 0
	
	b_set_speed = true;
	
	if ( !IsDefined( b_is_first_time ) )
	{
		b_is_first_time = false;
	}
	
	if ( b_is_first_time )
	{
		b_set_speed = false;
	}
	
	if ( !IsDefined( b_use_force_protection_vo ) )
	{
		b_use_force_protection_vo = false;
	}
	
	if ( !b_is_first_time )
	{
		level.f35 thread anim_f35_mode_switch();
		level.f35 waittill( "f35_switch_modes_now" );
		level.player VisionSetNaked( "helmet_f35_low", 0.5 );
		
		if ( b_use_force_protection_vo )
		{
			level.f35 thread say_dialog( "switching_to_vtol_071" );  //Switching to VTOL force protection mode.
		}		
		else 
		{
			self thread say_dialog( "vtol_flight_mode_e_033" );  //VTOL flight mode engaged.
		}
	}	
	
	//SOUND - Shawn J
	//iprintlnbold ("vtol mode");
	self playsound ("veh_vtol_engage_c");
	
	self SetVehicleType( "plane_f35_player_vtol" );  	
	
	// when switching modes, make sure plane mode's SetSpeed call doesn't mess up vtol mode
	if ( b_set_speed )
	{
		n_speed_current = self GetSpeedMPH();
		n_speed_final = clamp( n_speed_current, 0, level.f35.max_speed_vtol );
		self.plane_mode_speed = n_speed_final;
		self SetSpeed( n_speed_final, n_acceleration, n_decceleration );
	}
	
	// enable ground flight mesh then lock to it
	self SetHeliHeightLock( false );
	SetHeliHeightPatchEnabled( "air_section_height_mesh", false );
	SetHeliHeightPatchEnabled( "ground_section_height_mesh", true );
	self SetHeliHeightLock( true );
		
	// don't reattach to the height mesh during dogfights
	if ( flag( "convoy_at_dogfight" ) && !flag( "dogfight_done" ) )
	{
//		self SetHeliHeightLock( false );
	}
	
	// set min/max offset from height mesh
	level.player SetClientDvar( "vehHelicopterMaxHeightLockOffset", n_height_mesh_max_dist );
	level.player SetClientDvar( "vehHelicopterMinHeightLockOffset", n_height_mesh_min_dist );	
	
	self.is_vtol = true;
	level.player update_ember_fx( "embers_on_player_in_f35_vtol" );
	

}


#define PLANE_MODE 0
#define VTOL_MODE 1
#define MIN_DOGFIGHT_FLY_HEIGHT_PLAYER 1200
	
_f35_set_vtol_mode_v2()
{
	level endon( "dogfight_done" );
	level.f35 endon( "death" );
	
	SetHeliHeightPatchEnabled( "ground_section_height_mesh", false ); //-- doesn't matter which mode i am in, this is true
	SetHeliHeightPatchEnabled( "air_section_height_mesh", true ); 
	self SetHeliHeightLock( false );
	
	self SetVehicleType( "plane_f35_player_vtol_fast" ); //-- make sure you get proper speed //TODO: tie this into the "fixed wing flight mode" VO
	//self thread do_flight_feedback();
	current_mode = VTOL_MODE;
	n_time_strafing = 0;
	
	level.f35.max_speed_vtol_dogfight = ( level.f35 GetMaxSpeed() ) / 17.6;  // max GDT speed. used for clamp value on npc plane speeds - returns units/sec, need mph
	
	while( true )
	{		
		if( self.origin[2] < MIN_DOGFIGHT_FLY_HEIGHT_PLAYER )
		{
			if( current_mode != PLANE_MODE && self _f35_flying_upwards() )
			{
				self SetVehicleType( "plane_f35_player_vtol_fast" );
				self clientNotify ("snd_jet_start");
				current_mode = PLANE_MODE;
				
				level.player update_ember_fx( "embers_on_player_in_f35_plane" );
			}
		}
		else
		{
			should_be_flying = self _f35_should_be_flying();
				
			if( should_be_flying )
			{
				if(current_mode != PLANE_MODE)
				{
					self SetVehicleType( "plane_f35_player_vtol_fast" );
					self clientNotify ("snd_jet_start");
					current_mode = PLANE_MODE;
							
					level.player update_ember_fx( "embers_on_player_in_f35_plane" );
				}
			}
//			else if( current_mode != VTOL_MODE && !should_be_flying )//-- if the control stick is only kind of pressed, then vtol mode
//			{
//				level.player FreezeControls( true );
//				
//				//-- Slow the vehicle down some
//				self LaunchVehicle( VectorNormalize(self.velocity) * -200 * 0.05 );
//				wait 0.05;
//				self LaunchVehicle( VectorNormalize(self.velocity) * -200 * 0.05 );
//				wait 0.05;
//				self LaunchVehicle( VectorNormalize(self.velocity) * -200 * 0.05 );
//				wait 0.05;
//				
//				self SetVehicleType( "plane_f35_player_vtol_dogfight" );
//				level.player update_ember_fx( "embers_on_player_in_f35_vtol" );
//				self clientNotify ("snd_vtol_start");
//				current_mode = VTOL_MODE;
//				
//				wait 0.1;
//				
//				level.player FreezeControls( false );
//			}
		}
		
		wait 0.05;
	}
}

//-- look into making this a macro if it's going to get check every frame
_f35_should_be_flying()
{
	if(Length(self.velocity) == 0 ) //-- the plane isn't moving and we don't want to divide by 0
	{
		return false;
	}
	
	plane_speed = VectorDot( self.velocity, AnglesToForward( self.angles ))  / 17.6;
	plane_dot = plane_speed / Length(self.velocity) * 17.6;
	
	if( (plane_speed > 150 && plane_dot > 0.6) )
	{
		return true;
	}
	
	return false;
}


_f35_flying_upwards()
{
	if( !(self.angles[0] <= 180 && self.angles[0] >= 0) )
	{
		return true;
	}
	
	return false;
}

_restore_f35_health()  // self = f35
{
	n_health_restored = Int( self.health_regen.health_max * self.health_regen.percent_life_at_checkpoint );
	self.health_regen.health = n_health_restored;
}

approach_point_claim( n_index )
{
	// claim point
	level.f35.a_goal_index[ n_index ] = true;
	level.f35.n_goal_ents_occupied++;

	// waittill death or special notify to free up point	
	self thread approach_point_unclaim( n_index );
}

approach_point_unclaim( n_index )
{
	self waittill_either( "death", "free_approach_point" );
	level.f35.a_goal_index[ n_index ] = false;
	level.f35.n_goal_ents_occupied--;
}


// this can draw a line to infinity if it's not passed a known point. be careful running this.
_can_bullet_hit_target( v_start_pos, e_target )  // self = ent that needs trace (not used)
{
	Assert( IsDefined( v_start_pos ), "v_start_pos is a required parameter for _can_bullet_hit_target" );
	Assert( IsDefined( e_target ), "e_target is a required parameter for _can_bullet_hit_target" );
	
	v_start_current = v_start_pos;
	v_end_pos = e_target.origin;
	b_trace_done = false;
	b_hit_target = false;
	n_distance_to_target = DistanceSquared( v_start_pos, e_target.origin );
	
	while ( !b_trace_done )
	{
		a_trace = BulletTrace( v_start_current, v_end_pos, false, self );
		
		b_hit_surface = ( a_trace[ "surfacetype" ] != "none" );
		b_hit_ent = ( IsDefined( a_trace[ "entity" ] ) );

		if ( b_hit_surface || b_hit_ent )
		{
			b_trace_done = true;
			
			if ( b_hit_ent && ( e_target == a_trace[ "entity" ] ) )
			{
				b_hit_target = true;
			}
		}
		else  // this means bullet trace didn't connect with anything at 8k unit threshold
		{
			v_start_current = a_trace[ "position" ];
			
			n_distance_current = DistanceSquared( v_start_pos, v_start_current );
			
			if ( n_distance_current >= n_distance_to_target )
			{
				b_trace_done = true;
			}
		}
	}
	
	return b_hit_target;
}

f35_tutorial( b_show_move_prompt, b_show_hover_prompt, b_show_weapon_prompt, b_show_ads_prompt, b_show_death_blossom_prompt, b_show_speed_boost_prompt )  // self = player
{	
	if ( !IsDefined( b_show_move_prompt ) )
	{
		b_show_move_prompt = true;
	}

	if ( !IsDefined( b_show_hover_prompt ) )
	{
		b_show_hover_prompt = true;
	}	
	
	if ( !IsDefined( b_show_weapon_prompt ) )
	{
		b_show_weapon_prompt = true;
	}	
	
	if ( !IsDefined( b_show_ads_prompt ) )
	{
		b_show_ads_prompt = true;
	}		
	
	if ( !IsDefined( b_show_death_blossom_prompt ) )
	{
		b_show_death_blossom_prompt = false;
	}
	
	if ( !IsDefined( b_show_speed_boost_prompt ) )
	{
		b_show_speed_boost_prompt = false;	
	}
	
	if ( b_show_move_prompt )
	{
		// press LS to move, 2) press RS to look
		self f35_tutorial_func( &"LA_2_FLIGHT_CONTROL_MOVE", &"LA_2_FLIGHT_CONTROL_LOOK", ::f35_control_check_movement );
	}
	
	if ( b_show_hover_prompt )
	{
		// press RB to hover up
		self f35_tutorial_func( &"LA_2_FLIGHT_CONTROL_HOVER_UP", &"LA_2_FLIGHT_CONTROL_HOVER_DOWN", ::f35_control_check_hover );
	}
	
	if ( b_show_weapon_prompt )
	{
		// press RT for cannons, 2) press LT for missiles
		self f35_tutorial_func( &"LA_2_FLIGHT_CONTROL_GUN", &"LA_2_FLIGHT_CONTROL_MISSILE", ::f35_control_check_weapons );	
	}
	
	if ( b_show_ads_prompt )
	{
		// press RS to zoom
		//self f35_tutorial_func( &"LA_2_HINT_ADS", undefined, ::f35_control_check_ads );  // - removed ADS prompt. -TravisJ 10/24/2011
	}
	
	if ( b_show_speed_boost_prompt )
	{
		self f35_tutorial_func( &"LA_2_HINT_SPEED_BOOST", undefined, ::f35_control_check_boost, undefined, -30 );
	}
	
	if ( b_show_death_blossom_prompt )
	{
		if ( flag( "F35_pilot_saved" ) )
		{
			self f35_tutorial_func( &"LA_2_HINT_DEATHBLOSSOM", undefined, ::f35_control_check_deathblossom, undefined, -30 );
			level.player say_dialog( "f38c_sky_buster_online_0" );
		}
	}
	
	// press X for missile barrage
	// TODO: implement
	flag_set( "tutorial_done" );
}


f35_tutorial_func( str_message_1, str_message_2, func_button_check, str_flag, n_offset_y = (-60) )
{
	n_polling_delay = 0.05;  // how often button inputs are checked
	n_hint_remove_delay = 2;  // time before screen message is removed
	n_timeout_length = 5;  // in seconds
	n_timeout_frames = n_timeout_length * 20;
	n_frame_counter = 0;
	b_timeout_hit = false;
	//n_offset_y = -60;  // offset so it doesn't draw on top of F35 hud
	
	screen_message_create( str_message_1, str_message_2, undefined, n_offset_y );
	
	while ( !( self [[ func_button_check ]]() ) && !b_timeout_hit )  // this function should always return a Boolean
	{
		wait n_polling_delay;
		n_frame_counter++;
		
		if ( n_frame_counter >= n_timeout_frames )
		{
			b_timeout_hit = true;
		}
	}
	
	wait n_hint_remove_delay;
	
	screen_message_delete();
}


f35_control_check_hover()
{
	b_is_pressing_button = ( ( level.player FragButtonPressed() ) || ( level.player SecondaryOffhandButtonPressed() ) );
	
	return b_is_pressing_button;
}

f35_control_check_deathblossom()
{
	b_is_pressing_button = ( level.player JumpButtonPressed() );
	
	return b_is_pressing_button;
}

f35_control_check_mode()
{
	b_is_pressing_button = level.player UseButtonPressed();
	
	return b_is_pressing_button;
}

f35_control_check_movement()
{
	n_threshold = 0.4; // magnitude which registers as a player pressing a thumbstick 
	
	n_look_stick_strength = Length( level.player GetNormalizedCameraMovement() );
	n_move_stick_strength = Length( level.player GetNormalizedMovement() );
	
	b_is_using_look = ( n_threshold < n_look_stick_strength );
	b_is_using_move = ( n_threshold < n_move_stick_strength );
	
	b_is_pressing_button = ( b_is_using_look || b_is_using_move );
	
	return b_is_pressing_button;
}

f35_control_check_weapons()
{
	b_is_pressing_button = ( ( level.player AttackButtonPressed() ) || ( level.player ThrowButtonPressed() ) );
	
	return b_is_pressing_button;
}

f35_control_check_ads()
{
	b_is_pressing_button = ( level.player MeleeButtonPressed() );

	return b_is_pressing_button;
}

f35_control_check_boost()
{
	return level.player SprintButtonPressed();
}

#using_animtree( "fxanim_props" );
f35_interior_damage_anims()
{
	self waittill( "f35_destroy_panels" );
	
	self UseAnimTree( #animtree );
	self anim_single( self, "f35_panels_break", "fxanim_props" );

	n_loop_time = GetAnimLength( %fxanim_la_cockpit_panels_loop_anim );
	
	//self anim_loop( self, "f35_panels_break_loop", "eject_done", "fxanim_props" );
	// fxanim_la_cockpit_panels_loop_anim
	while ( !flag( "eject_sequence_started" ) )
	{
		self SetAnimKnobAll( %fxanim_la_cockpit_panels_loop_anim, %root, 1, n_loop_time, 1 );
		wait n_loop_time;
	}
}

_watch_for_boost() // self == plane
{
	self endon("death");
	self endon("no_driver");

	self.max_speed = 400; //self GetMaxSpeed( true ) / 17.6;
	self.max_sprint_speed = self.max_speed * 1.5;
	self.min_sprint_speed = self.max_speed * 0.75;
	
	self.sprint_meter = 100;
	self.sprint_meter_max = 100;
	self.sprint_meter_min = self.sprint_meter_max * 0.25;
	self.sprint_time = 3;
	self.sprint_recover_time = 10;
		
	bPressingSprint = false;
	bMeterEmpty = false;	
	//sprint_drain_rate = self.sprint_meter_max / self.sprint_time;
	sprint_drain_rate = 0;
	sprint_recover_rate = self.sprint_meter_max / self.sprint_recover_time;
	
	boost_effect_active = false;
	
	notPlayedBoost = true;
	
	while( true )
	{
		speed = self GetSpeedMPH();
		forward = AnglesToForward( self.angles );		
				
		bCanSprint = ( bMeterEmpty == false ) && ( speed > self.min_sprint_speed );
		bPressingSprint = level.player SprintButtonPressed();

		if ( bCanSprint && bPressingSprint )
		{
			self.sprint_meter -= sprint_drain_rate * 0.05; 
			
			// Check for a completely drained sprint meter
			if ( self.sprint_meter < 0 )
			{
				self.sprint_meter = 0;
				bMeterEmpty = true;	
			}
			else
			{
				self SetVehMaxSpeed( self.max_sprint_speed );

				// Speed me up
				if ( speed < self.max_sprint_speed )
				{
					self LaunchVehicle( forward * 400 * 0.05 );
					//IPrintLn( "BOOSTING: " + Int(speed) );
					
					if (notPlayedBoost)
					{
						self clientNotify ("snd_boost_start");
						notPlayedBoost = false;
					}					
				}
				
				if( !boost_effect_active )
				{
					level.player update_ember_fx( "boost_fx" );
					boost_effect_active = true;
				}
				
				level.player PlayRumbleOnEntity( "damage_heavy" );
				Earthquake( 0.15, 0.5, level.player.origin, 1000, level.player );
			}
		}
		else
		{
			self.sprint_meter += sprint_recover_rate * 0.05;
			
			// If the meter was completely drained...don't allow sprint
			// until we've recovered the minimum amount
			if ( bMeterEmpty )
			{
				if ( self.sprint_meter > self.sprint_meter_min )
					bMeterEmpty = false;
			}
			
			if ( self.sprint_meter > self.sprint_meter_max )
				self.sprint_meter = self.sprint_meter_max;

			self SetVehMaxSpeed( self.max_speed );
			
			if (!notPlayedBoost)
			{
				self clientNotify ("snd_boost_end");
				notPlayedBoost = true;
			}
			// Slow me down
			if ( Int(speed) > self.max_speed && IS_FALSE(self.isAssistedFlying)) //-- floating point issue
			{
				//--TODO: need to put something in here so that you don't get slowed,
				//        if you are in the middle of assisted flying
				self LaunchVehicle( forward * -200 * 0.05 );
				IPrintLnBold( "Sprint: Slowing you down" );
			}
			
			if( boost_effect_active )
			{
				level.player update_ember_fx( "embers_on_player_in_f35_plane" );
				boost_effect_active = false;
			}
		
		}	
		
		//IPrintLnBold( "Sprint Meter: " + self.sprint_meter );
		
		wait(0.05);
	}
}

do_flight_feedback()
{
	self endon( "death" );
	level endon( "dogfight_done" );	
	
	while ( 1 )
	{
		level.player PlayRumbleOnEntity( "damage_light" );
		Earthquake( 0.1, 0.15, level.player.origin, 1000, level.player );		
		wait( 0.15 );
	}
}


// Ripped from BO1::Underwaterbase to make vehicle hard to fly like it's heavily damaged
// self = player's FA38
do_very_damaged_feedback()
{
	self endon("death");
	level endon("eject_sequence_started");
//	level waittill("huey_int_dmg_start");

//	self.supportsAnimScripted = true;
//	self.animname = "helicopter";
//	self UseAnimTree(level.scr_animtree["helicopter"]);

//	PlayFXOnTag( level._effect["huey_fire"], self, "tag_origin" );	
//	PlayFXOnTag( level._effect["panel_dmg_md"], self, "tag_spark_l" );
//	PlayFXOnTag( level._effect["panel_dmg_md"], self, "tag_spark_r" );

//	self SetAnim(level.scr_anim["helicopter"]["heli_crash_spin_right"], 1, 0.1, 0.1);

	vel = 0;
	max_vel = 30.0;

	spin = false;
	spin_time = 4.0;

	self SetViewClamp( level.player, 0, 0, 15, 20);

	while (1)
	{
		r_stick = level.player GetNormalizedCameraMovement();

		if (spin)
		{
			spin_time -= 0.05;
			if (spin_time < 2.0 && spin_time > 0.0)
			{
				if (r_stick[1] < 0.0)
				{
					spin = false;
				}
			}
			else if (spin_time <= 0.0)
			{
				spin = false;
			}
		}
		else
		{
			desired_vel = max_vel * r_stick[1];
			vel = DiffTrack(desired_vel, vel, 0.5, 0.05);
		}

		angular_vel = self GetAngularVelocity();
		angular_vel = (angular_vel[0], angular_vel[1] - vel, angular_vel[2]);
		self SetAngularVelocity(angular_vel);

//		level.player PlayRumbleOnEntity("flyby");
		Earthquake(0.1, 1, self.origin, 512);

		wait(0.05);
	}
}

f35_ads_toggle()
{
	self endon("death");
	level endon("end_player_heli");

	ads_active = false;

	//0 == down; 1 == up; 2 == pressed; 3 == released (doing this to avoid more script strings)  
	button_state = 1; 

	while (1)
	{
		if(self MeleeButtonPressed())
		{
			// makes sure fast presses are counted.
			if(button_state == 1 || button_state == 3)	//if "up" or "released"
			{
				button_state = 2;	//set to "pressed"
			}
			else if(button_state == 2)	//if still "pressed"
			{
				button_state = 0;	//set to down  
			}
		}
		else
		{
			//make sure fast releases are counted
			if(button_state == 0 || button_state == 2)	//if "down" or "pressed"
			{
				button_state = 3;	//set to "released" 
			}
			else if(button_state == 3 )	//if still "released"
			{
				button_state = 1;	//set to "up" 
			}
		}

		// if the button was "pressed" 
		if(button_state == 2 ) 
		{
			// handle toggle
			if (!ads_active)
			{
				// do ads
				ads_active = true;

				// zoom fov
				self SetClientDvar( "cg_fov", level.huey_zoom_fov );
			}
			else 
			{
				// disable ads
				ads_active = false;

				// normal fov
				self SetClientDvar( "cg_fov", level.huey_fov );
			}
		}

		wait(0.05);
	}
}
